%% Copyright description
% Author & Copyright: Dian Chen
% Date: 10/14/2017
% Project 2 morph video script for CIS 581 (17fall)

%% Reverse look-up method choosing
% A flag that determines whether triangulation or TPS method is used. If
% triangulation is to be used, set the flag to true; else set it to false.
use_triangulation = input('Do you want to use triangulation method or TPS method? Y for tri / N for TPS [Y]: ', 's');

%% Warp & dissolve parameters setup
warp_frac = 0 : 1/59 : 1;
dissolve_frac = 0 : 1/59 : 1;

%% Image acquisition & control points setup
% Read in source & target images. We assume the two images have the same
% spatial size
first_img = imread('1_me.png');
second_img = imread('2_shaw.png');
third_img = imread('3_root.png');
fourth_img = imread('4_fox.png');

H = size(first_img, 1);
W = size(first_img, 2);

% Acquire correspondence points from user
use_mat = input('Do you want to load correspondence points from prepared mat files? Y/N [Y]: ', 's');
if use_mat == 'y' || use_mat == 'Y'
    load('total_correspondence.mat');
else
    [im1_pts_B, im2_pts_A] = click_correspondences(first_img, second_img);
    [im2_pts_B, im3_pts_A] = click_correspondences(second_img, third_img);
    [im3_pts_B, im4_pts_A] = click_correspondences(third_img, fourth_img);
    [im4_pts_B, im1_pts_A] = click_correspondences(fourth_img, first_img);
end

if size(im1_pts_B, 1) == 0 || size(im2_pts_B, 1) == 0 || size(im3_pts_B, 1) == 0 || size(im4_pts_B, 1) == 0
    fprintf('No correspondence points have been chosen for at least one of the morph set!\n');
    return;
end

save('total_correspondence.mat', 'im1_pts_A', 'im1_pts_B', 'im2_pts_A', 'im2_pts_B',...
                                 'im3_pts_A', 'im3_pts_B', 'im4_pts_A', 'im4_pts_B');

% Append points on the edges and corners manually to allow valid
% triangulation or TPS for the entire image
im1_pts_A = [im1_pts_A; 1, 1; 1, H; W, 1; W, H];
im1_pts_B = [im1_pts_B; 1, 1; 1, H; W, 1; W, H];

im2_pts_A = [im2_pts_A; 1, 1; 1, H; W, 1; W, H];
im2_pts_B = [im2_pts_B; 1, 1; 1, H; W, 1; W, H];

im3_pts_A = [im3_pts_A; 1, 1; 1, H; W, 1; W, H];
im3_pts_B = [im3_pts_B; 1, 1; 1, H; W, 1; W, H];

im4_pts_A = [im4_pts_A; 1, 1; 1, H; W, 1; W, H];
im4_pts_B = [im4_pts_B; 1, 1; 1, H; W, 1; W, H];
       
for i = 1 : 3
    im1_pts_A = [im1_pts_A;
                 1, i / 4 * H;
                 W, i / 4 * H;
                 i / 4 * W, 1;
                 i / 4 * W, H];
    im1_pts_B = [im1_pts_B;
                 1, i / 4 * H;
                 W, i / 4 * H;
                 i / 4 * W, 1;
                 i / 4 * W, H];
             
    im2_pts_A = [im2_pts_A;
                 1, i / 4 * H;
                 W, i / 4 * H;
                 i / 4 * W, 1;
                 i / 4 * W, H];
    im2_pts_B = [im2_pts_B;
                 1, i / 4 * H;
                 W, i / 4 * H;
                 i / 4 * W, 1;
                 i / 4 * W, H];

    im3_pts_A = [im3_pts_A;
                 1, i / 4 * H;
                 W, i / 4 * H;
                 i / 4 * W, 1;
                 i / 4 * W, H];
    im3_pts_B = [im3_pts_B;
                 1, i / 4 * H;
                 W, i / 4 * H;
                 i / 4 * W, 1;
                 i / 4 * W, H];

    im4_pts_A = [im4_pts_A;
                 1, i / 4 * H;
                 W, i / 4 * H;
                 i / 4 * W, 1;
                 i / 4 * W, H];
    im4_pts_B = [im4_pts_B;
                 1, i / 4 * H;
                 W, i / 4 * H;
                 i / 4 * W, 1;
                 i / 4 * W, H];
