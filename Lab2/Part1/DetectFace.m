function [skin, x ,y ,width ,height] = DetectFace(rgb, mean_CbCr, cov_CbCr)
    
    % Image Dimensions     
    [N,M,~] = size(rgb);
    
    % RGB to YCbCr     
    YCbCr = im2double(rgb2ycbcr(rgb));
    Cb = YCbCr(:,:,2);
    Cr = YCbCr(:,:,3);
    CbCr = [Cb(:) Cr(:)];

    % Probability Calculation and Skin Detection
    probability = reshape(mvnpdf(CbCr, mean_CbCr, cov_CbCr),[N,M]);

    threshold = 0.2/(2*pi*(sqrt(det(cov_CbCr))));
%     threshold = 0.2;
    skin = (probability > threshold);
%     imshow(skin);


    [x,y,width,height] = fd(skin,mean_CbCr, cov_CbCr);

    figure;
    imshow(rgb);
    hold on;
    face = rectangle('Position',[x y width height]);
    face.EdgeColor = 'g';
    face.LineWidth = 1.5;
    hold off;
    
end