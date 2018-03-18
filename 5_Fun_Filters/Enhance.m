%% Copyright description
% Author & Copyright: Yu Sun
% Date: 10/28/2017
% Mini project for CIS 581 (17fall)
% % % % % % % % % % % % % % % % %
% Input: Smoothed Image and boost Factor for enhancement
% Output: Image with details amplified
% The filter essentially take the difference between the blurred image and
% original image and add it back, creating a detail-amplying effect

function Enhanced = Enhance(I,Filtered,boostFac)
diff = I-Filtered;
diff = diff * boostFac * 0.1;
Enhanced = diff + I;
end