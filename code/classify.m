function [ stack, rgbimg ] = classify( mdl, img, grayimg )
%CLASSIFY Classifies a raw spectral image based on a pre-trained model
%   Detailed explanation goes here

% check input
if nargin < 3
    % convert spectral image to grayscale
    grayimg = cast(mean(img,3), 'uint8');
end

% get image properties
[m,n,p] = size(img);

% generate class predictions
classes = predict(mdl, reshape(img, m*n, p));

% generate classified stack
nclasses = numel(mdl.ClassNames);
stack = zeros(m*n, nclasses, class(grayimg));
for i = 1:m*n
    stack(i,classes(i)+1) = grayimg(i); 
end    
stack = reshape(stack, m, n, nclasses);

% generate rgb preview image
cmap = [1, 1, 1; hsv(nclasses-1)];
wghts = reshape(cmap(classes+1,:), m, n, 3);
rgbimg = repmat(double(grayimg), 1, 1, 3) .* wghts;
rgbimg = cast(rgbimg, 'like', grayimg);
end

