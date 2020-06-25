function [Fmaps, Maps]= fmaps_from_basis(shapes, sub, Basis, G, neig)

[I, J] = find(G); 

F = cell(length(I), 1); 
parfor k = 1:length(I)
    i = I(k); 
    j = J(k); 
    maps{k} = annquery(Basis{i}', Basis{j}', 1)'; 
    F{k} = shapes{j}.evecs(sub{j}, 1:neig)\shapes{i}.evecs(sub{i}(maps{k}), 1:neig); 
end

Maps = cell(length(G)); 

for k = 1:length(I)
    i = I(k); 
    j = J(k); 
    Maps{j, i} = maps{k};
end

   

Fmaps = cell(length(shapes)); 
for k = 1:length(I)
    Fmaps{I(k), J(k)} = F{k}; 
end

for i = 1:length(shapes)
    for j = 1:length(shapes)
        if G(i, j) == 0
            Fmaps{i,j} = zeros(neig); 
        end
    end
end