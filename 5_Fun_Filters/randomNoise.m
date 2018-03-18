%% Copyright description
% Author & Copyright: Dian Chen
% Date: 10/28/2017
% Mini project for CIS 581 (17fall)

%% Function definition
function noise = randomNoise(p)
% Input p should be a 1 * 2 vector, representing a seed
% Output noise looks random, but is deterministic given the same seed

a = sin([p * [127.1; 311.7], p * [269.5; 183.3]]) * 43758.5453;

noise = a - floor(a);

end