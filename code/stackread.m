function [ img ] = stackread( filename )
%STACKREAD Reads a multipage TIFF file
%   Detailed explanation goes here

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

