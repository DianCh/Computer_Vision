% File Name: rmHorSeam.m
% Author: Dian Chen
% Date: 10/22/2017

function [Iy, E] = rmHorSeam(I, My, Tby)
% Input:
%   I is the image. Note that I could be color or grayscale image.
%   My is the cumulative minimum energy map along horizontal direction.
%   Tby is the backtrack table along horizontal direction.

% Output:
%   Iy is the image removed one row.
%   E is the cost of seam removal

% Write Your Code Here

% Record the spatial dimensions of the current image
N = size(I, 1);
M = size(I, 2);

% Copy the original image for display and carving
Iy = I;

% Find the cost e as the minimum cumulative energy at the last column and
% the starting point of DP backpropagation
[E, startY] = min(My(:, M));

% Back propagate the seam
indexY = startY;

Iy(indexY:end-1, M, :) = Iy(indexY+1:end, M, :);

for j = M-1 : -1 : 1
    indexY = Tby(indexY, j+1);
    
    % Move the slice one pixel to the bottom
    Iy(indexY:end-1, j, :) = Iy(indexY+1:end, j, :);
end

Iy = Iy(1:end-1, :, :);

end