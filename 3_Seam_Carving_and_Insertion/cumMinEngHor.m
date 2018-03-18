% File Name: cumMinEngHor.m
% Author: Dian Chen
% Date: 10/22/2017

function [My, Tby] = cumMinEngHor(e)
% Input:
%   e is the energy map.

% Output:
%   My is the cumulative minimum energy map along horizontal direction.
%   Tby is the backtrack table along horizontal direction.

% Write Your Code Here

% Record the dimensions of the current image
N = size(e, 1);
M = size(e, 2);

% Pre-allocate arrays for the outputs, and initialize Mx's first column as
% the same of e's first column
My = zeros(size(e));
My(:, 1) = e(:, 1);

Tby = zeros(size(e));

% March the vertical columns of contingency map starting at the second
% column
for j = 2 : M
    % Fill in each entry of the current row
    for i = 1 : N
        
        indices = [i - 1, i, i + 1];
        indices = min(max(indices, 1), N);
        
        [My(i, j), id] = min([My(indices(1), j-1), My(indices(2), j-1), My(indices(3), j-1)]);
        My(i, j) = My(i, j) + e(i, j);
        
        Tby(i, j) = indices(id);
    end
end

end