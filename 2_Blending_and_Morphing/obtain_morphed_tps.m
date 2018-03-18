function [morphed_im] = obtain_morphed_tps(im_source, a1_x, ax_x, ay_x, w_x, a1_y, ax_y, ay_y, w_y, interim_pts, sz)
%OBTAIN_MORPHED_TPS	Image morphing based on TPS parameters 
%	Input im_source: the source image
%	Input a1_x, ax_x, ay_x, w_x: the TPS parameters in x dimension
%	Input a1_y, ax_y, ay_y, w_y: the TPS parameters in y dimension
%	Input interim_pts: correspondences position in the intermediate image 
%	Input sz: a vector rerpesents the intermediate image size
% 
%	Output morphed_im: the morphed image

% Pre-allocate space for the morphed image
morphed_im = zeros(size(im_source));

% Record the number of control points & inquiry points
p = size(interim_pts, 1);
N = size(im_source, 1) * size(im_source, 2);

% Generate a mesh grid for inquiry points
[x_mesh, y_mesh] = meshgrid(1:size(im_source, 2), 1:size(im_source, 1));

% Construct the forward matrix A
x_map_1 = x_mesh(:) * ones(1, p);
x_map_2 = ones(N, 1) * interim_pts(:, 1)';

y_map_1 = y_mesh(:) * ones(1, p);
y_map_2 = ones(N, 1) * interim_pts(:, 2)';

x_corr = x_map_1 - x_map_2;
y_corr = y_map_1 - y_map_2;
dist = sqrt(x_corr .* x_corr + y_corr .* y_corr);

K = - dist .* dist .* log(dist .* dist);

P = [x_mesh(:), y_mesh(:) ones(N, 1)];

A = [K, P];

% Construct the forward coefficient vector x_x & x_y
x_x = [w_x; ax_x; ay_x; a1_x];
x_y = [w_y; ax_y; ay_y; a1_y];

% Calculate the warped coordinates
X = A * x_x;
Y = A * x_y;

% Reconstruct the meshgrid of the inquiry points for interpolation
interp_X = reshape(X, size(im_source, 1), size(im_source, 2));
interp_Y = reshape(Y, size(im_source, 1), size(im_source, 2));

% Look back to the source image and interpolate pixel values
morphed_im(:,:,1) = interp2(x_mesh, y_mesh, double(im_source(:,:,1)), interp_X, interp_Y);
morphed_im(:,:,2) = interp2(x_mesh, y_mesh, double(im_source(:,:,2)), interp_X, interp_Y);
morphed_im(:,:,3) = interp2(x_mesh, y_mesh, double(im_source(:,:,3)), interp_X, interp_Y);

end

