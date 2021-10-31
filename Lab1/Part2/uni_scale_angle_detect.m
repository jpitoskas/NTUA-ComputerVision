function output = uni_scale_angle_detect(I)

    sigma = 2;
    r = 2.5;
    k = 0.05;
    theta_corn = 0.008;
    s = 1.5;
    N = 4;
    
    if size(I,3) == 3
        I_gray = rgb2gray(I);
    else
        I_gray = I;
    end
    
    % 2.1.1
    
    ns = 2*ceil(3*sigma) + 1;
    nr = 2*ceil(3*r) + 1;
    Gs = fspecial('gaussian', ns, sigma);
    Gr = fspecial('gaussian', nr, r);
    
    Is = imfilter(I_gray, Gs, 'symmetric');
    
    [dIx,dIy] = gradient(Is);
    
    J1 = imfilter(dIx.*dIx, Gr, 'symmetric');
    J2 = imfilter(dIx.*dIy, Gr, 'symmetric');
    J3 = imfilter(dIy.*dIy, Gr, 'symmetric');
    
    % 2.1.2
    
    lambda_plus  =  0.5 * (J1 + J3 + sqrt( (J1-J3).*(J1-J3) + 4*J2.*J2 ));
    lambda_minus =  0.5 * (J1 + J3 - sqrt( (J1-J3).*(J1-J3) + 4*J2.*J2 ));
    
    figure('Name', 'ë+');
    imshow(abs(lambda_plus), []);
    figure('Name', 'ë-');
    imshow(abs(lambda_minus), []);
    
    
    % 2.1.3
    
    R = lambda_plus.*lambda_minus - k.*(lambda_plus+lambda_minus).^2;
    
    B_sq = strel('disk', ns);
    Cond1 = (R == imdilate(R, B_sq));
    Cond2 = (R >= theta_corn*max(R));
    
    [xy(:,2),xy(:,1)] = find(Cond1 & Cond2);
    parameters = horzcat(xy, ones(size(xy, 1), 1) * sigma);
    figure('Name', 'Uniscale angle detect');
    interest_points_visualization(I, parameters);
    
    output = parameters;
    
end
    
    
    
    
    
    
    
