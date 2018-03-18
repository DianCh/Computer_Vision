% File Name: insHorSeam.m
% Author: Dian Chen
% Date: 10/22/2017

function [Iy, E] = insHorSeam(I, My, Tby)
% Input:
%   I is the image. Note that I could be color or grayscale image.
%   Mx is the cumulative minimum energy map along vertical direction.
%   Tbx is the backtrack table along vertical direction.

% Output:
%   Ix is the image removed one column.
%   E is the cost of seam insertion

% Write Your Code Here

% Record the spatial dimensions of the current image
N = size(I, 1);
M = size(I, 2);

% Copy the original image for display and carving
Iy = uint8(zeros(N + 1, M, 3));
Iy(1:N, :, :) = I;

% Find the cost e as the minimum cumulative energy at the last row and
% the starting point of DP backpropagation
[E, startY] = min(My(:, M));

% Back propagate the seam
indexY = startY;

Iy(indexY + 1:end, M, :) = Iy(indexY:end - 1, M, :);

for j = M-1 : -1 : 1
    indexY = Tby(indexY, j+1);
    
    % Move the slice one pixel to the bottom
    Iy(indexY + 1:end, j, :) = Iy(indexY:end - 1, j, :);
    
    % Take the average of the top & bottom pixels as filling value
    Iy(indexY, j, :) = 0.5 * (Iy(indexY - 1, j, :) + Iy(indexY + 1, j, :));
end

end