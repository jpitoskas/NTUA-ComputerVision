clear all;
close all;
clc;

% Set the default color for all graphics objects to white
set(0,'defaultfigurecolor',[1 1 1])
set(0,'DefaultFigureVisible','on')

disp("Data fetching...");

% Set directories
loc = '../cv19_lab2_material_part2/part2/samples/';
boxing_dir = dir([strcat(loc,'boxing') '/*.avi']);
walking_dir = dir([strcat(loc,'walking') '/*.avi']);
running_dir = dir([strcat(loc,'running') '/*.avi']);

% Read Video Data
boxing = read_videos(boxing_dir);
walking = read_videos(walking_dir);
running = read_videos(running_dir);

n_boxing = length(boxing);
n_walking = length(walking);
n_running = length(running);

data = vertcat(boxing,walking,running);
n_data = length(data);

% Determine number of interest points
n_interestPoints = 500;

% Harris Detectors
disp("Calculating Harris...");
sigma_harris = 2;
tau_harris = 2.5;
for i=1:n_data
    HarrisParameters(:,:,i) = HarrisDetector(data{i},sigma_harris,tau_harris);
end

% Gabor Detector
disp("Calculating Gabor...");
sigma_gabor = 1.5;
tau_gabor = 3;
for i=1:n_data
    GaborParameters(:,:,i) = GaborDetector(data{i},sigma_gabor,tau_gabor);
end

% Choose eiter Harris or Gabor as Parameters
Parameters = GaborParameters;

% nbins and [n,m]
nbins = 6;
grid_dim = [3 3];

% Descriptors HOG/HOF, HOG, HOF
disp("Calculating Descriptors...");
features = [];
for i=1:n_data
    disp(i);
    hof = HOF(data{i}, Parameters(:,:,i), nbins, grid_dim);
    hog = HOG(data{i}, Parameters(:,:,i), nbins, grid_dim);
    HOGfeatures(:,:,i) = hog;
    HOFfeatures(:,:,i) = hof;
    featureVector(:,:,i) = horzcat(hog,hof);
    features = [features; featureVector(:,:,i)];
end

HOGfeats = [];
HOFfeats = [];
for i=1:n_data
    HOGfeats = [HOGfeats; HOGfeatures(:,:,i)];
    HOFfeats = [HOFfeats; HOGfeatures(:,:,i)];
end
   


disp("Calculating BoVW...");

% kmeans to find centers
a = 50;
n_centroids = a;
% choose either features, HOGfeatures, HOFfeatures
[idx, C] = kmeans(features,n_centroids);

for i=1:n_data
    i_start = (i-1)*n_interestPoints + 1;
    i_end = i*n_interestPoints;
    globalRepr(i,:) = histc(idx(i_start:i_end),1:n_centroids);
    norm_L2 = norm(globalRepr(i,:),2);
    globalRepr(i,:) = globalRepr(i,:) ./ norm_L2;
end

% % Plot Histograms
% for i=1:n_data
%     figure;
%     bar(1:n_centroids,globalRepr(i,:),'histc');
% end

D = pdist(globalRepr,@distChiSq);
Z = linkage(globalRepr,'average',{@distChiSq});

figure;
labels = ['Box_1'; 'Box_2'; 'Box_3'; 'Wlk_1'; 'Wlk_2'; 'Wlk_3'; 'Run_1'; 'Run_2'; 'Run_3';];
dendrogram(Z,'Labels',labels);

