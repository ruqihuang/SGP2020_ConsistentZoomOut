
function [W_computed, Fmaps_updated, dist_matrix] = ICSM_weight(Fmaps, T)

% Given a set of functional maps, and the topology graph of the network,
% output the weight matrix excluding the bad edges from the network.



T_cycle = T.cycle; 
ncycles = size(T_cycle, 1); 
cost_per_cycle = zeros(ncycles, 1); 
nshapes = length(Fmaps); 

for i = 1:ncycles
    i1 = T_cycle(i, 1); 
    i2 = T_cycle(i, 2); 
    i3 = T_cycle(i, 3); 
    
    C11 = Fmaps{i3, i1}*Fmaps{i2, i3}*Fmaps{i1, i2}; e11 = norm(C11 - eye(size(C11)), 'fro'); 
    C22 = Fmaps{i1, i2}*Fmaps{i3, i1}*Fmaps{i2, i3}; e22 = norm(C22 - eye(size(C11)), 'fro');
    C33 = Fmaps{i2, i3}*Fmaps{i1, i2}*Fmaps{i3, i1}; e33 = norm(C33 - eye(size(C11)), 'fro');
    
    
    cost_per_cycle(i) = max(max(e11, e22), e33); 
end

% cost_per_cycle_odd = cost_per_cycle; 
% cost_per_cycle_odd(2:2:end) = cost_per_cycle(1:2:end);
% cost_per_cycle_even = cost_per_cycle; 
% cost_per_cycle_even(1:2:end) = cost_per_cycle(2:2:end); 

% cost_per_cycle = (cost_per_cycle_even + cost_per_cycle_odd)/2; 


edge = T.edge; 
edge_loop = T.edge_loop; 

W_per_edge = zeros(length(edge), 1); 
for i = 1:length(edge)
    a = edge_loop{i};
    if ~isempty(a)
        W_per_edge(i) = 1/sum(cost_per_cycle(a));
    else 
        W_per_edge(i) = 1e-7; 
    end
end
% x = W_per_edge;

aa = sparse(edge(:, 1), edge(:, 2), W_per_edge, nshapes, nshapes); 
aa = (aa + aa')/2; 
% % aa = min(aa, aa'); 
% % aa = aa'; 
[~, ~, W_per_edge] = find(aa); 
% 
% 
% 
A = T.A;
n = length(W_per_edge); 
cvx_begin quiet
    variables x(n)
    minimize(W_per_edge'*x)
    subject to
        A * x >= cost_per_cycle
        x >= 0
cvx_end
% 
x = x/median(x); 
W_computed = sparse(edge(:, 1), edge(:, 2), exp(-x.^2/2), nshapes, nshapes); 
dist_matrix = sparse(edge(:, 1), edge(:, 2), x.^2, nshapes, nshapes); 

% W_computed = (W_computed+W_computed')/2; 

Fmaps_updated = Fmaps; 
% 
% 
% if nargin >1
%     for i = 1:length(edge)
%         if x(i) > 0
%             [~, path] = graphshortestpath(dist_matrix, edge(i, 1), edge(i, 2));
%             if length(path) > 2
%                 A = eye(size(Fmaps{1, 2}));
%                 for j = 1:length(path)-1
%                     A = Fmaps{path(j), path(j+1)}*A;
%                 end
%                 Fmaps_updated{edge(i, 1), edge(i, 2)} = A; 
%                 fprintf('short-cut!.\n'); 
%             end
%         end
%     end
% end

end
