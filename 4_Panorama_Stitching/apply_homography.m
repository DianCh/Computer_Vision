% File name: apply_homography.m
% Author:
% Date created:

function [X, Y] = apply_homography(H, x, y)
% Input:
%   H : 3*3 homography matrix, refer to setup_homography
%   x : the column coords vector, n*1, in the source image
%   y : the column coords vector, n*1, in the source image

% Output:
%   X : the column coords vector, n*1, in the destination image
%   Y : the column coords vector, n*1, in the destination image

% Write Your Code Here

% Record the number of correpondence pair
N = size(x, 1);

% Construct coordinate columns
x_y_1 = [x'; y'; ones(1, N)];

% Multiply H and normalize
X_Y_lambda = H * x_y_1;

lambda = X_Y_lambda(3, :);

X_Y_1 = X_Y_lambda ./ lambda;

% Extract results
X = X_Y_1(1, :)';
Y = X_Y_1(2, :)';

end