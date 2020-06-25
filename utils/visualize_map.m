function visualize_map(S1, S2, T_ini, T_ref, angles1, angles2)

if nargin<5
    angles1 = [0, 90]; 
    angles2 = angles1;
end

g1 = S2.surface.X;
g2 = S2.surface.Y;
g3 = S2.surface.Z;

g1 = normalize_function(0,1,g1);
g2 = normalize_function(0,1,g2);
g3 = normalize_function(0,1,g3);
X2 = S2.surface.X; Y2 = S2.surface.Y; Z2 = S2.surface.Z;

subplot(1, 3, 1); 
trimesh(S2.surface.TRIV, X2, Y2, Z2, ...
    'FaceVertexCData', [g1 g2 g3], 'FaceColor','interp', ...
    'FaceAlpha', 1, 'EdgeColor', 'none'); 
axis equal; axis off; title('Target'); %hold on;
view(angles2); 

f1 = g1(T_ini);
f2 = g2(T_ini);
f3 = g3(T_ini);

X1 = S1.surface.X; Y1 = S1.surface.Y; Z1 = S1.surface.Z;
subplot(1, 3, 2); 
trimesh(S1.surface.TRIV, X1, Y1, Z1, ...
    'FaceVertexCData', [f1 f2 f3], 'FaceColor','interp', ...
    'FaceAlpha', 1, 'EdgeColor', 'none');
axis equal; axis off; title('Initial Map')%hold on; 
view(angles1); 

f1 = g1(T_ref);
f2 = g2(T_ref);
f3 = g3(T_ref);

X1 = S1.surface.X; Y1 = S1.surface.Y; Z1 = S1.surface.Z;
subplot(1, 3, 3); 
trimesh(S1.surface.TRIV, X1, Y1, Z1, ...
    'FaceVertexCData', [f1 f2 f3], 'FaceColor','interp', ...
    'FaceAlpha', 1, 'EdgeColor', 'none');
axis equal; axis off; title('Refined Map')%hold on; 
view(angles1); 


end

function fnew = normalize_function(min_new,max_new,f)
    fnew = f - min(f);
    fnew = (max_new-min_new)*fnew/max(fnew) + min_new;
end