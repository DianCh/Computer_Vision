% File Name: insVerSeam.m
% Author: Dian Chen
% Date: 10/22/2017

function [Ix, E] = insVerSeam(I, Mx, Tbx)
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
Ix = uint8(zeros(N, M + 1, 3));
Ix(:, 1:M, :) = I;

% Find the cost e as the minimum cumulative energy at the last row and
% the starting point of DP backpropagation
[E, startX] = min(Mx(N, :));

% Back propagate the seam
indexX = startX;

Ix(N, indexX + 1:end, :) = Ix(N, indexX:end - 1, :);

for i = N-1 : -1 : 1
    indexX = Tbx(i + 1, indexX);
    
    % Move the slice one pixel to the right
    Ix(i, indexX + 1:end, :) = Ix(i, indexX:end - 1, :);
    
    % Take the average of the left & right pixels as filling value
    Ix(i, indexX, :) = 0.5 * (Ix(i, indexX - 1, :) + Ix(i, indexX + 1, :));
end

end