%% Clear
clear all
close all
clc

%% Input and display the binary image
I0 = imread('lenna.tif');
row = size(I0,1);
column=size(I0,2);
I=rgb2gray(I0);
I=double(I);

%% Blur the image, corrupt the image using WGN and display it
% h is the blurring kernel, and sigma is the noise standard deviation
h = ones(4,4)/16;

sigma = 20;
If = dft2(I);
h=[h zeros(size(h,2),column-size(h,2));zeros(row-size(h,1),column)];
Hf = dft2(h);

y = real(idft2(Hf.*If))+sigma*randn(row,column); % circular convolution %randn is normally distributed
%y = filter2(h,x)+sigma*randn(N,N);	  % linear convolution

%% Restoration using generalized Wiener filtering
gamma = 1;
alpha = 1;
ewx = WienerFilter_dft(y,h,sigma);
PSNR = abs([psnr(I,I) psnr(y,I) psnr(ewx,I)]) %peak to noise ratio
MSE = [immse(I,I) immse(y,I) immse(ewx,I)] %Mean squared error
subplot(221)
imshow(I0)
subplot(222)
imshow(I,gray(256))
subplot(223)
imshow(y,gray(256))
subplot(224)
imshow(ewx,gray(256))
return
