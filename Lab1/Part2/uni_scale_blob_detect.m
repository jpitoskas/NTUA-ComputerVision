function output = uni_scale_blob_detect(I)
    
    sigma = 2;
    r = 2.5;
    k = 0.05;
    theta_corn = 0.008;
    s = 1.8;
    N = 4;
    
    if size(I,3)==3
        I_gray = rgb2gray(I);
    else
        I_gray = I;
    end
    
    ns = 2*ceil(3*sigma) + 1;
    Gs = fspecial('gaussian', ns, sigma);
    Is = imfilter(I_gray, Gs, 'symmetric');
    
    % 2.3.1
    
    % Calculating the Hessian: 
    %
    %               ?                           ? 
    %               ? Lxx(x,y,ó)     Lxy(x,y,ó) ?  
    %     H(x,y) =  ?                           ? 
    %               ? Lyx(x,y,ó)     Lyy(x,y,ó) ?
    %               ?                           ?
    % 
    % where Lxx, Lxy = Lyx, Lyy are the partial derivatives of Is    
    
    [Lx,Ly] = gradient(Is);
    [Lxx, Lxy] = gradient(Lx);
    [Lyx, Lyy] = gradient(Ly);
    
    
    % for given ó: R(x,y)=det(H(x,y)) => R(x,y)=?H(x,y)?
    R = Lxx.*Lyy - Lxy.*Lyx;
    
    % 2.3.2
    
    B_sq = strel('disk', ns);
    Cond1 = (R == imdilate(R, B_sq));
    Cond2 = (R > theta_corn*max(R));
    
    [xy(:,2),xy(:,1)] = find(Cond1 & Cond2);
    parameters = horzcat(xy, ones(size(xy, 1), 1) * sigma);
    figure('Name', 'Uniscale blob detect');
    interest_points_visualization(I, parameters);
    
    output = parameters;
    
end
    
    
    
    
    
    
    