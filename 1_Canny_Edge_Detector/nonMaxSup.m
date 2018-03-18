function M = nonMaxSup(Mag, Ori)
%%  Description
%       compute the local minimal along the gradient.
%%  Input: 
%         Mag = (H, W), double matrix, the magnitude of derivative 
%         Ori = (H, W), double matrix, the orientation of derivative
%%  Output:
%         M = (H, W), logic matrix, the edge map
%
%% ****YOU CODE STARTS HERE**** 

% Generate meshgrid for the coordinates of each pixel
[x_mesh, y_mesh] = meshgrid(1:size(Mag,2), 1:size(Mag,1));

% The pixels to be inquired along the gradient
x1 = x_mesh + cos(Ori);
y1 = y_mesh + sin(Ori);

% The pixels to be inquied along the opposite gradient
x2 = x_mesh - cos(Ori);
y2 = y_mesh - sin(Ori);

% Generate the "virtual" pixels using interpolation
interpolate_1 = interp2(x_mesh, y_mesh, Mag, x1, y1);
interpolate_2 = interp2(x_mesh, y_mesh, Mag, x2, y2);

% Compare the pixels with the neighbors, and only confirmed as an edge if
% larger than both
M = (Mag > interpolate_1) & (Mag > interpolate_2);

end