function resultImg = reconstructImg(indexes, red, green, blue, targetImg)
%% Enter Your Code Here

% Initialize the resulting image to exact the same target image
resultImg = targetImg;

% Loop over each pixel in the indexes map
for i = 1 : size(indexes, 1)
    for j = 1 : size(indexes, 2)
        
        % Paste the new pixel values to the result image only if it's an
        % interior (foreground) pixel
        if (indexes(i, j))
            resultImg(i, j, 1) = red(indexes(i, j));
            resultImg(i, j, 2) = green(indexes(i, j));
            resultImg(i, j, 3) = blue(indexes(i, j));
        end
    end
end

end