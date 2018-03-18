%% Copyright description
% Author & Copyright: Dian Chen
% Date: 10/28/2017
% Mini project for CIS 581 (17fall)

%% Function definition
function If = bloomEffect(I)

If = I;

% This is a 7 by 7 Gaussian kernal
bloomKernel = [0.002121, 0.005461, 0.009629, 0.011633, 0.009629, 0.005461, 0.002121;
               0.005461, 0.014059, 0.024791, 0.029949, 0.024791, 0.014059, 0.005461;
               0.009629, 0.024791, 0.043715, 0.052812, 0.043715, 0.024791, 0.009629;
               0.011633, 0.029949, 0.052812, 0.063802, 0.052812, 0.029949, 0.011633;
               0.009629, 0.024791, 0.043715, 0.052812, 0.043715, 0.024791, 0.009629;
               0.005461, 0.014059, 0.024791, 0.029949, 0.024791, 0.014059, 0.005461;
               0.002121, 0.005461, 0.009629, 0.011633, 0.009629, 0.005461, 0.002121];
radius = 3;

I_temp = double(padarray(I, [radius, radius], 'symmetric', 'both'));
           
thresh = 0.2 * 255;

for i = 1 : size(I, 1)
    for j = 1 : size(I, 2)
        patch = I_temp(i : i + 2 * radius, j : j + 2 * radius, :);
        
        % For pixels below the threshold, set their contribution to 0
        patch(patch < thresh) = 0;
        
        If(i, j, 1) = If(i, j, 1) + sum(sum(bloomKernel .* patch(:, :, 1)));
        If(i, j, 2) = If(i, j, 2) + sum(sum(bloomKernel .* patch(:, :, 2)));
        If(i, j, 3) = If(i, j, 3) + sum(sum(bloomKernel .* patch(:, :, 3)));
        
    end
end

If = uint8(If);

end
