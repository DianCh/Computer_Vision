% File Name: genSeamEffectVer.m
% Author: Dian Chen
% Date: 10/22/2017

function I_display = genSeamEffectVer(I, Mx, Tbx)

% Record the spatial dimensions of the current image
N = size(I, 1);
M = size(I, 2);

% Copy the original image for display
I_display = I;

% Find the cost e as the minimum cumulative energy at the last row and
% the starting point of DP backpropagation
[E, startX] = min(Mx(N, :));

% Back propagate the seam
indexX = startX;

I_display(N, indexX, :) = 255;

for i = N-1 : -1 : 1
    indexX = Tbx(i+1, indexX);
    
    I_display(i, indexX, :) = 255;
    
end

end