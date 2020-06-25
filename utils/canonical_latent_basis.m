function [U] = canonical_latent_basis(U, shapes, nCLB)

if nargin < 3
    nCLB = size(U.bases{1}, 1);
end

ne = size(U.bases{1}, 1);
E = zeros(nCLB); 

for i = 1:length(shapes)
    E = E + U.bases{i}(:, 1:nCLB)'*diag(shapes{i}.evals(1:ne))*U.bases{i}(:, 1:nCLB); 
end

[u, v] = eig((E+E')/2); 
[v, id] = sort(diag(v), 'ascend'); 
u = u(:, id); 
v(1) = 0; 

U.lambda = v/length(shapes); 
inv_lambda = [0; (v(2:end)).^(-1)]; 
U.phi = U.evecs(:, 1:nCLB)*u; 
U.cbases = mat2cell(U.phi, ne*ones(length(shapes), 1), nCLB); 

U.area_lsd = cell(length(shapes), 1); 
U.conf_lsd = U.area_lsd; 

for i = 1:length(shapes)
    U.area_lsd{i} = U.cbases{i}'*U.cbases{i}; 
    U.conf_lsd{i} = diag(inv_lambda)*U.cbases{i}'*diag(shapes{i}.evals(1:ne))*U.cbases{i}; 
end
