function Data = ConsistentZoomOut(Data)

% collect input data info.
shapes = Data.shapes; 
input_maps = Data.input_maps; 
G = Data.G; 
sub = Data.sub; 
dim = Data.dim; 
alpha = Data.alpha; 
nshapes = length(shapes); 

% extract all 3-cycles from graph G.
T = extract_3_cycles(G); 

% convert the initial point-wise maps into functional maps.
maps = input_maps; 
Fmaps = convert_fmaps(shapes, maps, G, dim(1)); 

% compute weight matrix according to consistency voting
G_w =  ICSM_weight(Fmaps, T);

for iter = 1:length(dim)-1
    
    
    U = extract_latent_basis(Fmaps, G_w); 
    latent_dim = floor(alpha*dim(iter)); 
    % compute the limit shape basis
    V = canonical_latent_basis(U, shapes, latent_dim); 

    Basis = cell(nshapes, 1); 
    E = Basis; 
    for i = 1:nshapes
        E{i} = shapes{i}.evecs(:, 1:dim(iter))*V.cbases{i}(:, 1:latent_dim); 
        Basis{i} = E{i}(sub{i}, :);
    end
    
    % update functional map network
    [Fmaps] = fmaps_from_basis(shapes, sub, Basis, G, dim(iter+1));
    % update the weight matrix for the nex iteration.
    [G_w] = ICSM_weight(Fmaps, T);
    
    fprintf('Iteration %d is done.\n', iter); 
end

% extract the refined point-wise maps. 
fprintf('Extracting point-wise maps...')
Data.refined_maps = collection_2_pointmaps(E, G); 
fprintf('done!\n'); 
