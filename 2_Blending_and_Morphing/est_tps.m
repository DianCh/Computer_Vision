function [a1, ax, ay, w] = est_tps(interim_pts, source_pts)
%EST_TPS Thin-plate parameter estimation
%	Input interim_pts: correspondences position in the intermediate image 
%	Input source_pts: correspondences position in the source image
% 
%	Output a1: TPS parameters
%	Output ax: TPS parameters
%	Output ay: TPS parameters
%	Output w: TPS parameters

% We're solving for the parameters based on Ax = b, with A and b explained
% in the homework handout

% Record the number of control points
N = size(interim_pts, 1);

% Construct the A matrix
x_map_1 = interim_pts(:, 1) * ones(1, N);
x_map_2 = ones(N, 1) * interim_pts(:, 1)';

y_map_1 = interim_pts(:, 2) * ones(1, N);
y_map_2 = ones(N, 1) * interim_pts(:, 2)';

x_corr = x_map_1 - x_map_2;
y_corr = y_map_1 - y_map_2;
dist = sqrt(x_corr .* x_corr + y_corr .* y_corr);

K = - dist .* dist .* log(dist .* dist);
for i = 1 : size(K, 1)
    K(i, i) = 0;
end

P = [interim_pts, ones(N, 1)];

A = [K, P;
     P', zeros(3, 3)];
A = A + 0.001 * eye(size(A));
 
% Construct the b vector
b = [source_pts; zeros(3, 1)];

% Solve for the parameters
x = A \ b;

% Unpack the outputs
ax = x(N + 1);
ay = x(N + 2);
a1 = x(N + 3);
w = x(1 : N);
end