end

%% Video writer setup
% Set video writer. Use different video names for triangulation & TPS
% methods
if use_triangulation == 'Y' || use_triangulation == 'y'
    fname = 'Project2_eval_trig_four.avi';
else
    fname = 'Project2_eval_tps_four.avi';
end

try
    % VideoWriter based video creation
    h_avi = VideoWriter(fname, 'Uncompressed AVI');
    h_avi.FrameRate = 20;
    h_avi.open();
catch
    % Fallback deprecated avifile based video creation
    h_avi = avifile(fname,'fps',20);
end

%% Morph & store morphed frames
if use_triangulation == 'Y' || use_triangulation == 'y'
    morph_1 = morph_tri(first_img, second_img, im1_pts_B, im2_pts_A, warp_frac, dissolve_frac);
    morph_2 = morph_tri(second_img, third_img, im2_pts_B, im3_pts_A, warp_frac, dissolve_frac);
    morph_3 = morph_tri(third_img, fourth_img, im3_pts_B, im4_pts_A, warp_frac, dissolve_frac);
    morph_4 = morph_tri(fourth_img, first_img, im4_pts_B, im1_pts_A, warp_frac, dissolve_frac);
else
    morph_1 = morph_tps(first_img, second_img, im1_pts_B, im2_pts_A, warp_frac, dissolve_frac);
    morph_2 = morph_tps(second_img, third_img, im2_pts_B, im3_pts_A, warp_frac, dissolve_frac);
    morph_3 = morph_tps(third_img, fourth_img, im3_pts_B, im4_pts_A, warp_frac, dissolve_frac);
    morph_4 = morph_tps(fourth_img, first_img, im4_pts_B, im1_pts_A, warp_frac, dissolve_frac);
end

%% Generate videos
% Generate forward warp (add extra repeated frames for the warped image to
% make you see more clearly)
% Write the first morph
for k = 1 : size(morph_1, 1) + 5
    imagesc(morph_1{min(k, size(morph_1, 1))});
    axis image;
    axis off;
    drawnow;
    try
        % VideoWriter based video creation
        h_avi.writeVideo(getframe(gcf));
    catch
        % Fallback deprecated avifile based video creation
        h_avi = addframe(h_avi, getframe(gcf));
    end
end

% Write the second morph
for k = 1 : size(morph_2, 1) + 5
    imagesc(morph_2{min(k, size(morph_2, 1))});
    axis image;
    axis off;
    drawnow;
    try
        % VideoWriter based video creation
        h_avi.writeVideo(getframe(gcf));
    catch
        % Fallback deprecated avifile based video creation
        h_avi = addframe(h_avi, getframe(gcf));
    end
end

% Write the third morph
for k = 1 : size(morph_3, 1) + 5
    imagesc(morph_3{min(k, size(morph_3, 1))});
    axis image;
    axis off;
    drawnow;
    try
        % VideoWriter based video creation
        h_avi.writeVideo(getframe(gcf));
    catch
        % Fallback deprecated avifile based video creation
        h_avi = addframe(h_avi, getframe(gcf));
    end
end

% Write the fourth morph
for k = 1 : size(morph_4, 1) + 5
    imagesc(morph_4{min(k, size(morph_4, 1))});
    axis image;
    axis off;
    drawnow;
    try
        % VideoWriter based video creation
        h_avi.writeVideo(getframe(gcf));
    catch
        % Fallback deprecated avifile based video creation
        h_avi = addframe(h_avi, getframe(gcf));
    end
end

try
    % VideoWriter based video creation
    h_avi.close();
catch
    % Fallback deprecated avifile based video creation
    h_avi = close(h_avi);
end
clear h_avi;
