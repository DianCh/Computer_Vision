function [Mag, Magx, Magy, Ori] = findDerivatives(I_gray)
%%  Description
%       compute gradient from grayscale image 
%%  Input: 
%         I_gray = (H, W), double matrix, grayscale image matrix 
%
%%  Output:
%         Mag  = (H, W), double matrix, the magnitued of derivative%  
%         Magx = (H, W), double matrix, the magnitude of derivative in x-axis
%         Magx = (H, W), double matrix, the magnitude of derivative in y-axis
% 				Ori = (H, W), double matrix, the orientation of the derivative
%
%% ****YOU CODE STARTS HERE**** 

% Use a 5 * 5 Gaussian kernel
G = [2, 4, 5, 4, 2; 
     4, 9, 12, 9, 4;
     5, 12, 15, 12, 5;
     4, 9, 12, 9, 4;
     2, 4, 5, 4, 2] * (1 / 159);
 
 % The derivative kernels
 dx = [1, 0, -1];
 dy = [1; 0; -1];
 
 % Convolve the Gaussian kernel with the dirivative kernels first
 Gx = conv2(G, dx, 'same');
 Gy = conv2(G, dy, 'same');
 
 % Get the smoothed gradient in x, y direction and the magnitude
 Magx = conv2(I_gray, Gx, 'same');
 Magy = conv2(I_gray, Gy, 'same');
 Mag = sqrt(Magx .* Magx + Magy .* Magy);
 
 % Use atan2 to get the orientation
 Ori = atan2(Magy, Magx);
 
end