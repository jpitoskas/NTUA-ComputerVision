function [R] = box_filters_uni_easy(I0,s)

    % Iint = integralImage(I);
    
    n=2*ceil(3*s)+1;

    if size(I0,3)==3
        I = rgb2gray(I0);
    else
        I = I0;
    end

    Ipadded = padarray(I,[floor(n/2) floor(n/2)], 'replicate');
    Iint = integralImage(Ipadded);

    hDxx = 4*floor(n/6)+1;
    vertMarg = (n-hDxx)/2;
    wDxx = 2*floor(n/6)+1;
    Dxx = integralKernel([1 1 n n; 1 (vertMarg+1) wDxx hDxx; (wDxx+1) (vertMarg+1) wDxx hDxx; (2*wDxx+1) (vertMarg+1) wDxx hDxx], [0 1 -2 1]);
    Lxx = integralFilter(Iint, Dxx);

    hDyy = 2*floor(n/6)+1;
    wDyy = 2*floor(n/6)+1;
    horMarg = (n-wDyy)/2;
    Dyy = integralKernel([1 1 n n; (horMarg+1) 1 wDyy hDyy; (horMarg+1) (hDyy+1) wDyy hDyy; (horMarg+1) (2*hDyy+1) wDyy hDyy], [0 1 -2 1]); 
    Lyy = integralFilter(Iint, Dyy);

    hDxy = 2*floor(n/6)+1;
    wDxy = 2*floor(n/6)+1;
    edgeMarg = floor((n-2*hDxy)/3);
    if(3*edgeMarg+ 2*hDxy == n)
        centMarg = edgeMarg;
    else
        centMarg = edgeMarg +1;
    end
    Dxy = integralKernel([1 1 n n; (edgeMarg+1) (edgeMarg+1) wDxy hDxy; (edgeMarg+centMarg+wDxy+1) (edgeMarg+1) wDxy hDxy; (edgeMarg+1) (edgeMarg+centMarg+hDxy+1) wDxy hDxy; (edgeMarg+centMarg+wDxy+1) (edgeMarg+centMarg+hDxy+1) wDxy hDxy], [0 1 -1 -1 1]);
    Lxy = integralFilter(Iint,Dxy);

    R = Lxx.*Lyy - (0.912*Lxy).^2;
    figure('Name','easy');

end



