%% Copyright description
% Author & Copyright: Dian Chen
% Date: 10/28/2017
% Mini project for CIS 581 (17fall)

%% Function definition
function If = mosaicEffect(I)

If = I;

N = size(I, 1);
M = size(I, 2);

% Use 80 * 80 Voronoi cells
divide = 80;

for i = 1 : N
    for j = 1 : M
        
        % Compute normalized coordinates
        uv = [(j - 1) / (M - 1), (i - 1) / (N - 1)];
        
        % Get the control point and distance for a particular pixel
        [ctrlP, dist] = worleyNoise(uv, divide);
        
        % Convert coordinates back to pixel space
        x = min(ctrlP(1) / divide * (M - 1) + 1, M);
        y = min(ctrlP(2) / divide * (N - 1) + 1, N);
        
        % Retrieve color at control point
        ctrlPColor = I(floor(y), floor(x), :);
        
        % Set color
        If(i, j, :) = ctrlPColor;
        
    end
end

end