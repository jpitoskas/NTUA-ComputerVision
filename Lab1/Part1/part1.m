clear all;
close all;
clc;

I0 = imread('../cv19_lab1_parts1_2_material/venice_edges.png');
figure(1)
imshow(I0);
title('Real image')
I0 = im2double(I0);

PSNR(1) = 20;
PSNR(2) = 10;
Imax = max(max(I0));
Imin = min(min(I0));
var = (Imax - Imin)./(10.^(PSNR/20));
I0noise(:,:,1) = imnoise(I0,'gaussian',0,var(1));
figure(2)
imshow(I0noise(:,:,1));
title('Noisy image with psnr = 20')
I0noise(:,:,2) = imnoise(I0,'gaussian',0,var(2));
figure(3)
imshow(I0noise(:,:,2));
title('Noisy image with psnr = 10')

sigma = 1.5;
thetaEdge = 0.3;
LaplaceType = 1;
D = EdgeDetect(I0noise(:,:,1),sigma,thetaEdge,LaplaceType);
figure(4)
imshow(D);
title('Edge detection by EdgeDetect function')

%evaluating results of edge detection
B=strel('disk',1);
M = imdilate(I0,B) - imerode(I0,B);
T = (M>thetaEdge);
figure(5)
imshow(T);
title('Real Edge detection')

TandD = T & D;
Precision = sum(TandD(:))/sum(D(:));
Recall = sum(TandD(:))/sum(T(:));
C = (Precision + Recall)/2;
