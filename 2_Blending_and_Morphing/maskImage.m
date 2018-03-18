function mask = maskImage(Img)
%% Enter Your Code Here
imshow(Img);
M = imfreehand(gca);
mask = M.createMask;
imshow(mask);

end

