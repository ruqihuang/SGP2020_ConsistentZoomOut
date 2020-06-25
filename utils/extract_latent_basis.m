function [U] = extract_latent_basis(Fmaps, G)

% Inputs
% Fmaps -> set of functional maps among a collection of shapes.  
% t -> a parameter controlling the declay rate of the influence of the
%      inconsistent latent basis.
% G -> a graph indicating the adjacency of the functional map network of
%      interest.

% Outputs: U is a structure data containing the following fields. 
% U.qform -> a square matrix such that 
%            y'*U.qform*y  = \sum ||Fmaps{i, j} y_i - y_j||^2 
% [U.evecs, U.evals] -> the smallest few eigenvector/eigenvalues of
%                       U.qform.
% % U.bases-> a cell storing the latent basis on each of the shapes. 
% % U.wbases -> modify the latent basis U.evecs by the U.evals(consistency).



%% set defaults
if nargin < 2
    matrix_sum = @(x) sum(sum(abs(x))); 
    ms = cellfun(matrix_sum, Fmaps); 
    G = double(ms ~= 0); 
end

U.G = G; 

nshapes = size(Fmaps, 1); 
neigen = size(Fmaps{1, 1}, 1); 

if nshapes == 1
    U.qform = zeros(neigen); 
    U.evecs = eye(neigen); 
    U.evals = zeros(neigen, 1); 
%     U.bases = mat2cell(U.evecs, neigen*ones(nshapes, 1), neigen); 
%     U.wevecs = U.evecs*diag(exp(-t*U.evals)); 
%     U.wbases = mat2cell(U.wevecs, neigen*ones(nshapes, 1), neigen); 
else
    %% construct the quadratic form for the consistent framework. 
    W = cell(nshapes); 
    for i = 1:nshapes
        W{i, i} = zeros(neigen); 
        for j = 1:nshapes 
            if i ~= j
                W{i, i} = W{i, i} + G(i, j)*Fmaps{i,j}'*Fmaps{i,j} + G(j, i)*eye(neigen); 
                W{i, j} = -G(i, j)*Fmaps{i,j}' - G(j, i)*Fmaps{j, i};
            end
        end
    end

    U.qform = sparse(cell2mat(W)); 

    %% compute the smallest neigen eigenvectors of the eigen equation
%     [u, v] = eigs(U.qform, neigen, -1E-6); 
    [u, v] = eigs((U.qform+U.qform')/2, 1/nshapes*eye(size(U.qform)), neigen, -1E-6); 
    [U.evals, ind] = sort(diag(v), 'ascend'); 
    U.evecs = u(:, ind); 
%     figure; plot(U.evals); 
    U.bases = mat2cell(U.evecs, neigen*ones(nshapes, 1), neigen); 

%     U.wevecs = U.evecs*diag(exp(-t*U.evals)); 
%     U.wbases = mat2cell(U.wevecs, neigen*ones(nshapes, 1), neigen); 
end

end