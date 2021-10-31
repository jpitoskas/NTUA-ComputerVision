function output = multi_scale_blob_detect(I)
    
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
    
    sigmas = zeros(N,1);
    sigmas(1) = sigma;
    
    for i = 2:N
        sigmas(i) = s * sigmas(i-1);
    end
    
%     sigmas = zeros(N,1);    
%     for i = 2:N
%         if (i == 1); sigmas(i) = sigma; else; sigmas(i) = s * sigmas(i-1); end
%     end

    
    % Laplacian
    AbsLoG = zeros(size(I_gray,1), size(I_gray,2), N);
    for i=1:N
        ns = ceil(3*sigmas(i))*2+1;
        LoG = fspecial('log', ns, sigmas(i));
        LoG_I = imfilter(I_gray, LoG, 'symmetric');
        AbsLoG(:,:,i) = sigmas(i)^2 * abs(LoG_I);
    end
    
    
    for i = 1:N     
        ns = 2*ceil(3*sigmas(i)) + 1;
        Gs = fspecial('gaussian', ns, sigmas(i));
        Is = imfilter(I_gray, Gs, 'symmetric');
        
        [Lx,Ly] = gradient(Is);
        [Lxx, Lxy] = gradient(Lx);
        [Lyx, Lyy] = gradient(Ly);
        
        % for given ó: R(x,y)=det(H(x,y)) => R(x,y)=?H(x,y)?
        R = Lxx.*Lyy - Lxy.*Lyx;    
   
        
        % 1st Condition
        B_sq = strel('disk', ns);
        Cond1 = (R==imdilate(R,B_sq));
        
        % 2nd Condition
        Rmax = max(max(R));
        Cond2 = (R >= theta_corn*Rmax);
        
        % 3rd Condition
        if (i==1) Cond3 = AbsLoG(:,:,i) >= AbsLoG(:,:,i+1) ; 
        elseif (i==N) Cond3= AbsLoG(:,:,i) >= AbsLoG(:,:,i-1); 
        else Cond3 = AbsLoG(:,:,i) >= AbsLoG(:,:,i+1) & AbsLoG(:,:,i) >= AbsLoG(:,:,i-1);
        end
        
        % Find interest points
        [temp_y,temp_x] = find(Cond1 & Cond2 & Cond3);
        Temp_Parameters = horzcat(temp_x,temp_y, ones(size(temp_x,1),1) * sigmas(i));
        
        if i == 1
            Parameters = Temp_Parameters;
        else
            Parameters = cat(1,Temp_Parameters,Parameters);
        end
    end
        
    figure('Name', 'Multiscale blob detect');
    interest_points_visualization(I, Parameters);
    
    output = Parameters;
    
end

    




    
    
    