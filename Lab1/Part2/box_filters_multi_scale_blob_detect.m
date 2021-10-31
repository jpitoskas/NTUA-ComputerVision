function output = box_filters_multi_scale_blob_detect(I0,s0,factor,N)

    theta_corn = 0.01;

    if size(I0,3)==3
        I_gray = rgb2gray(I0);
    else
        I_gray = I0;
    end

    scales = zeros(N,1);
    scales(1)=s0;
    for i=2:N
        scales(i) = factor*scales(i-1);
    end

    AbsLoG = zeros(size(I_gray,1), size(I_gray,2), N);
    for i=1:N
        ns = ceil(3*scales(i))*2+1;
        LoG = fspecial('log', ns, scales(i));
        LoG_I = imfilter(I_gray, LoG, 'symmetric');
        AbsLoG(:,:,i) = scales(i)^2 * abs(LoG_I);
    end

    for i = 1:N
           
        Cond12 = box_filters_uni_scale_blob_detect(I0,scales(i),false);

        % 3rd Condition
        if (i==1) Cond3 = AbsLoG(:,:,i) >= AbsLoG(:,:,i+1) ; 
        elseif(i==N) Cond3= AbsLoG(:,:,i) >= AbsLoG(:,:,i-1); 
        else Cond3 = AbsLoG(:,:,i) >= AbsLoG(:,:,i+1) & AbsLoG(:,:,i) >= AbsLoG(:,:,i-1);
        end

        % Find interest points
        [temp_y,temp_x] = find(Cond12 & Cond3);
        Temp_Parameters = horzcat(temp_x,temp_y, ones(size(temp_x,1),1) * scales(i));

        if i == 1
            Parameters = Temp_Parameters;
        else
            Parameters = cat(1,Temp_Parameters,Parameters);
        end
    end

    figure('Name', 'Multiscale blob detect with box filters');
    interest_points_visualization(I0, Parameters);

    output = Parameters;
end

