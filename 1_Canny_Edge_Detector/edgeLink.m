function E = edgeLink(M, Mag, Ori)
%%  Description
%       use hysteresis to link edges
%%  Input: 
%        M = (H, W), logic matrix, output from non-max suppression
%        Mag = (H, W), double matrix, the magnitude of gradient
%        Ori = (H, W), double matrix, the orientation of gradient
%
%%  Output:
%        E = (H, W), logic matrix, the edge detection result.
%
%% ****YOU CODE STARTS HERE**** 

% Only onsider the magnitude of edge pixels from NMS results
Mag = M .* Mag;

% Set high threshold and low threshold
thresh_l = 0.01 * max(Mag(:));
thresh_h = 0.25 * max(Mag(:));

% Get the masks for strong edges and weak edges
Mask_s = Mag > thresh_h;
Mask_w = (Mag > thresh_l) & (Mag < thresh_h);

% Convert the orientation map to degrees for convenience
Ori = Ori * 180.0 / pi;

% Disretize the angle into 8 baskets, and generate a global map for pixels
% to be inquired
% (delta x, delta y) = 
% (-1,-1), (0,-1), (1,-1)
% (-1,0),  (0,0),  (1,0)
% (-1,1),  (0,1),  (1,1)
%
% Set the delta x and delta y for pixels to inquire along the gradient
x_pos = zeros(size(Mag));
y_pos = zeros(size(Mag));

x_pos(Ori > -67.5 & Ori < 67.5) = 1;
x_pos(Ori > 112.5 & Ori < -112.5) = -1;
    
y_pos(Ori > 22.5 & Ori < 157.5) = 1;
y_pos(Ori > -157.5 & Ori < -22.5) = -1;

% Set the delta x and delta y for pixels to inquire along the opposite of 
% gradient
x_neg = - x_pos;
y_neg = - y_pos;

% Perfor zero clippings to ensure the indices won't go out of bounds
x_pos(:,1) = max(x_pos(:,1), 0);
x_pos(:,end) = min(x_pos(:,end), 0);
y_pos(1,:) = max(y_pos(1,:), 0);
y_pos(end,:) = min(y_pos(end,:), 0);
    
x_neg(:,1) = max(x_neg(:,1), 0);
x_neg(:,end) = min(x_neg(:,end), 0);
y_neg(1,:) = max(y_neg(1,:), 0);
y_neg(end,:) = min(y_neg(end,:), 0);

% Store the increment (newly joined edges) in I and start from strong edges
I = Mask_s;

% Store the overall results in E and start from strong edges
E = Mask_s;

% Generate a meshgrid for indexing
[x_mesh, y_mesh] = meshgrid(1:size(Mag,2), 1:size(Mag,1));

% Iterate if there are still new pixels to join (stop if no more new edges
% is connected)
while sum(sum(I)) > 0
    
    % Consider neighbors only for newly joined edge pixels, in positive
    % gradient direction & negative gradient direction
    x_pos_temp = x_pos .* I;
    y_pos_temp = y_pos .* I;
    
    x_neg_temp = x_neg .* I;
    y_neg_temp = y_neg .* I;
    
    % Get the meshgrid for neighbors to be examined
    x_q_pos = x_mesh + x_pos_temp;
    y_q_pos = y_mesh + y_pos_temp;
    
    x_q_neg = x_mesh + x_neg_temp;
    y_q_neg = y_mesh + y_neg_temp;
    
    % Clear the map for newly joined pixels
    I = false(size(Mag));
    
    % Convert the meshgrid to single-number indices and consider only the
    % ones interested, and filter out the zeros 
    index_pos = sub2ind(size(Mag),y_q_pos(:),x_q_pos(:)) .* I(:);
    index_pos = index_pos(find(index_pos > 0));
    
    index_neg = sub2ind(size(Mag),y_q_neg(:),x_q_neg(:)) .* I(:);
    index_neg = index_neg(find(index_neg > 0));
    
    % Set the map according to the indices
    I(index_pos) = true;
    I(index_neg) = true;
    
    % The inquired pixels should remain only if it is a potential edge on
    % the weak edge map
    I = I & Mask_w;
    
    % Add the new ones to the result
    E = E | I;
end
    
end