% File name: test.m
% test script to generate the mosaic video
% Author: Dian Chen
% Date created: 11/11/2017

filename_1 = 'Video1.mp4';
filename_2 = 'Video2.mp4';
filename_3 = 'Video3.mp4';

reader_1 = VideoReader(filename_1);
reader_2 = VideoReader(filename_2);
reader_3 = VideoReader(filename_3);

stitched_frames = cell(num_frames, 1);

img_input = cell(3, 1);

% Because the last 20 frames of the videos are of relatively low quality in
% our experiments, we decided to stitch only the first 45 frames
for k = 1 : 45
    
    img_input{1, 1} = im2double(read(reader_1, k));
    img_input{2, 1} = im2double(read(reader_2, k));
    img_input{3, 1} = im2double(read(reader_3, k));
     
    stitched_frames{k, 1} = mymosaic(img_input);
    
end

