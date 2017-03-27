function stackwrite( img, filename )
%STACKWRITE Write a multipage TIFF image
%   stackwrite() is a function for writing a 3D tensor, img, as a multipage
%   TIFF file. The input image should be of type uint8 or uint16.
%
%   Example:
%       stackwrite( img, filename )
%
%   Compatibility: Written and tested on MATLAB v9.0.0.341360 (2016a)
%
%   Author: Blair Rossetti
%

imwrite(img(:,:,1), filename);
for i = 2:size(img,3)
    imwrite(img(:,:,i), filename, 'writemode', 'append');
end

end

