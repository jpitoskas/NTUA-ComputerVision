function output = multi_scale_angle_detect(I)

    % 2.2
    
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
    
    % 2.2.1
    
    sigmas = zeros(N,1);
    sigmas(1) = sigma;
    
    rs = zeros(N,1);
    rs(1) = r;
    
    for i = 2:N
        sigmas(i) = s * sigmas(i-1);
        rs(i) = s * rs(i-1);
    end
    
    AbsLoG = zeros(size(I_gray,1), size(I_gray,2), N);
    % Laplacian
    for i=1:N
        ns = ceil(3*sigmas(i))*2+1;
        LoG = fspecial('log', ns, sigmas(i));
        LoG_I = imfilter(I_gray, LoG, 'symmetric');
        AbsLoG(:,:,i) = sigmas(i)^2 * abs(LoG_I);
    end
    
    for i=1:N
        
        ns = 2*ceil(3*sigmas(i)) + 1;
        nr = 2*ceil(3*rs(i)) + 1;
        Gs = fspecial('gaussian', ns, sigmas(i));
        Gr = fspecial('gaussian', nr, rs(i));

        Is = imfilter(I_gray, Gs, 'symmetric');

        [dIx,dIy] = gradient(Is);

        J1 = imfilter(dIx.*dIx, Gr, 'symmetric');
        J2 = imfilter(dIx.*dIy, Gr, 'symmetric');
        J3 = imfilter(dIy.*dIy, Gr, 'symmetric');

        lambda_plus  =  0.5 * (J1 + J3 + sqrt( (J1-J3).*(J1-J3) + 4*J2.*J2 ));
        lambda_minus =  0.5 * (J1 + J3 - sqrt( (J1-J3).*(J1-J3) + 4*J2.*J2 ));

    %     figure('Name', 'ë+');
    %     imshow(abs(lambda_plus), []);
    %     figure('Name', 'ë-');
    %     imshow(abs(lambda_minus), []);

        R = lambda_plus.*lambda_minus - k.*(lambda_plus+lambda_minus).^2;
        
        % 1st Condition
        B_sq = strel('disk', ns);
        Cond1 = (R == imdilate(R, B_sq));
        % 2nd Condition
        Rmax = max(max(R));
        Cond2 = (R > theta_corn*Rmax);   
        
        %3rd Condition
        if (i==1)     
            Cond3 = AbsLoG(:,:,i) >= AbsLoG(:,:,i+1) ; 
        elseif(i==N) 
            Cond3= AbsLoG(:,:,i) >= AbsLoG(:,:,i-1); 
        else
            Cond3 = AbsLoG(:,:,i) >= AbsLoG(:,:,i+1) & AbsLoG(:,:,i) >= AbsLoG(:,:,i-1);
        end
        
        [temp_y,temp_x] = find(Cond1 & Cond2 & Cond3);
        Temp_Parameters = horzcat(temp_x,temp_y, ones(size(temp_x,1),1) * sigmas(i));
        
        if i == 1
            Parameters = Temp_Parameters;
        else
            Parameters = cat(1,Temp_Parameters,Parameters);
        end      
    end
    
    
    figure('Name', 'Multiscale Angle Detect');
    interest_points_visualization(I, Parameters);
    
    output = Parameters;
    
        
end
    
    
    
    
    
    
    
    
    