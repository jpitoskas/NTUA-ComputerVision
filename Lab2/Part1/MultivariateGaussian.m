function [mu, Cov] = MultivariateGaussian(skinSamplesRGB)
    
    skinSamplesYCbCr = im2double(rgb2ycbcr(skinSamplesRGB));
    
    % Gaussian Distribution parameters
    skinSamplesCb = skinSamplesYCbCr(:,:,2);
    skinSamplesCr = skinSamplesYCbCr(:,:,3);

    % Calculate the mean of Cb and Cr
    mean_Cb = mean2(skinSamplesCb);
    mean_Cr = mean2(skinSamplesCr);
    mu = [mean_Cb mean_Cr];

    % Calculate the covariance matrix
    Cov = cov(skinSamplesCb(:,:), skinSamplesCr(:,:));
    
end
