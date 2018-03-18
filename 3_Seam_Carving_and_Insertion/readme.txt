% Author: Dian Chen
% Date: 10/28/2017
% Readme for Project 3 part A, CIS 581 17fall

================================General Notice============================

1. Since the provided function prototypes don't allow the intermediate information needed to generate the images with seam highlighted, the video generation has to be put inside the carv(I, nr, nc). 

Additionally, I implemented two utility functions: 

genSeamEffectVer(I, Mx, Tbx) and genSeamEffectHor(I, My, Tby), 

to generate the image with seam highlighted for the current carved (inserted) image.

2. IMPORTANT: If you want to generate a video apart from seeing the final carved image, go to carv.m (insert.m) line 17 and set the flag to true; if not then set the flag to false which can save some processing time.

3. The script for generating videos is “script_generate_video.m”. Videos are converted to “.mov” format to save space. The carving video is “carving_sequence.mov”, and the inserting video is “inserting_sequence.mov”.

4. All functionalities are well tested. Videos for one picture were generated. You can test and generate videos on other images if you want.

=============================EC: Seam Insertion============================

1. Seam insertion is implemented in “insert.m” and is well tested.

2. The color for the inserted pixels are computed by taking the average of its two neighbors.