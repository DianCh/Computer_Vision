%% Copyright description
% Author & Copyright: Dian Chen, Yu Sun
% Date: 10/28/2017
% Mini project for CIS 581 (17fall)

I = imread('mario.png');

I1 = im2double(I);

sigma_s = 60;
sigma_r = 0.4;
iter = 3;

%% Filter using DTF
Filtered = DTF(I1, sigma_s, sigma_r,iter);

% Testing different effects
%% enhancement
Enhanced = Enhance(I1,Filtered,40);

%% stylization
Stylized = Stylization(Filtered,0.2);

%% sobel effect
Electric = electricEffect(I);

%% bloom effect
Bloom = bloomEffect(I);

%% mosaic effect
Mosaic = mosaicEffect(I);

%% bubble effect
Bubble = bubbleEffect(I);

%% Plotting the results
subplot(2, 4, 1); imshow(I); title('original img');
subplot(2, 4, 2); imshow(Filtered); title('recursive filter');
subplot(2, 4, 3); imshow(Enhanced); title('enhanced img');
subplot(2, 4, 4); imshow(Stylized); title('stylization img');

subplot(2, 4, 5); imshow(Electric); title('Electric Effect');
subplot(2, 4, 6); imshow(Bloom); title('Blooming Effect');
subplot(2, 4, 7); imshow(Mosaic); title('Mosaic');
subplot(2, 4, 8); imshow(Bubble); title('Bubbles');

imwrite(Filtered, 'Filtered.jpg');
imwrite(Enhanced, 'Enhanced.jpg');
imwrite(Stylized, 'Stylized.jpg');
imwrite(Electric, 'Electric.jpg');
imwrite(Bloom, 'Bloom.jpg');
imwrite(Mosaic, 'Mosaic.jpg');
imwrite(Bubble, 'Bubble.jpg');
