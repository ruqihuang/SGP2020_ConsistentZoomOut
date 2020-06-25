function maps_out = collection_2_pointmaps(Basis, G, LM)

if nargin < 3
    LM = cell(size(Basis));
    for i = 1:length(Basis)
        LM{i} = 1:length(Basis{i}); 
    end
end


G_ind = double(G~=0); 
G_ind = G_ind - diag(diag(G_ind)); 

[I, J] = find(G_ind); 
M = cell(length(I), 1); 


parfor i = 1:length(I)
    sId = I(i);
    tId = J(i); 
    M{i} = annquery(Basis{tId}', (Basis{sId}(LM{sId}, :))', 1)'; 
end

maps_out = cell(size(G)); 
for i = 1:length(I)
    sId = I(i);
    tId = J(i); 
    maps_out{sId, tId} = M{i}; 
end