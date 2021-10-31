clear all
close all;
clc;
clear variables;
set(0,'DefaultFigureVisible','off')

% set the default color for all graphics objects to white
set(0,'defaultfigurecolor',[1 1 1])

% add path of detectors if necessary
addpath(genpath('../Part2'));
addpath(genpath('../Part3'));
addpath(genpath('../cv19_lab1_part3_material/descriptors'));
addpath(genpath('../cv19_lab1_part3_material/matching'));
addpath(genpath('../cv19_lab1_part3_material/detectors'));
addpath(genpath('../cv19_lab1_part3_material/classification'));
addpath(genpath('../cv19_lab1_part3_material/classification/libsvm-3.17'));

% sigma = 2;
% p = 2.5;
% k = 0.05;
% th_corn = 0.005;
% s = 1.5;
% N = 4;
sc_error = cell(2,5);
th_error = cell(2,5);

% SURF

tic;
detector_func = @(image) uni_scale_angle_detect(image);
descriptor_func = @(image,points) featuresSURF(image,points);
[sc_error{1,1},th_error{1,1}] = evaluation(detector_func, descriptor_func);
toc;

tic;
detector_func = @(image) multi_scale_angle_detect(image);
descriptor_func = @(image,points) featuresSURF(image,points);
[sc_error{1,2},th_error{1,2}] = evaluation(detector_func, descriptor_func);
toc;

tic;
detector_func = @(image) uni_scale_blob_detect(image);
descriptor_func = @(image,points) featuresSURF(image,points);
[sc_error{1,3},th_error{1,3}] = evaluation(detector_func, descriptor_func);
toc;

tic;
detector_func = @(image) multi_scale_blob_detect(image);
descriptor_func = @(image,points) featuresSURF(image,points);
[sc_error{1,4},th_error{1,4}] = evaluation(detector_func, descriptor_func);
toc;

tic;
detector_func = @(image) box_filters_multi_scale_blob_detect(image, 2.2, 1.85, 4);
descriptor_func = @(image,points) featuresSURF(image,points);
[sc_error{1,5},th_error{1,5}] = evaluation(detector_func, descriptor_func);
toc;

% HOG

tic;
detector_func = @(image) uni_scale_angle_detect(image);
descriptor_func = @(image,points) featuresHOG(image,points);
[sc_error{2,1},th_error{2,1}] = evaluation(detector_func, descriptor_func);
toc;

tic;
detector_func = @(image) multi_scale_angle_detect(image);
descriptor_func = @(image,points) featuresHOG(image,points);
[sc_error{2,2},th_error{2,2}] = evaluation(detector_func, descriptor_func);
toc;

tic;
detector_func = @(image) uni_scale_blob_detect(image);
descriptor_func = @(image,points) featuresHOG(image,points);
[sc_error{2,3},th_error{2,3}] = evaluation(detector_func, descriptor_func);
toc;

tic;
detector_func = @(image) multi_scale_blob_detect(image);
descriptor_func = @(image,points) featuresHOG(image,points);
[sc_error{2,4},th_error{2,4}] = evaluation(detector_func, descriptor_func);
toc;

tic;
detector_func = @(image) box_filters_multi_scale_blob_detect(image, 2.2, 1.85, 4);
descriptor_func = @(image,points) featuresHOG(image,points);
[sc_error{2,5},th_error{2,5}] = evaluation(detector_func, descriptor_func);
toc;
% 
% 
% Save the results so it is not necessary to run the upper script again.
results{1} = sc_error;
results{2} = th_error;
save matching_results results;
% 
results_model = cell(2,3);
cd '../cv19_lab1_part3_material/classification'

% SURF

disp('multi_scale_angle_detect SURF');
descriptor_func = @(image,points) featuresSURF(image,points);
detector_func = @(image) multi_scale_angle_detect(image);
results_model{1,1} = myClassification(detector_func,descriptor_func);

disp('multi_scale_blob_detect SURF');
descriptor_func = @(image,points) featuresSURF(image,points);
detector_func = @(image) multi_scale_blob_detect(image);
results_model{1,2} = myClassification(detector_func,descriptor_func);

disp('box_filters_multi_scale_blob_detect SURF');
descriptor_func = @(image,points) featuresSURF(image,points);
detector_func = @(image) box_filters_multi_scale_blob_detect(image, 2.2, 1.85, 4);
results_model{1,3} = myClassification(detector_func,descriptor_func);

% HOG

disp('multi_scale_angle_detect HOG');
descriptor_func = @(image,points) featuresHOG(image,points);
detector_func = @(image) multi_scale_angle_detect(image);
results_model{2,1} = myClassification(detector_func,descriptor_func);

disp('multi_scale_blob_detect HOG');
descriptor_func = @(image,points) featuresHOG(image,points);
detector_func = @(image) multi_scale_blob_detect(image);
results_model{2,2} = myClassification(detector_func,descriptor_func);

disp('box_filters_multi_scale_blob_detect HOG');
descriptor_func = @(image,points) featuresHOG(image,points);
detector_func = @(image) box_filters_multi_scale_blob_detect(image, 2.2, 1.85, 4);
results_model{2,3} = myClassification(detector_func,descriptor_func);

% Save the results because it will take a lot of time to run the model
% again.
save models results_model;

% Go back to /Part3 folder
cd '../../Part3';





