% File Name: genSeamEffectHor.m
% Author: Dian Chen
% Date: 10/22/2017

function I_display = genSeamEffectHor(I, My, Tby)

% Record the spatial dimensions of the current image
N = size(I, 1);
M = size(I, 2);

% Copy the original image for display
I_display = I;

% Find the cost e as the minimum cumulative energy at the last row and
% the starting point of DP backpropagation
[E, startY] = min(My(:, M));

% Back propagate the seam
indexY = startY;

I_display(indexY, M, :) = 255;

for j = M-1 : -1 : 1
    indexY = Tby(indexY, j+1);
    
    I_display(indexY, j, :) = 255;
    
end

end