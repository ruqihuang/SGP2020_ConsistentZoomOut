function S = compute_laplacian_basis(S, numEigs, para)
   
if nargin < 3
    para.normalize = true; 
    para.compute_normals = true; 
end


if nargin == 3
    if ~isfield(para, 'normalize'); para.normalize = true; end
end

if ~isfield(S.surface, 'VERT')
    S.surface.VERT = [S.surface.X, S.surface.Y, S.surface.Z]; 
end

if para.normalize
    tau = sqrt(sum(vertexAreas(S.surface.VERT, S.surface.TRIV)));
    S.surface.X = S.surface.X/tau; 
    S.surface.Y = S.surface.Y/tau; 
    S.surface.Z = S.surface.Z/tau; 
    S.surface.VERT = S.surface.VERT/tau; 
end




T = S.surface.TRIV; 
X = S.surface.VERT; 
S.W = cotWeights(X, T);

% if ~((isempty(isnan(S.W))&&(isempty( isinf( S.W ) ) ) ) )
%     S.W(isnan(S.W)) = 0; 
%     S.W(isinf(S.W)) = 0; 
%     L = S.W - diag(diag(S.W)); 
%     S.W = L - diag(sum(L)); 
% end
 
S.A = diag(vertexAreas(X, T)); 
S.nv = size(S.A,1); 
S.nf = length(T); 
S.area = diag(S.A); 
S.sqrt_area = sqrt(sum(S.area));  
S.S = sum(S.area); 

% assert(conncomp(S.W) == 1);
% compute laplacian eigenbasis.
try
    [S.evecs, S.evals] = eigs(S.W, S.A, numEigs, 1e-6);
catch
    % In case of trouble make the laplacian definite
    [S.evecs, S.evals] = eigs(S.W - 1e-9*speye(length(S.W)), S.A, numEigs, 'sm');
end

[S.evals, order] = sort(diag(S.evals), 'ascend');
S.evecs = S.evecs(:, order);

end
