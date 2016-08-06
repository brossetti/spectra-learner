function [ img, grayimg ] = getrawdata( filepaths )
%GETRAWDATA Imports raw spectral image data for classification
%   Detailed explanation goes here


% set image information
imginfo = imfinfo(filepaths{1});
switch imginfo(1).BitDepth;
    case 8
        bd = 'uint8';
    case 16
        bd = 'uint16';
    otherwise
        bd = 'uint8';
end
m = imginfo(1).Width;
n = imginfo(1).Height;
p = length(imginfo);

% initialize
img = zeros(m,n,p);
grayimg = zeros(m,n);
n = 0;

for i = 1:length(filepaths)
    % import image stack
    tmp = double(stackread(filepaths{i}));
    
    % add data to running sum
    grayimg = grayimg + sum(tmp, 3);
    n = n + size(tmp, 3);
    
    % normalize stack to max intensity
    tmp = tmp ./ max(tmp(:)) .* double(intmax(bd));
    
    % concatenate
    img = cat(3, img, tmp);
end    
img = cast(img, bd);

% calculate grayscale image
grayimg = cast(grayimg ./ n, bd);
    
end