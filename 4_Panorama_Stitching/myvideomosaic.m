% File name: myvideomosaic.m
% Author:
% Date created:

function [video_mosaic] = myvideomosaic(img_mosaic)
% Input:
% img_mosaic: M × 1 cell vector representing the stitched image mosaic for
% every frame
%
% Output:
% video_mosaic: Video file in either .avi or .mp4 format

M = size(img_mosaic, 1);
fname = 'stitch.avi';
try
% VideoWriter based video creation
    h_avi = VideoWriter(fname, 'Uncompressed AVI');
    h_avi.FrameRate = 10;
    h_avi.open();
catch
% Fallback deprecated avifile based video creation
    h_avi = avifile(fname,'fps', 10);
end
    
for k = 1 : M
    imagesc(img_mosaic{k, 1});
    axis image;
    axis off;
    drawnow;
    try
        h_avi.writeVideo(getframe(gcf));
    catch
        h_avi = addframe(h_avi, getframe(gcf));
    end
end

try
    h_avi.close();
catch
    h_avi = close(h_avi);
end

clear h_avi;

video_mosaic = 1;
end