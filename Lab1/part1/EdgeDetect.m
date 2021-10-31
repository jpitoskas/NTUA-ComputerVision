function [D] = EdgeDetect(I,sigma, thetaEdge, LaplaceType)

n = ceil(3*sigma)*2 + 1;
Gaussian = fspecial('gaussian',n,sigma);
LoGaussian = fspecial('log',n,sigma);
Is = imfilter(I, Gaussian);
figure(8)
imshow(Is)

B=strel('disk',1);
if (LaplaceType == 1)
    L = imfilter(I,LoGaussian);
else
    
    L = imdilate(Is,B)+imerode(Is,B)-2*Is;
end

%Zero crossing rate algorithm
X = (L>=0);
Y = imdilate(X,B)-imerode(X,B);

%Edge detection
[fx, fy] = gradient(Is);
normaGradIs = sqrt(fx.^2 + fy.^2);
maxGradIs = max(max(normaGradIs));
D = ((Y == 1) & (normaGradIs > thetaEdge * maxGradIs));



end

