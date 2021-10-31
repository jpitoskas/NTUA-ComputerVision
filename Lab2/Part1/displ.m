function [displ_x, displ_y] = displ(d_x, d_y)
    
    energy = d_x .^2 + d_y .^ 2;
    
    energy = energy(:);
    
    d_x = d_x(:);
    d_y = d_y(:);
    
    max_energy = max(energy);
    threshold = 0.5 * max_energy;
    
    sum_d_x = sum(d_x(energy>threshold));
    sum_d_y = sum(d_y(energy>threshold));
    
    count_energy = sum(energy>threshold);
    
    displ_x = round(sum_d_x/count_energy);
    displ_y = round(sum_d_y/count_energy);
    
    x=1;


        
end