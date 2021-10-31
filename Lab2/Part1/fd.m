function [x, y, width, height] = fd(I, mu, cov)
    
    figure;
    imshow(I);
    B = strel('disk',2);
    I = imopen(I,B);
    
    figure;
    imshow(I);
    
    B = strel('disk',30);
    I = imclose(I,B);
    
    I = bwlabel(I);   
    figure;
    imshow(I);
    
    areas = regionprops(I,'Area');
    areas_sizes = struct2array(areas);
    max_area = find(areas_sizes == max(areas_sizes));
    I = (I == max_area);
        
    
    face = regionprops(I,'BoundingBox');
    temp = face.BoundingBox;
    x = floor(temp(1));
    y = floor(temp(2));
    width = temp(3);
    height = temp(4);
    
    
end