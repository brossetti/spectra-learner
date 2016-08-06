function [ X, Y, classes ] = getrefdata( rootdir )
%GETREFDATA Imports reference image data for training
%   Detailed explanation goes here

if nargin == 0
    rootdir = fullfile('..', 'references');
end

% check reference dir
if ~exist(rootdir, 'dir')
    error('Reference directory does not exist.');
end

filepaths = getimpaths(rootdir);

% parse filenames
[~, filenames, ~] = cellfun(@fileparts, filepaths, 'UniformOutput', false);
nameparts = cellfun(@(x) strsplit(x, '_'), filenames, 'UniformOutput', false);
try
    nameparts = vertcat(nameparts{:});
catch
    error('Miscellaneous file found in raw spectral image directory');
end

% find reference names and track names
[classes] = unique(nameparts(:,1));
[trcknames, trckidx] = unique(nameparts(:,2));

% determine number of bands in each track
[~, idx] = sort(trcknames);
trcknames = trcknames(idx);
trckidx = trckidx(idx);
bands = zeros(1,length(trcknames));
for i = 1:length(trcknames)
    imginfo = imfinfo(filepaths{trckidx(i)});
    bands(i) = length(imginfo);
end
bandidx = [1 cumsum(bands)+1];
bandidx = bandidx(1:end-1);

% set image properties
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
p = sum(bands);

% create array of filepaths by reference
filegrps = struct([]);
for i = 1:length(classes)
    grpidx = ismember(nameparts(:,1), classes{i});
    filegrps(i).Path = filepaths(grpidx);
    filegrps(i).Name = classes{i};
end

% import reference images by group
X = [];
Y = [];
k = 1;
for i = 1:length(filegrps)
    % initialize reference image
    img = zeros(m, n, p);
    
    for j = 1:length(filegrps(i).Path)
        % import image stack
        tmp = double(stackread(filegrps(i).Path{j}));

        % normalize stack to max intensity
        tmp = tmp ./ max(tmp(:)) .* double(intmax(bd)) ;

        % insert track into template
        sidx = ismember(trcknames, nameparts(k,2));
        img(:,:,bandidx(sidx):bandidx(sidx)+size(tmp,3)-1) = tmp;
        k = k + 1;
    end
    
    % generate mask
    mask = imbinarize(mat2gray(var(img,0,3)));
    bgndmask = imerode(~mask, strel('square', 50));
    
    % add predictors and labels
    img = round(reshape(img, m*n, p));
    X = cat(1, X, img(mask(:),:));
    X = cat(1, X, img(bgndmask(:),:));
    
    Y = cat(1, Y, ones(sum(mask(:)),1).*i);
    Y = cat(1, Y, zeros(sum(bgndmask(:)),1));
end


end

