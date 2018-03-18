% File name: mymosaic.m
% Author: Yu Sun
% Date created: 11/06/2017

function [img_mosaic] = mymosaic(img_input)
% Input:
%   img_input is a cell array of color images (HxWx3 uint8 values in the
%   range [0,255])
%
% Output:
% img_mosaic is the output mosaic
% not sure if we are supposed to stitch all instances according to pdf
% doesn't make sense to have two functions then
% therefore here it's only stitching for one instance

N = size(img_input,1);
center = ceil(N/2);

img_mosaic = img_input{center};

% stitch all frames together to the center
for i = 1:N
    if i < center
        img_mosaic = stitch(img_mosaic,img_input{center-i});
    elseif i > center
        img_mosaic = stitch(img_mosaic,img_input{i});
    end        
end
end