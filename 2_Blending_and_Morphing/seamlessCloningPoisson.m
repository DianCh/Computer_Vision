function resultImg = seamlessCloningPoisson(sourceImg, targetImg, mask, offsetX, offsetY)
%% Enter Your Code Here

% First generate the indexes map
indexes = getIndexes(mask, size(targetImg, 1), size(targetImg, 2), offsetX, offsetY);

% Compute the coefficient matrix
A = getCoefficientMatrix(indexes);

% Compute the solution vectors in three channels
b_red = getSolutionVect(indexes, sourceImg(:, :, 1), targetImg(:, :, 1), offsetX, offsetY);
b_green = getSolutionVect(indexes, sourceImg(:, :, 2), targetImg(:, :, 2), offsetX, offsetY);
b_blue = getSolutionVect(indexes, sourceImg(:, :, 3), targetImg(:, :, 3), offsetX, offsetY);

% Solve for the replacement pixels in three channels
red = A \ b_red;
green = A \ b_green;
blue = A \ b_blue;

% Get the final blended image
resultImg = reconstructImg(indexes, red, green, blue, targetImg);

end