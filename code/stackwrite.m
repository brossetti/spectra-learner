function stackwrite( img, filename )
%STACKWRITE Write a multipage TIFF image
%   Detailed explanation goes here

imwrite(img(:,:,1), filename);
for i = 2:size(img,3)
    imwrite(img(:,:,i), filename, 'writemode', 'append');
end

end

