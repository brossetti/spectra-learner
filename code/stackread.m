function [ img ] = stackread( filename )
%STACKREAD Reads a multipage TIFF file
%   Detailed explanation goes here

imginfo = imfinfo(filename);
m = imginfo(1).Width;
n = imginfo(1).Height;
nslices = length(imginfo);
switch imginfo(1).BitDepth;
    case 8
        bd = 'uint8';
    case 16
        bd = 'uint16';
    otherwise
        bd = 'uint8';
end
img = zeros(m,n,nslices,bd);

for i=1:nslices
   img(:,:,i) = imread(filename,'Index',i,'Info',imginfo);
end

end

