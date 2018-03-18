%% Copyright description
% Author & Copyright: Yu Sun
% Date: 10/28/2017
% Mini project for CIS 581 (17fall)

function Filtered = DTF(I, sigma_s, sigma_r,N)
    % implementation for RF filter described in paper:
    % Domain Transform for Edge-Aware Image and Video Processing

    % I: input image to be filtered
    % sigma_s: spatial sdv
    % sigma_r: range sdv
    % N: num of iterations performed

% dx in H*(W-1), dy in (H-1)*W
dy = abs(diff(I,1,1));
dx = abs(diff(I,1,2));
% sum up l1 norm dist
cumdy = sum(dy,3);
cumdx = sum(dx,3);

Hy = 1+sigma_s/sigma_r*cumdy;
Hx = 1+sigma_s/sigma_r*cumdx;

Filtered  = I;
for i = 1:N
    sig = sigma_s*sqrt(3)*2^(N-i)/sqrt(4^N-1);
    Filtered = BoxFilterHor(Filtered,Hx,sig); 
    Filtered = BoxFilterVer(Filtered,Hy,sig);
end

end