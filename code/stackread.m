function [ img ] = stackread( filename )
%STACKREAD Reads a multipage TIFF file
%   Detailed explanation goes here

imginfo = imfinfo(filename);
m = imginfo(1).Width;
n = imginfo(1).Height;
nslices = length(imginfo);
img = zeros(m,n,nslices,'uint16');

for i=1:nslices
   img(:,:,i) = imread(filename,'Index',i,'Info',imginfo);
end

end

