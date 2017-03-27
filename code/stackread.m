function [ img ] = stackread( filename )
%STACKREAD Reads a multipage TIFF file
%   stackread() is a function for reading a multipage TIFF file into a 3D 
%   tensor, img, of type uint8 or uint16.
%
%   Example:
%       [ img ] = stackread( filename )
%
%   Compatibility: Written and tested on MATLAB v9.0.0.341360 (2016a)
%
%   Author: Blair Rossetti
%

imginfo = imfinfo(filename);

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

img = zeros(m,n,p,bd);

for i=1:p
   img(:,:,i) = imread(filename,'Index',i,'Info',imginfo);
end

end

