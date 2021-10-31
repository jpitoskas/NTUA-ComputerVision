function output = HarrisDetector(I,sigma,tau)
    
    k = 0.005;
    
    [N,M,frames] = size(I);
    
    I = im2double(I);
    
    % Make the 3D gaussian in order to filter the given video.
    ns = 2*ceil(3*sigma) + 1;
    nt = 2*ceil(3*tau) + 1;
    
    Gxy = fspecial('gaussian',ns,sigma);
    Gt(1,1,:) = gausswin(nt,tau);
    
    g = convn(Gxy,Gt,'same');
    Is = imfilter(I, g, 'symmetric');
    
%   gradient with kernel of central differences
    x_kernel = [-1 0 1];
    y_kernel = [-1 0 1]';
    t_kernel(1,1,:) = [-1 0 1];
    
    Ix = imfilter(Is, x_kernel, 'symmetric');                                        %upologismos paragwgou ws pros x me kerner [-1 0 1]
    Iy = imfilter(Is, y_kernel, 'symmetric'); 
    It = imfilter(Is, t_kernel, 'symmetric');

    
%   Calculate elements of M
    J11 = imfilter(Ix.*Ix, g, 'symmetric');
    J22 = imfilter(Iy.*Iy, g, 'symmetric');
    J33 = imfilter(It.*It, g, 'symmetric');
    J12 = imfilter(Ix.*Iy, g, 'symmetric');
    J13 = imfilter(Ix.*It, g, 'symmetric');
    J23 = imfilter(Iy.*It, g, 'symmetric');
    
    
    detM = J11.*J22.*J33 + 2*J12.*J13.*J23 - J11.*J23.^2 - J22.*J13.^2 - J33.*J12.^2;

    traceM = J11 + J22 + J33;
    
    H = abs(detM - k*traceM.^3);
    
%   Discard edge points and first/last frame
    space = 8; 
    
    H(1:space,:,:)   =  0;
    H(N-space:N,:,:) =  0;
    H(:,1:space,:)   =  0;
    H(:,M-space:M,:) =  0;
    H(:,:,1)         =  0;
    H(:,:,frames)    =  0;
    
%   Apply Criterion
    criterion = imregionalmax(H);
    H(criterion == 0) = 0;
    
% %   Extra Conditions
% 
%     radius = 2;
%     [X,Y,Z] = ndgrid(-radius:radius);
%     B = strel(sqrt(X.^2 + Y.^2 + Z.^2) <=radius);    
%     
%     Hmax = max(H(:));
%     Cond1 = (H == imdilate(H, B));                                                          %efarmogh kernel gia thn euresh twn topikwn megistwn shmeiwn sto H
%     Cond2 = H > theta_corn*Hmax;
%     Cond = Cond1 & Cond2;

%     B_sq = strel('sphere', ns);
%     Cond1 = (H == imdilate(H, B_sq));
%     Cond2 = (H >= theta_corn*max(H(:)));
%     Cond = Cond1&Cond2;
    
    num_points = 500;
    H_sorted = sort(H(:),'descend');
    threshold = H_sorted(num_points);

    [y,x,t] = ind2sub(size(H),find(H >= threshold));
%     [y,x,t] = ind2sub(size(H),find(Cond));
    num_points = length(x);

    points = horzcat(x,y, repmat(sigma,num_points,1),t);
%     showDetection(I,points,t);
    output = points;
    
end
    
    
    
    
    
    
    
