%% Copyright description
% Author & Copyright: Yu Sun
% Date: 10/28/2017
% Mini project for CIS 581 (17fall)
% % % % % % % % % % % % % % % % %
% Box Filter in horizontal direction

function Filtered = BoxFilterHor(I,dtr,sigma)
[~,W,dim] = size(I);
a = exp(-sqrt(2.0)/sigma);
Filtered = I;
V = a.^dtr;
% left to right 
for i = 2:W
    for c = 1:dim
        Filtered(:,i,c) = Filtered(:,i,c)+V(:,i-1) .* ( Filtered(:,i-1,c) - Filtered(:,i,c));
    end
end
% right to left
for i = W-1:-1:1
    for c = 1:dim
        Filtered(:,i,c) = Filtered(:,i,c) + V(:,i) .* ( Filtered(:,i+1,c) - Filtered(:,i,c));
    end
end

end