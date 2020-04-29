function correctedBlock = hardDecoding(codeword,H, maxiter)

    % H = N-K*N = r*c
[r,c] = size(H);

correctedBlock = codeword;
v_nodes = codeword;


iter=1;
while(sum(correctedBlock*H.')~=0 && iter<=maxiter)
    v_nodes_new = zeros(r,c);
    % STEP 1 : Calcule response of the c-nodes for every v-node
    for i = 1:r
        v_nodes_index = find(H(i,:));
        for j = 1:length(v_nodes_index)
            index = v_nodes_index;
            index(j)=[];
            v_nodes_new(i,v_nodes_index(j))=mod(sum(v_nodes(index)),2);
        end  
    end
    % STEP 2 : Majority voting
    for j = 1:c
        c_nodes_index = find(H(:,j));
        v_nodes_sent = v_nodes_new(:,j);
        majority = (v_nodes(j)+sum(v_nodes_sent(c_nodes_index)))/(1+length(c_nodes_index));
        if(majority>0.5)
            correctedBlock(j)=1;
        elseif(majority==0.5)
            correctedBlock(j)=v_nodes(j);
        else
            correctedBlock(j)=0;
        end
    end
    v_nodes=correctedBlock;
    iter=iter+1;
end

% disp("iter =");
% disp(iter-1);

end