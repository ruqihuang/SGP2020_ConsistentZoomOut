function F = convert_fmaps(Shapes, Maps, G, neig)

if nargin < 4
    neig = size(Shapes{1}.evecs, 2); 
end

ns = length(Shapes); 
F = cell(ns); 

for i = 1:ns
    for j = 1:ns
        F{i, j} = zeros(neig); 
    end
end


for i = 1:ns
    for j = 1:ns
        if G(j, i) ~= 0
            F{i, j} = Shapes{j}.evecs(:, 1:neig)\Shapes{i}.evecs(Maps{j, i}, 1:neig);
        end
    end
end

