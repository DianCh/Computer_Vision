%% Copyright description
% Author & Copyright: Dian Chen
% Date: 10/28/2017
% Mini project for CIS 581 (17fall)

%% Function definition
function [controlPoint, minDistance] = worleyNoise(uv, N)
% Input uv should be a normalized 1 * 2 coordinate ranging (0, 1); N should
% be the number cells in one column (or row)

% Indices range [0, N)
indexX = floor(uv(1) * N);
indexY = floor(uv(2) * N);

% Consider 8 neighborhood cells along with this cell to find the closest
% control point
nearbyCellX = [max(indexX - 1, 0), indexX, min(indexX + 1, N - 1)];
nearbyCellY = [max(indexY - 1, 0), indexY, min(indexY + 1, N - 1)];

minDistance = 99;
controlPoint = [1, 1];

for i = 1 : 3
    for j = 1 : 3
        
        % Get the position of control point in the cell of consideration
        ctrlP = [nearbyCellX(i), nearbyCellY(j)] + randomNoise([nearbyCellX(i), nearbyCellY(j)]);
        
        % Get the distance to this control point
        distance = sqrt((ctrlP - uv * N) * (ctrlP - uv * N)');
        
        % If the distance is smaller, then update
        if distance < minDistance
            minDistance = distance;
            controlPoint = ctrlP;
        end
        
    end
end

end


