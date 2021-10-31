clear all;
close all;
clc;

% set the default color for all graphics objects to white
set(0,'defaultfigurecolor',[1 1 1])
set(0,'DefaultFigureVisible','on')

% Read PNG Data
loc = '../cv19_lab2_material_part1/part1/GreekSignLanguage/GSLframes/';
num = numel(dir([loc '/*.png']));

% Read Skin Samples
load '../cv19_lab2_material_part1/part1/skinSamplesRGB';
[mean_CbCr, cov_CbCr]  = MultivariateGaussian(skinSamplesRGB);


% Read PNG Data
idx = 1;
path1 = strcat(loc, int2str(idx), '.png');
path2 = strcat(loc, int2str(idx+1), '.png');

% path = 'C:/Users/JPitoskas/Desktop/ste.jpg';
rgb1 = imread(path1);
rgb2 = imread(path2);
[N,M,~] = size(rgb1);

% Detect Face of 1st frame
[skin, x ,y ,width ,height] = DetectFace(rgb1, mean_CbCr, cov_CbCr);

x = x - 5;
y = y - 5;
width = width + 10;
height = height + 10;

rho = 5;
epsilon = 0.05;

d_x0 = zeros(height+1, width+1);
d_y0 = zeros(height+1, width+1);

n_scales = 5;

for i = 1:(num-1)
    
    path1 = strcat(loc, int2str(i), '.png');
    path2 = strcat(loc, int2str(i+1), '.png');
    
    rgb1 = imread(path1);
    rgb2 = imread(path2);
    
    I1 = rgb1(y:y+height,x:x+width);
    I2 = rgb2(y:y+height,x:x+width);
    
%   Choose between uniscale or multiscale Lucas-Kanade
    [d_x,d_y] = lk(I1,I2,rho,epsilon,d_x0,d_y0);
%     [d_x,d_y] = lk_multiscale(I1,I2,rho,epsilon,n_scales);

    d_x_r = imresize(d_x,0.3);
    d_y_r = imresize(d_y,0.3);

    
    [displ_x, displ_y] = displ(d_x_r, d_y_r);
    x = x - displ_x;
    y = y - displ_y;
%     figure;
%     imshow(d_x.^2 + d_y.^2);
%     title(['Energy of Optical Flow from Frame ',num2str(i),' to ',num2str(i+1)]); 
%     figure;
%     quiver(-d_x_r,-d_y_r);
%     title(['Optical Flow from Frame ',num2str(i),' to ',num2str(i+1)]);
    figure;
    imshow(rgb2);
    hold on;
    face = rectangle('Position',[round(x) round(y) width height]);
    face.EdgeColor = 'g';
    face.LineWidth = 1.5;
    hold off;

end







        
      












