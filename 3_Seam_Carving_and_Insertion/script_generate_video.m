% File Name: script_generate_video.m
% Author: Dian Chen
% Date: 10/22/2017

% Since the provided function prototypes don't allow the intermediate
% information needed to generate the images with seam highlighted, the
% video generation has to be put inside the carv(I, nr, nc). Additionally,
% I implemented two utility functions: genSeamEffectVer(I, Mx, Tbx) and
% genSeamEffectHor(I, My, Tby), to generate the image with seam
% highlighted for the current carved (inserted) image.

% If you want to generate a video apart from seeing the final carved image,
% go to carv.m (insert.m) line 17 and set the flag to true; if not then set
% the flag to false which can save some processing time.

% Read in source image
I = imread('poi.jpg');

% Set the number of columns & rows to remove or insert
carveRows = 20;
carveColumns = 20;

insertRows = 10;
insertColumns = 5;

% Compute the resulted images (and maybe write videos inside these functions)
I_carved = carv(I, carveRows, carveColumns);
I_inserted = insert(I, insertRows, insertColumns);

% Write the resulted images
imwrite(I_carved, 'carved.jpg');
imwrite(I_inserted, 'inserted.jpg');

% Display
figure;
subplot(1, 3, 1); imshow(I); title('original');
subplot(1, 3, 2); imshow(I_carved); title('carved');
subplot(1, 3, 3); imshow(I_inserted); title('inserted');
