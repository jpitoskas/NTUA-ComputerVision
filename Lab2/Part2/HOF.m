function output = HOF(video, interestPoints, nbins, grid_dim)
    
    video = im2double(video);
    
    n = grid_dim(1);
    m = grid_dim(2);
    
    rho = 5;
    epsilon = 0.01;
    scales = 3;
    n_points = size(interestPoints,1);
    
    HOF_histogram = zeros(n_points, n*m*nbins);
    
    for i = 1:n_points
        y = interestPoints(i,1);
        x = interestPoints(i,2);
        s = interestPoints(i,3);
        t = interestPoints(i,4);
        squareRadius = 4*s;
        d_x0 = zeros(2*squareRadius+1);
        d_y0 = zeros(2*squareRadius+1);
        I1 = padarray(video(:,:,t),[squareRadius squareRadius],0,'both');
        I2 = padarray(video(:,:,t+1),[squareRadius squareRadius],0,'both');
        I1 = I1(x:x+2*squareRadius, y:y+2*squareRadius);
        I2 = I2(x:x+2*squareRadius, y:y+2*squareRadius);
        [Gx,Gy] = lk(I1,I2,rho,epsilon,d_x0,d_y0);
%         [Gx,Gy] = lk_multiscale(I1,I2,rho,epsilon,scales);
        HOF_histogram(i,:) = OrientationHistogram(Gx,Gy,nbins,[n m]);
    end
    
    output = HOF_histogram;
    
end


% function hist_HOF = HOF(myvideo,intpoints,bins,grid_dim)
%     
%     myvideo = im2double(myvideo);
%     n = grid_dim(1);
%     m = grid_dim(2);
%     bsize = 4*intpoints(1,3);
%     %at first we initialize the histogramm with zeros.
%     e = bins*n*m;
%     hist_HOF=zeros(size(intpoints(intpoints(:,4)~=size(myvideo,3),:),1),e);
%     rho=5;
%     epsilon=0.03;
%     scales=3;
%     %and then for each point we select two continuous frames,crop them, and calculate the
%     %apply Multiscale Lucas Kanade Algorithm.
%     for i = 1 : size(intpoints(intpoints(:,4)~=size(myvideo,3),:),1)
%         selectedframe1 = myvideo(:,:,intpoints(i,4));
%         croppedimage1 = imcrop(selectedframe1,[min(max(intpoints(i,1)-bsize/2,1),size(myvideo,2)-bsize-1),min(max(intpoints(i,2)-bsize/2,1),size(myvideo,1)-bsize-1), bsize+1,bsize+1]);
% %         if( intpoints(i,4)+1 >=200)
% %             disp("mpika");
% %             continue;
% %         end
%         selectedframe2 = myvideo(:,:,intpoints(i,4)+1);
%         croppedimage2 = imcrop(selectedframe2,[min(max(intpoints(i,1)-bsize/2,1),size(myvideo,2)-bsize-1),min(max(intpoints(i,2)-bsize/2,1),size(myvideo,1)-bsize-1), bsize+1,bsize+1]);
%         
%         [dx,dy] = lk_multiscale(croppedimage1,croppedimage2,rho,epsilon,scales);
%         hist_HOF(i,:)= OrientationHistogram(dx,dy,bins,[n m]);
%     end
%     
% end
        