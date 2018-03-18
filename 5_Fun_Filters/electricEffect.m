%% Copyright description
% Author & Copyright: Dian Chen
% Date: 10/28/2017
% Mini project for CIS 581 (17fall)

%% Function definition
function If = electricEffect(I)

If = I;

sobelHorizontal = [3, 0, -3;
                   10, 0, -10;
                   3, 0, -3];

sobelVertical = [3, 10, 3;
                 0, 0, 0;
                 -3, -10, -3];

% Compute gradients in three channels
gradientHRed = conv2(If(:, :, 1), sobelHorizontal, 'same');
gradientVRed = conv2(If(:, :, 1), sobelVertical, 'same');

gradientHGreen = conv2(If(:, :, 2), sobelHorizontal, 'same');
gradientVGreen = conv2(If(:, :, 2), sobelVertical, 'same');

gradientHBlue = conv2(If(:, :, 3), sobelHorizontal, 'same');
gradientVBlue = conv2(If(:, :, 3), sobelVertical, 'same');

% Compute the length of gradients and set them as the color values
If(:, :, 1) = uint8(sqrt(gradientHRed .* gradientHRed + gradientVRed .* gradientVRed));
If(:, :, 2) = uint8(sqrt(gradientHGreen .* gradientHGreen + gradientVGreen .* gradientVGreen));
If(:, :, 3) = uint8(sqrt(gradientHBlue .* gradientHBlue + gradientVBlue .* gradientVBlue));

end