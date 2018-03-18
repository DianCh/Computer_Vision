%% Copyright description
% Author & Copyright: Dian Chen
% Date: 10/14/2017
% Project 2 blend script for CIS 581 (17fall)

%% Image acquisition & offsets setup
sourceImg = imresize(imread('source_shaw.jpg'), 0.37);
targetImg = imread('target_root.png');

offsetX = 450;
offsetY = 110;

%% Blending
% Generate mask from GUI
mask = maskImage(sourceImg);

% Perform blending
resultImg = seamlessCloningPoisson(sourceImg, targetImg, mask, offsetX, offsetY);

% Display & store image
imshow(resultImg);
imwrite(resultImg, 'blending_result.jpg');