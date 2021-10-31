function output = HOG(video, interestPoints, nbins, grid_dim)
    
    video = im2double(video);
    
    n = grid_dim(1);
    m = grid_dim(2);
    
    n_points = size(interestPoints,1);
    
    HOG_histogram = zeros(n_points, n*m*nbins);
    
    for i = 1:n_points
        y = interestPoints(i,1);
        x = interestPoints(i,2);
        s = interestPoints(i,3);
        t = interestPoints(i,4);
        squareRadius = 4*s/2;
        I = padarray(video(:,:,t),[squareRadius squareRadius],0,'both');       
        I = I(x:x+2*squareRadius, y:y+2*squareRadius);
        [Gx,Gy] = imgradientxy(I);
        HOG_histogram(i,:) = OrientationHistogram(Gx,Gy,nbins,[n m]);
    end
    
    output = HOG_histogram;
    
end


% function hist_HOG = HOG(video,intpoints,bins,grid_dim)
%     
%     video = im2double(video);
%     
%     bsize = 4*intpoints(1,3);
%     n = grid_dim(1);
%     m = grid_dim(2);
%     %at first we initialize the histogramm with zeros.
%     e=n*m*bins;
%     hist_HOG = zeros(size(intpoints,1),e);
%     
%     %and then for each point we select the frame,crop it, and calculate the
%     %gradient of the cropped image.
%     for i = 1:size(intpoints,1)
%         selectedframe = video(:,:,intpoints(i,4));
%         croppedimage = imcrop(selectedframe,[max(intpoints(i,1)-bsize/2,1),max(intpoints(i,2)-bsize/2,1), bsize+1,bsize+1]);
%         [dx,dy]=imgradientxy(croppedimage);
%         hist_HOG(i,:)= OrientationHistogram(dx,dy,bins,[n m]);
%         
%     end
%     
% end
