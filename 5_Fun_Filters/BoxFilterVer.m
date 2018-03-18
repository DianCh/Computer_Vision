%% Copyright description
% Author & Copyright: Yu Sun
% Date: 10/28/2017
% Mini project for CIS 581 (17fall)
% % % % % % % % % % % % % % % % %
% Box Filter in vertical direction
function Filtered = BoxFilterVer(I,dtr,sigma)
[H,~,dim] = size(I);
a = exp(-sqrt(2.0)/sigma);
Filtered = I;
V = a.^dtr;
% up to down
for i = 2:H
    for c = 1:dim
        Filtered(i,:,c) = Filtered(i,:,c) + V(i-1,:).* (Filtered(i-1,:,c) - Filtered(i,:,c));
    end
end
% down to up
for i = H-1:-1:1
    for c = 1:dim
        Filtered(i,:,c) = Filtered(i,:,c) + V(i,:).* (Filtered(i+1,:,c) - Filtered(i,:,c));
    end
end
end