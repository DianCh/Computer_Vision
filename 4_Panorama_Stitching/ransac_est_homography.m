% File name: ransac_est_homography.m
% Author: Dian Chen
% Date created: 11/11/2017

function [H, inlier_ind] = ransac_est_homography(x1, y1, x2, y2, thresh)
% Input:
%    y1, x1, y2, x2 are the corresponding point coordinate vectors Nx1 such
%    that (y1i, x1i) matches (x2i, y2i) after a preliminary matching
%    thresh is the threshold on distance used to determine if transformed
%    points agree

% Output:
%    H is the 3x3 matrix computed in the final step of RANSAC
%    inlier_ind is the nx1 vector with indices of points in the arrays x1, y1,
%    x2, y2 that were found to be inliers

% Write Your Code Here

% Record the number of corresponding pairs
N = size(x1, 1);

% Set the number of iterations of RANSAC
num_iter = 3000;

% Initialize the inlier count
inlier_count_max = 0;

for k = 1 : num_iter
    % Generate four random pairs
    indices = randperm(N, 4);
    
    % Extract the coordinates for homography estimation
    X1 = x1(indices);
    Y1 = y1(indices);
    X2 = x2(indices);
    Y2 = y2(indices);
    
    % Estimate homography from 1 to 2
    H_est = est_homography(X2, Y2, X1, Y1);
    
    % Compute predictions using this homography
    [xpred, ypred] = apply_homography(H_est, x1, y1);
    
    % Initialize index register
    inlier_ind_temp = false(N, 1);
    
    % Evaluate this estimation by counting inliers
    for i = 1 : N
        
        % Compute the distance between prediction and "true" corespondence
        dist = sqrt((x2(i) - xpred(i)) ^ 2 + (y2(i) - ypred(i)) ^ 2);
        
        if dist < thresh
            inlier_ind_temp(i) = true;
        end
        
    end
    
    % Count the number of inliers of this iteration
    inlier_count = sum(inlier_ind_temp);
    
    % Update the optimal estimation if needed
    if inlier_count > inlier_count_max
        
        % Update counter and indices
        inlier_count_max = inlier_count;
        
        inlier_ind = inlier_ind_temp;
        
        % Update homography
        X = x2(inlier_ind);
        Y = y2(inlier_ind);
        x = x1(inlier_ind);
        y = y1(inlier_ind);
        
        H = est_homography(X, Y, x, y);
    end
end





