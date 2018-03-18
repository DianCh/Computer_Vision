function [morphed_im] = morph_tps(im1, im2, im1_pts, im2_pts, warp_frac, dissolve_frac)
%MORPH_TPS  Image morphing via TPS
%	Input im1: target image
%	Input im2: source image
%	Input im1_pts: correspondences coordiantes in the target image
%	Input im2_pts: correspondences coordiantes in the source image
%	Input warp_frac: a vector contains warping parameters
%	Input dissolve_frac: a vector contains cross dissolve parameters
% 
%	Output morphed_im: a set of morphed images obtained from different warp and dissolve parameters

% Record the number of frames to generate, and image size
M = length(warp_frac);
sz = [size(im1, 1), size(im1, 2)];

% Pre-allocate the cell for frames
morphed_im = cell(M, 1);

% Loop over each frame
for k = 1 : M
    % the weights for this frame
    warp = warp_frac(k);
    dissolve = dissolve_frac(k);
    
    % Generate the intermediate control points
    middle_pts = (1 - warp) * im1_pts + warp * im2_pts;
    
    % Compute the TPS model from the middle image to source & target image
    % respectively
    [a1_tg_x, ax_tg_x, ay_tg_x, w_tg_x] = est_tps(middle_pts, im1_pts(:, 1));
    [a1_tg_y, ax_tg_y, ay_tg_y, w_tg_y] = est_tps(middle_pts, im1_pts(:, 2));
    
    [a1_src_x, ax_src_x, ay_src_x, w_src_x] = est_tps(middle_pts, im2_pts(:, 1));
    [a1_src_y, ax_src_y, ay_src_y, w_src_y] = est_tps(middle_pts, im2_pts(:, 2));
    
    % Generate two warped images from source & target image respectively
    intermediate_pic_1 = obtain_morphed_tps(im1, a1_tg_x, ax_tg_x, ay_tg_x, w_tg_x, ...
                                            a1_tg_y, ax_tg_y, ay_tg_y, w_tg_y, middle_pts, sz);
    intermediate_pic_2 = obtain_morphed_tps(im2, a1_src_x, ax_src_x, ay_src_x, w_src_x, ...
                                            a1_src_y, ax_src_y, ay_src_y, w_src_y, middle_pts, sz);
    
    % Cross-dissolve and store the image
    cross_dissolve = (1 - dissolve) * intermediate_pic_1 + dissolve * intermediate_pic_2;
    morphed_im{k, 1} = uint8(cross_dissolve);
    
end