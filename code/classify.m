function [ stack, clrimg ] = classify( mdl, img )
%CLASSIFY Classifies a raw spectral image based on a pre-trained model
%   Detailed explanation goes here

% get image properties
[m,n,p] = size(img);

% generate class predictions
classes = predict(mdl, reshape(img, m*n, p));

% generate stack
classimg = reshape(classes, m*n, size(classes,2));
imgval = mean(img,2);
result = zeros(m*n,8);
for i = 1:m*n
    result(i,classes(i)+1) = imgval(i); 
end    

result = uint8(mat2gray(reshape(result, m, n, 8)).*255);

% generate colored preview image


end

