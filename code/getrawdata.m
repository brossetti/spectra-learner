function [ img, grayimg ] = getrawdata( filepaths )
%GETRAWDATA Imports raw spectral image data for classification
%   getrawdata() is a function in the Spectra Learner pipeline. It takes a 
%   cell array of full file paths corresponding to raw spectral images. The
%   spectral images are loaded, normalizes, and a grayscale version is
%   generated. Images should be TIFF formatted and have a bit depth of
%   uint8 or uint16.
%
%   Example:
%       [ img, grayimg ] = getrawdata( filepaths )
%
%   Compatibility: Written and tested on MATLAB v9.0.0.341360 (2016a)
%
%   Author: Blair Rossetti
%

% set image information
imginfo = imfinfo(filepaths{1});

n = imginfo(1).Width;
m = imginfo(1).Height;
p = length(imginfo);

switch imginfo(1).BitDepth;
    case 8
        bd = 'uint8';
    case 16
        bd = 'uint16';
    otherwise
        bd = 'uint8';
end

% initialize
img = [];
grayimg = zeros(m,n);
n = 0;

for i = 1:length(filepaths)
    % import image stack
    tmp = double(stackread(filepaths{i}));
    
    % add data to running sum
    grayimg = grayimg + sum(tmp, 3);
    n = n + size(tmp, 3);
    
    % normalize stack to max intensity
    tmp = tmp ./ max(tmp(:));
    
    % concatenate
    img = cat(3, img, tmp);
end    

% calculate grayscale image
grayimg = grayimg - min(grayimg(:));
grayimg = cast(grayimg ./ max(grayimg(:)) .* double(intmax(bd)), bd);
    
end