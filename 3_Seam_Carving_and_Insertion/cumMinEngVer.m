% File Name: cumMinEngVer.m
% Author: Dian Chen
% Date: 10/22/2017

function [Mx, Tbx] = cumMinEngVer(e)
% Input:
%   e is the energy map

% Output:
%   Mx is the cumulative minimum energy map along vertical direction.
%   Tbx is the backtrack table along vertical direction.

% Write Your Code Here

% Record the dimensions of the current image
N = size(e, 1);
M = size(e, 2);

% Pre-allocate arrays for the outputs, and initialize Mx's first row as the
% same of e's first row
Mx = zeros(size(e));
Mx(1, :) = e(1, :);

Tbx = zeros(size(e));

% March the horizontal rows of contingency map starting at the second row
for i = 2 : N
    % Fill in each entry of the current row
    for j = 1 : M
        
        indices = [j - 1, j, j + 1];
        indices = min(max(indices, 1), M);
        
        [Mx(i, j), id] = min([Mx(i-1, indices(1)), Mx(i-1, indices(2)), Mx(i-1, indices(3))]);
        Mx(i, j) = Mx(i, j) + e(i, j);
        
        Tbx(i, j) = indices(id);
    end
end

end