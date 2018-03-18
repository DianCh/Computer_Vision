%% Copyright description
% Author & Copyright: Yu Sun
% Date: 10/28/2017
% Mini project for CIS 581 (17fall)
% % % % % % % % % % % % % % % % %
% Input: Smoothed Image and amplication Factor for the edge
% Output: Image with Stylization Effect
% The filter essentially emphasize the edges of the image
function Stylized = Stylization(Filtered,EdgeFactor)
Gx = [1 0 -1; 2 0 -2; 1 0 -1];
Gy = [1 2 1; 0 0 0;-1 -2 -1];
dx = zeros(size(Filtered));
dy = zeros(size(Filtered));
n = 0;
for i = 1: 3
    dx(:,:,i) = conv2(Filtered(:,:,i),Gx,'same'); 
    dy(:,:,i) = conv2(Filtered(:,:,i),Gy,'same'); 
    n = n + EdgeFactor * sqrt(dx(:,:,i).^2+dy(:,:,i).^2);
end
n = bsxfun(@min, n,1);

Stylized = zeros(size(Filtered));
for i = 1:3
    Stylized(:,:,i) = Filtered(:,:,i) .* (1-n); 
end
end