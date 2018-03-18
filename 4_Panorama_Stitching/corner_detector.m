% File name: corner_detector.m
% Author: Yu Sun
% Date created: 11/05/2017

function [cimg] = corner_detector(img)
% Input:
% img is an image

% Output:
% cimg is a corner matrix

% Write Your Code Here
cimg = detectHarrisFeatures(img);
end