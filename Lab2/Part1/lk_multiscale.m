function [d_x,d_y] = lk_multiscale(I1,I2,rho,epsilon,scales)
    
    I1 = im2double(I1);
    I2 = im2double(I2);
    
    % At first, we make a Gaussian in order to filter the image.
    n = 2*ceil(3*rho) + 1;
    Gp = fspecial('gaussian',[n n],rho);
    
    Reduced_Images1 = {};
    Reduced_Images2 = {};
    Reduced_Images1{1} = I1;
    Reduced_Images2{1} = I2;
     
    for i=1:scales-1
        I_filtered = imfilter(Reduced_Images1{i},Gp,'symmetric');
        I_reduced =  impyramid(I_filtered,'reduce');
        Reduced_Images1{i+1} = I_reduced;
        
        I_filtered = imfilter(Reduced_Images2{i},Gp,'symmetric');
        I_reduced =  impyramid(I_filtered,'reduce');
        Reduced_Images2{i+1} = I_reduced;
        
    end

    d_x0 = 0.*Reduced_Images1{scales};
    d_y0 = 0.*Reduced_Images1{scales};
    
    % We now apply the Lucas-Kanade algorithm while we also modify our
    % marameters and input images.
    % The first scale has been set to 1. (lk like in Part2)
        for i = scales:-1:1
          
            [d_x_r, d_y_r] = lk(Reduced_Images1{i},Reduced_Images2{i},rho,epsilon,d_x0,d_y0);
            
            if(i==1)
                break
            end

            d_x0 = 2 * imresize(d_x_r,size(Reduced_Images1{i-1}));
            d_y0 = 2 * imresize(d_y_r,size(Reduced_Images1{i-1}));
                
        end
        
        d_x = d_x_r;
        d_y = d_y_r;
end
