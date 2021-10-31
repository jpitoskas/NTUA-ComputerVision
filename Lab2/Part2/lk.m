function [d_x,d_y] = lk(I1, I2, rho, epsilon, d_x0, d_y0)
    
%   Gaussian
    n = 2 * ceil(3 * rho) + 1;
    Gp = fspecial('gaussian',[n n],rho);
    
%   Normalize input frames
    I1 = im2double(I1);
    I2 = im2double(I2);
    
%   Initializations
    [x_0,y_0] = meshgrid(1:size(I1,2),1:size(I1,1));
    d_xi = d_x0;
    d_yi = d_y0;
    
    for i=1:10
        
        I1_interpolated = interp2(I1,x_0+d_xi,y_0+d_yi,'linear',0);

        [dI1x,dI1y] = gradient(I1);
        A1 = interp2(dI1x,x_0+d_xi,y_0+d_yi,'linear',0);
        A2 = interp2(dI1y,x_0+d_xi,y_0+d_yi,'linear',0);

        E = I2 - I1_interpolated;

        a11 = imfilter(A1.^2,Gp,'symmetric') + epsilon;
        a12 = imfilter(A1.*A2,Gp,'symmetric');
        a22 = imfilter(A2.^2,Gp,'symmetric') + epsilon;
        det_a = a11.*a22 - a12.^2;

        b1 = imfilter(A1.*E,Gp,'symmetric');
        b2 = imfilter(A2.*E,Gp,'symmetric');

        u_x = (a22.*b1 - a12.*b2)./det_a;
        u_y = (a11.*b2 - a12.*b1)./det_a;

        d_xi = d_xi + u_x;
        d_yi = d_yi + u_y;
        
    end
    
    
    [d_x,d_y] = deal(d_xi,d_yi);
    
end

