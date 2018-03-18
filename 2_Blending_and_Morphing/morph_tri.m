function [morphed_im] = morph_tri(im1, im2, im1_pts, im2_pts, warp_frac, dissolve_frac)
%MORPH_TRI Image morphing via Triangulation
%	Input im1: target image
%	Input im2: source image
%	Input im1_pts: correspondences coordiantes in the target image
%	Input im2_pts: correspondences coordiantes in the source image
%	Input warp_frac: a vector contains warping parameters
%	Input dissolve_frac: a vector contains cross dissolve parameters
% 
%	Output morphed_im: a set of morphed images obtained from different warp and dissolve parameters

% Helpful functions: delaunay, tsearchn

% Record the number of frames needed
M = size(warp_frac, 2);

% Preallocate the cell array for output morphed_im
morphed_im = cell(M, 1);

[x_mesh, y_mesh] = meshgrid(1:size(im1, 2), 1:size(im1, 1));

xy_map = [x_mesh(:), y_mesh(:)];

% Pre-allocate two arrays for all pixels, each row corresponds to the xy
% coordinates of a particular pixel
interp_coords_1 = zeros(size(im1, 1) * size(im1, 2), 2);
interp_coords_2 = zeros(size(im2, 1) * size(im2, 2), 2);

% Pre_allocate the meshgrid for interpolation
interp_mesh_1_x = zeros(size(im1, 1));
interp_mesh_1_y = zeros(size(im1, 2));
interp_mesh_2_x = zeros(size(im2, 1));
interp_mesh_2_y = zeros(size(im2, 2));

% Pre-allocate two arrays for reverse-interpolated pixel values in three
% channels
interpolate_1 = zeros(size(im1));
interpolate_2 = zeros(size(im2));

% Loop over each frame to be processed
for k = 1 : M
    % the weights for this frame
    warp = warp_frac(k);
    dissolve = dissolve_frac(k);
    
    % Compute the correspondence points
    middle_pts = (1 - warp) * im1_pts + warp * im2_pts;
    
    % triangulate the points
    Tri = delaunay(middle_pts);    
    T = tsearchn(middle_pts, Tri, xy_map);
    
    % Loop over each to get the coordinates for each intermediate pixel in
    % source & target image
    for i = 1 : size(Tri, 1)
        % Record the number of pixels falling inside triangle i
        num_pixels = sum(T == i);

        % Construct the matrix for solving barycentric weights from middle
        % vertices
        mat_middle = [middle_pts(Tri(i, 1), :), 1;
                      middle_pts(Tri(i, 2), :), 1;
                      middle_pts(Tri(i, 3), :), 1]';
           
        % For pixels inside triangle i, solve for the barycentric weights
        x_y_1 = [xy_map(T == i, :), ones(num_pixels, 1)]';
        bary = mat_middle \ x_y_1;
        
        % Construct the matrix from source & target vertices
        mat_1 = [im1_pts(Tri(i, 1), :), 1;
                 im1_pts(Tri(i, 2), :), 1;
                 im1_pts(Tri(i, 3), :), 1]';
             
        mat_2 = [im2_pts(Tri(i, 1), :), 1;
                 im2_pts(Tri(i, 2), :), 1;
                 im2_pts(Tri(i, 3), :), 1]';
        
        % Recover the coordinates in source & target images
        homocord_1 = mat_1 * bary;
        homocord_2 = mat_2 * bary;
        
        % Record the coordinates
        interp_coords_1(T == i, :) = homocord_1(1:2,:)';
        interp_coords_2(T == i, :) = homocord_2(1:2,:)';
        
    end
    
%     interp_coords_1 = round(interp_coords_1);
%     interp_coords_2 = round(interp_coords_2);
%     
%     indices_1 = sub2ind([size(im1, 1), size(im1, 2)], interp_coords_1(:, 2), interp_coords_1(:, 1));
%     indices_2 = sub2ind([size(im2, 1), size(im2, 2)], interp_coords_2(:, 2), interp_coords_2(:, 1));
%     
%     interpolate_1(:,:,1) = reshape(im1(indices_1), size(im1, 1), size(im1, 2));
%     interpolate_1(:,:,2) = reshape(im1(indices_1 + size(im1, 1) * size(im1, 2)), size(im1, 1), size(im1, 2));
%     interpolate_1(:,:,3) = reshape(im1(indices_1 + 2 * size(im1, 1) * size(im1, 2)), size(im1, 1), size(im1, 2));
% 
%     interpolate_2(:,:,1) = reshape(im2(indices_2), size(im2, 1), size(im2, 2));
%     interpolate_2(:,:,2) = reshape(im2(indices_2 + size(im2, 1) * size(im2, 2)), size(im2, 1), size(im2, 2));
%     interpolate_2(:,:,3) = reshape(im2(indices_2 + 2 * size(im2, 1) * size(im2, 2)), size(im2, 1), size(im2, 2));

      interp_mesh_1_x = min(max(reshape(interp_coords_1(:, 1), size(im1, 1), size(im1, 2)), 1), size(im1, 2));
      interp_mesh_1_y = min(max(reshape(interp_coords_1(:, 2), size(im1, 1), size(im1, 2)), 1), size(im1, 1));
      interp_mesh_2_x = min(max(reshape(interp_coords_2(:, 1), size(im2, 1), size(im2, 2)), 1), size(im2, 2));
      interp_mesh_2_y = min(max(reshape(interp_coords_2(:, 2), size(im2, 1), size(im2, 2)), 1), size(im2, 1));

    
    % Interpolate the pixel values in three channels from target &
    % source images, respectively
    interpolate_1(:,:,1) = interp2(x_mesh, y_mesh, double(im1(:,:,1)), interp_mesh_1_x, interp_mesh_1_y);
    interpolate_1(:,:,2) = interp2(x_mesh, y_mesh, double(im1(:,:,2)), interp_mesh_1_x, interp_mesh_1_y);
    interpolate_1(:,:,3) = interp2(x_mesh, y_mesh, double(im1(:,:,3)), interp_mesh_1_x, interp_mesh_1_y);
          
    interpolate_2(:,:,1) = interp2(x_mesh, y_mesh, double(im2(:,:,1)), interp_mesh_2_x, interp_mesh_2_y);
    interpolate_2(:,:,2) = interp2(x_mesh, y_mesh, double(im2(:,:,2)), interp_mesh_2_x, interp_mesh_2_y);
    interpolate_2(:,:,3) = interp2(x_mesh, y_mesh, double(im2(:,:,3)), interp_mesh_2_x, interp_mesh_2_y);

    % Perform cross-dissolve between the two intermediate images
    cross_dissolve = (1 - dissolve) * interpolate_1 + dissolve * interpolate_2;
        
    % Store this frame in the kth cell element
    morphed_im{k, 1} = uint8(cross_dissolve);
end

end

