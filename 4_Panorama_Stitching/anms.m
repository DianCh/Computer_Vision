% File name: anms.m
% Author: Yu Sun
% Date created: 11/06/2017

function [y, x, rmax] = anms(cimg, max_pts)
% Input:
% cimg = corner strength map
% max_pts = number of corners desired

% Output:
% [x, y] = coordinates of corners
% rmax = suppression radius used to get max_pts corners

% Write Your Own Code Here

coord = cimg.Location;
metric = cimg.Metric;
N = cimg.Count;
if max_pts > N
    max_pts = N;
end
min_dist = zeros(N,1);
for i = 1:N
    curr = metric(i);
    idx = (metric*0.9)>=curr;
    pts = coord(idx,:);
    dist = pts-repmat(coord(i,:),size(pts,1),1);
    l2 = dist(:,1).^2+dist(:,2).^2;
    if isempty(l2)
        min_dist(i,1) = 0;
    else
        min_dist(i,1) = min(l2);
    end
end
[min_dist, ridx] = sort(min_dist, 'descend'); 
x    = coord(ridx(1 : max_pts),1);
y    = coord(ridx(1 : max_pts),2);
rmax = sqrt(min_dist(1 : max_pts));
end