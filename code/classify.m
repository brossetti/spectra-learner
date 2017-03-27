function [ stack, rgbimg ] = classify( mdl, bgnd, img, grayimg )
%CLASSIFY Classifies a raw spectral image based on a pre-trained model
%   Detailed explanation goes here

% check input
if nargin < 4
    % convert spectral image to grayscale
    grayimg = cast(mean(img,3), 'uint8');
end

% get image properties
[m,n,p] = size(img);

% generate class predictions
gcp;
paroptions=statset('UseParallel',true);
classes = predict(mdl, reshape(img, m*n, p), 'Options', paroptions);

% generate classified stack
nclasses = numel(mdl.ClassNames);
stack = zeros(m*n, nclasses, class(grayimg));
for i = 1:m*n
    stack(i,classes(i)+1) = grayimg(i); 
end    
stack = reshape(stack, m, n, nclasses);

% generate rgb preview image
if bgnd
    cmap = [1, 1, 1; hsv(nclasses-1)];
else
    cmap = hsv(nclasses);
end
wghts = reshape(cmap(classes+1,:), m, n, 3);
rgbimg = repmat(double(grayimg), 1, 1, 3) .* wghts;
rgbimg = rgbimg ./ max(rgbimg(:)) .* 255;
rgbimg = cast(rgbimg, 'uint8');
end

