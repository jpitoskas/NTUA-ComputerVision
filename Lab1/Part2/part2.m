clear all
close all;
clc;

% set the default color for all graphics objects to white
set(0,'defaultfigurecolor',[1 1 1])
set(0,'DefaultFigureVisible','on')

% read png data
balloons = im2double(imread('../cv19_lab1_parts1_2_material/balloons19.png'));
sunflowers = im2double(imread('../cv19_lab1_parts1_2_material/sunflowers19.png'));

% parameters
sigma = 1.2;
r = 2.5;
k = 0.05;
theta_corn = 0.01;
s = 1.5;
N = 4;

% input = balloons;
input = sunflowers;

% Uniscale & Multiscale Angle Detection
uniscale_angle_detect_params = uni_scale_angle_detect(input);
multiscale_angle_detect_params = multi_scale_angle_detect(input);

% Uniscale & Multiscale Blob Detection
uniscale_blob_detect_params = uni_scale_blob_detect(input);
multiscale_blob_detect_params= multi_scale_blob_detect(input);

% Box Filters
box_filters_uni_scale_blob_detect(input,2.5,true);
box_filters_multi_scale_blob_detect(input,2.2,1.85,4);




