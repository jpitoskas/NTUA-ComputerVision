function output = GaborDetector(I,sigma,tau)
    
    [N,M,frames] = size(I);
    I = im2double(I);
    
%   Gaussian for spatial filtering
    ns = 2*ceil(3*sigma) + 1;
    g = fspecial('gaussian',ns,sigma);
    
%   Pair of Gabor for time filtering 
    w = 4/tau;
    t = (-2*tau):(2*tau);
%     t = linspace(-2*tau,2*tau,2*tau + 1);
    hev(1,1,:) = -cos(2*pi*t*w).*exp(-(t.^2)/(2*tau^2));
    hod(1,1,:) = -sin(2*pi*t*w).*exp(-(t.^2)/(2*tau^2));
    
%   norm-1 of Gabor pair of filters
    hev_norm1 = sum(abs(hev(1,1,:)));
    hod_norm1 = sum(abs(hod(1,1,:)));
    
    hev(1,1,:) = hev ./ hev_norm1;
    hod(1,1,:) = hod ./ hod_norm1;
    
%   Gev = hev*g , God = hod*g
    Gev = convn(g,hev);
    God = convn(g,hod);
    
    Iev = imfilter(I, Gev, 'symmetric');
    Iod = imfilter(I, God, 'symmetric');
    
    H = Iev.^2 + Iod.^2;
    
    %   Apply Criterion
    criterion = imregionalmax(H);
    H(criterion == 0) = 0;
    
    
    %   Discard edge points and first/last frame  
    space = 8; 
    
    H(1:space,:,:)   =  0;
    H(N-space:N,:,:) =  0;
    H(:,1:space,:)   =  0;
    H(:,M-space:M,:) =  0;
    H(:,:,1)         =  0;
    H(:,:,frames)    =  0;

% %   Extra Conditions
% 
%     radius = 5;
%     [X,Y,Z] = ndgrid(-radius:radius);
%     B = strel(sqrt(X.^2 + Y.^2 + Z.^2) <=radius);    
    
%     Hmax = max(H(:));
%     Cond1 = (H == imdilate(H, B));                                                          %efarmogh kernel gia thn euresh twn topikwn megistwn shmeiwn sto H
%     Cond2 = H > theta_corn*Hmax;
    
    
    num_points = 500;
    H_sorted = sort(H(:),'descend');
    threshold = H_sorted(num_points);
    
%     Cond = Cond1 & Cond2 & (H >= threshold);

    [y,x,t] = ind2sub(size(H),find(H >= threshold));
%     [y,x,t] = ind2sub(size(H),find(Cond));
    num_points = length(x);

    points = horzcat(x,y, repmat(sigma,num_points,1),t);
%     showDetection(I,points,t);
    output = points;
    
end

