function filtered = rect_sums(Iint, w_wind, h_wind,shiftX, shiftY)

centerX = ceil(w_wind/2);
centerY = ceil(h_wind/2);

%up left point
sA = circshift(Iint,centerY+shiftY,1);
sA = circshift(sA,centerX+shiftX,2);

%up right point
sB = circshift(Iint,centerY+shiftY,1);
sB = circshift(sB,-(centerX-1)+shiftX,2);

%bottom right point
sC = circshift(Iint,-(centerY-1)+shiftY,1);
sC = circshift(sC,-(centerX-1)+shiftX,2);


%bottom left point
sD = circshift(Iint,-(centerY-1)+shiftY,1);
sD = circshift(sD,centerX+shiftX,2);

filtered = sA - sB + sC - sD;