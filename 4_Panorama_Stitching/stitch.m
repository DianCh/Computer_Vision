% File name: stitch.m
% helper function for mymosaic
% Author: Yu Sun
% Date created: 11/06/2017

function img_mosaic = stitch(img1,img2)

% img1 is the dest, img2 source
I1 = rgb2gray(img1);
I2 = rgb2gray(img2);
num_pts = 350;
thresh = 0.5;

% corner detection
cimg1 = corner_detector(I1);
cimg2 = corner_detector(I2);

% Adaptive Non maximum supression
[y1, x1, ~] = anms(cimg1, num_pts);
[y2, x2, ~] = anms(cimg2, num_pts);

% feature descriptors
descs1 = feat_desc(I1, x1, y1);
descs2 = feat_desc(I2, x2, y2);

% find the matching features
match = feat_match(descs1, descs2);

% take out the features with no match
Y1 = y1(match ~= -1);
X1 = x1(match ~= -1);
Y2 = y2(match(match ~= -1));
X2 = x2(match(match ~= -1));
[H, ~] = ransac_est_homography(X2, Y2, X1, Y1,thresh);

% can't get imwarp to work, brute force now
[h2,w2] = size(I2);
[h1,w1] = size(I1);

% use the four corners to calculate the boundary of transformed img
x2_corners = [1;w2;1;w2];
y2_corners = [1;1;h2;h2];
[x2_limit,y2_limit] =  apply_homography(H, x2_corners, y2_corners);
% get the offset for img1
if min(x2_limit)<0
    X_offset = round(abs(min(x2_limit)));
else
    X_offset = 0;
end
if min(y2_limit)<0
    Y_offset = round(abs(min(y2_limit)));
else
    Y_offset = 0;
end
% add offset so upper left corner of transformed img is (1,1)
x2_limit = x2_limit+X_offset+1;
y2_limit = y2_limit+Y_offset+1;

H_inv = est_homography(x2_corners,y2_corners,x2_limit,y2_limit);
h2_tr = round(max(y2_limit));
w2_tr = round(max(x2_limit));
[Y,X] = meshgrid(1:h2_tr, 1:w2_tr);
X = reshape(X,[w2_tr*h2_tr,1]);
Y = reshape(Y,[w2_tr*h2_tr,1]);
[X_transformed,Y_transformed] = apply_homography(H_inv, X, Y);
X_transformed = round(X_transformed);
Y_transformed = round(Y_transformed);
new_h = max(h1+Y_offset,h2_tr);
new_w = max(w1+X_offset,w2_tr);
img_mosaic_1 = zeros(new_h,new_w,3);
img_mosaic_2 = zeros(new_h,new_w,3);
for i = 1: h2_tr*w2_tr
    if(Y_transformed(i,:) <1 || Y_transformed(i,:)>h2 || X_transformed(i,:) <1 || X_transformed(i,:) >w2)
        img_mosaic_2(Y(i,:),X(i,:),:) = 0;
    else
        img_mosaic_2(Y(i,:),X(i,:),:) = img2(Y_transformed(i,:),X_transformed(i,:),:);
    end
end

[X_old,Y_old] = meshgrid(1:w1, 1:h1);
Y_new = Y_old+Y_offset;
X_new = X_old+X_offset;
X_new = reshape(X_new,[w1*h1,1]);
Y_new = reshape(Y_new,[w1*h1,1]);
X_old = reshape(X_old,[w1*h1,1]);
Y_old = reshape(Y_old,[w1*h1,1]);
for i = 1: h1*w1 
    img_mosaic_1(Y_new(i,:),X_new(i,:),:) = img1(Y_old(i,:),X_old(i,:),:);
end

img_mosaic = img_mosaic_1 + img_mosaic_2;
overlap = (img_mosaic_1>0) & (img_mosaic_2>0);
img_mosaic(overlap) = img_mosaic(overlap)/2;

end