function T = extract_3_cycles(G)

% enumerate all 3 cycles from a graph G. 
G = double(G~=0); 
G = G - diag(diag(G)); 

assert(norm(G - G', 'fro') == 0); 

nv = length(G); 

T_cycle = []; 
for i = 1:nv
    for j = 1:i-1
        for k = 1:j-1
            if ((G(i, j)&&G(j, k))&&G(k, i))
                T_cycle = [T_cycle; [i, j, k]; [k, j, i]]; 
            end
        end
    end
end

T.cycle = T_cycle; 

[I, J] = find(G);

edge = [I, J]; 
T.edge = edge; 

edge_loop = cell(length(I), 1); 

for i = 1:length(I)
    edge_loop{i} = []; 
end
A = zeros(length(T_cycle), length(edge)); 

for i = 1:size(T_cycle, 1)
    p1 = [T_cycle(i, 1), T_cycle(i, 2)];
    p2 = [T_cycle(i, 2), T_cycle(i, 3)]; 
    p3 = [T_cycle(i, 3), T_cycle(i, 1)]; 
    
    [i1] = ismember(edge, p1, 'rows'); 
    i1 = find(i1 == 1);
    edge_loop{i1} = [edge_loop{i1}, i]; 
    [i2] = ismember(edge, p2, 'rows'); 
    i2 = find(i2 == 1);
    edge_loop{i2} = [edge_loop{i2}, i]; 
    [i3] = ismember(edge, p3, 'rows'); 
    i3 = find(i3 == 1); 
    edge_loop{i3} = [edge_loop{i3}, i]; 
    
    A(i, i1) = 1; 
    A(i, i2) = 1; 
    A(i, i3) = 1; 
end
T.A = A; 
T.edge_loop = edge_loop; 


