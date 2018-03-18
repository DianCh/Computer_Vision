%% Copyright description
% Author & Copyright: Dian Chen
% Date: 10/28/2017
% Mini project for CIS 581 (17fall)

%% Function definition
function If = bubbleEffect(I)

If = I;

N = size(I, 1);
M = size(I, 2);

heightMap = zeros(N, M);

Gx = 0.5 * [-1, 0, 1];
Gy = 0.5 * [-1; 0; 1];

divide = 8;

R = 4;

% Fake the light condition for Lambertian lighting and Blinn-Phong Effect
% Use a point light source
cameraPos = [0.5, 0.5, 2];
lightPos = [0.55, 0.55, 1];

for i = 1 : N
    for j = 1 : M
        
        % Compute normalized coordinates
        uv = [(j - 1) / (M - 1), (i - 1) / (N - 1)];
        
        % Get the control point and distance for a particular pixel
        [ctrlP, dist] = worleyNoise(uv, divide);  
        
        % Compute height map
        heightMap(i, j) = sqrt(R * R - dist * dist);
                
    end
end

% Compute gradients of the height map
gradientX = conv2(heightMap, Gx, 'same') * M;
gradientY = conv2(heightMap, Gy, 'same') * N;

for i = 1 : N
    for j = 1 : M
        
        % Compute normalized coordinates
        uv = [(j - 1) / (M - 1), (i - 1) / (N - 1)];
        
        % Fake light conditions
        fragPos = [uv, 0];
        View = cameraPos - fragPos;
        Light = lightPos - fragPos;
        Halfway = (View + Light) / 2;

        % Construct surface normal for the bubble
        normal = [gradientX(i, j), gradientY(i, j), 1];
        
        % Compute various coefficients
        specularTerm = 0.3 * max(((Halfway / norm(Halfway)) * (normal / norm(normal))') ^ 30, 0);
        diffuseTerm = max((normal / norm(normal)) * (Light / norm(Light))', 0);
        ambientTerm = 0.5;
        lightIntensity = specularTerm + diffuseTerm + ambientTerm;
        
        % Compute the displacement in color retrieval
        uv_refraction = uv - [gradientX(i, j), gradientY(i, j)] / (divide * divide);
        
        % Compute the coordinates of color to retrieve in pixel space
        x = max(min(uv_refraction(1) * (M - 1) + 1, M), 1);
        y = max(min(uv_refraction(2) * (N - 1) + 1, N), 1);
        
        % Retrieve color
        color = I(floor(y), floor(x), :);
        
        % Use color with light effects
        If(i, j, :) = color * lightIntensity;
        
    end
end

end