function [ X, Y, classes ] = getrefdata( rootdir, ext, includebg, samplesize, plt )
%GETREFDATA Imports reference image data for training
%   Detailed explanation goes here

switch nargin
    case 0 
        rootdir = fullfile('..', 'references');
        ext = '.tif';
        includebg = true;
        samplesize = 0;
        plt = false;
    case 1
        ext = '.tif';
        includebg = true;
        samplesize = 0;
        plt = false;
    case 2
        includebg = true;
        samplesize = 0;
        plt = false;
    case 3
        samplesize = 0;
        plt = false;
    case 4
        plt = false;
end

% check reference dir
if ~exist(rootdir, 'dir')
    error('Reference directory does not exist.');
end

filepaths = getimpaths(rootdir, ext);

% parse filenames
[~, filenames, ~] = cellfun(@fileparts, filepaths, 'UniformOutput', false);
nameparts = cellfun(@(x) strsplit(x, '_'), filenames, 'UniformOutput', false);
try
    nameparts = vertcat(nameparts{:});
catch
    error('Miscellaneous file found in raw spectral image directory');
end

% find reference names and track names
[classes] = unique(nameparts(:,1), 'stable');
numclasses = length(classes);
[trcknames, trckidx] = unique(nameparts(:,2), 'stable');

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
n = imginfo(1).Width;
m = imginfo(1).Height;
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

if plt
    r = floor(sqrt(numclasses));
    c = ceil(numclasses/r); 
end   

for i = 1:numclasses
    % initialize reference image
    img = zeros(m, n, p);
    
    for j = 1:length(filegrps(i).Path)
        % import image stack
        tmp = double(stackread(filegrps(i).Path{j}));

        % normalize stack to max intensity
        tmp = tmp ./ max(tmp(:));

        % insert track into template
        sidx = ismember(trcknames, nameparts(k,2));
        img(:,:,bandidx(sidx):bandidx(sidx)+size(tmp,3)-1) = tmp;
        k = k + 1;
    end
    
    % generate mask
    if verLessThan('matlab','9.0')
        mask = im2bw(mean(img,3), graythresh(mean(img,3)));
    else
        mask = imbinarize(mean(img,3));
    end
    
    % kmeans also works well for generating the mask
%     [labels,centroids] = kmeans(reshape(img,m*n,p),2);
%     mask = labels == 
    
    
    if includebg
        bgndmask = imerode(~mask, strel('square', round(size(img, 1)/8)));
    end
    
    if plt && includebg
        subplot(r,c,i);
        imshowpair(mask, bgndmask, 'montage');
        title(filegrps(i).Name);
    elseif plt
        subplot(r,c,i);
        imshow(mask);
        title(filegrps(i).Name);
    end
    
    % add predictors and labels
    img = reshape(img, m*n, p);
    
    if includebg
        X = cat(1, X, img(mask(:),:));
        Y = cat(1, Y, ones(sum(mask(:)),1).*i);
        X = cat(1, X, img(bgndmask(:),:));
        Y = cat(1, Y, zeros(sum(bgndmask(:)),1));
    else
        X = cat(1, X, img(mask(:),:));
        Y = cat(1, Y, ones(sum(mask(:)),1).*(i-1));
    end
    
end

% add background class and sort for sampling step
if includebg
    classes = [{'Bgnd'}; classes];
    numclasses = numclasses + 1;
    [Y,idx] = sort(Y, 'ascend');
    X = X(idx,:);
end

% randomly sample a uniform distribution of each class based on samplesize
samplecounts = histcounts(Y);

if samplesize < 1
    samplesize = min(samplecounts);
end

shiftsize = [0 cumsum(samplecounts)];
sampleidx = zeros(samplesize*numclasses,1);
for i = 1:numclasses
    % sample with replacement if sampe size is smaller than the number of
    % samples
    if samplesize > samplecounts(i)
        warning('Samples for %s is less than the defined sample size -- sampling with replacement', classes{i});
        sampleidx((i-1)*samplesize+1:i*samplesize) = randi(samplecounts(i),samplesize,1) + shiftsize(i);
    else
        sampleidx((i-1)*samplesize+1:i*samplesize) = randperm(samplecounts(i),samplesize) + shiftsize(i);
    end
end

X = X(sampleidx,:);
Y = Y(sampleidx,:);

end

