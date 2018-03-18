function [im1_pts, im2_pts] = click_correspondences(im1, im2)
%CLICK_CORRESPONDENCES Find and return point correspondences between images
%   Input im1: target image
%	Input im2: source image
%	Output im1_pts: correspondence-coordiantes in the target image
%	Output im2_pts: correspondence-coordiantes in the source image

%% Your code goes here
% You can use built-in functions such as cpselect to manually select the
% correspondences

[im1_pts, im2_pts] = cpselect(im1, im2, 'wait', true);

end