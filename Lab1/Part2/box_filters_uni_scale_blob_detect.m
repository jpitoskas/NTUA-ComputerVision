function output = box_filters_uni_scale_blob_detect(I0,s,print)

    n=2*ceil(3*s)+1;

    if size(I0,3)==3 
        I = rgb2gray(I0);
    else
        I = I0;
    end

    [N,M]= size(I);


    center = ceil(n/2);

    I_padded = padarray(I,[center center]);
    Iint = cumsum(cumsum(I_padded).').';

    %Dxx filter window dimensions
    hDxx = 4*floor(n/6)+1;
    hMarg = (n-hDxx)/2;
    wDxx = 2*floor(n/6)+1;
    cDxx = [ceil(hDxx/2),ceil(wDxx/2)];
    if (3*wDxx < n)
        wDxx =  wDxx+1;
    end


    %Dyy filter window dimensions
    hDyy = 2*floor(n/6)+1;
    wDyy = 2*floor(n/6)+1;
    wMarg = (n-wDyy)/2;
    cDyy = [ceil(hDyy/2),ceil(wDyy/2)];
    if (3*hDyy < n)
        hDyy =  hDyy+1;
    end


    %Dxy filter window dimensions
    hDxy = 2*floor(n/6)+1;
    wDxy = 2*floor(n/6)+1;
    cDxy = [ceil(hDxy/2),ceil(wDxy/2)];
    edgeMarg = floor((n-2*hDxy)/3);
    % Center margin is always odd number
    centMarg = edgeMarg;
    if(2*edgeMarg + centMarg + 2*hDxy ~= n)
        if (2*edgeMarg + centMarg + 2*hDxy + 2 == n)
            edgeMarg = edgeMarg+1;
        else
            centMarg = centMarg + 1;
        end
    end

    % Constructing Lxx
    Lxx_padded = 1*rect_sums(Iint,n,hDxx,0,0);
    Lxx_padded = Lxx_padded -3*rect_sums(Iint,wDxx,hDxx,0,0);
    Lxx = Lxx_padded(center+1:N+center,center+1:M+center);

    % Constructing Lyy
    Lyy_padded = 1*rect_sums(Iint,wDyy,n,0,0);
    Lyy_padded = Lyy_padded - 3*rect_sums(Iint,wDyy,hDyy,0,0);
    Lyy = Lyy_padded(center+1:N+center,center+1:M+center);

    % Constructing Lxy
    mid = ceil(centMarg/2);

    % Up left window
    shiftY = ceil(hDxy/2)+mid-1;
    shiftX = ceil(wDxy/2)+mid-1;
    temp1 = 1*rect_sums(Iint,wDxy,hDxy,shiftX,shiftY);

    % Up right window
    shiftY = ceil(hDxy/2)+mid-1;
    shiftX = -(ceil(wDxy/2)+mid-1);
    temp2 = -1*rect_sums(Iint,wDxy,hDxy,shiftX,shiftY);

    % Bottom right window
    shiftY = -(ceil(hDxy/2)+mid-1);
    shiftX = -(ceil(wDxy/2)+mid-1);
    temp3 = 1*rect_sums(Iint,wDxy,hDxy,shiftX,shiftY);

    % Bottom left window
    shiftY = -(ceil(hDxy/2)+mid-1);
    shiftX = ceil(wDxy/2)+mid-1;
    temp4 = -1*rect_sums(Iint,wDxy,hDxy,shiftX,shiftY);

    Lxy_padded = temp1+ temp2 +temp3 +temp4;
    Lxy = Lxy_padded((center+1):(N+center),(center+1):(M+center));


    R = Lxx.*Lyy - (0.9*Lxy).^2;
    B_sq = strel('disk', n);
    Cond1 = (R == imdilate(R, B_sq));
    theta_corn = 0.005;
    Cond2 = (R > theta_corn*max(max(R)));

    [xy(:,2),xy(:,1)] = find(Cond1 & Cond2);
    parameters = horzcat(xy, ones(size(xy, 1), 1) * s);


    if(print)
        figure('Name', 'Uniscale blob detect with box filters ');
        interest_points_visualization(I0, parameters);
    end

    output = (Cond1 & Cond2);

end

