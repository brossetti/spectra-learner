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

ext = '.tif';

files = dir(fullfile(rootdir, ['*' ext]));
dirIdx = [files.isdir];
files = {files(~dirIdx).name}';
numFiles = length(files);

% build full file path
filepaths = cell(1,numFiles);
for i = 1:numFiles
    filepaths{i} = fullfile(rootdir,files{i});
    [~, files{i}, ~] = fileparts(files{i});
end

% group files by class
{class, group} = cellfun(@(x) strsplit(x, '_'), files, 'UniformOutput', false);

%%
% get files

rootdir = fullfile('..', 'references');
ext = '.tif';

files = dir(fullfile(rootdir, ['*' ext]));
dirIdx = [files.isdir];
files = {files(~dirIdx).name}';
numFiles = length(files);


filepaths = cell(1,numFiles);
for i = 1:numFiles
    filepaths{i} = fullfile(rootdir,files{i});
    
    imginfo = imfinfo(filepaths{i});
    m = round(imginfo(1).Width/2);
    n = round(imginfo(1).Height/2);
    nslices = length(imginfo);
    img{i} = zeros(m,n,nslices,'uint16');

    for j=1:nslices
       img{i}(:,:,j) = imresize(imread(filepaths{i},'Index',j,'Info',imginfo), [m,n]);
    end

end
 
% normalize each file and group

for i = 1:length(img)
    img{i} = double(img{i})./max(max(max(double(img{i}))))*255;
end

at633 = cat(3, zeros(m,n,23+20+15), img{1}, img{2});
at647n = cat(3, zeros(m,n,23+20+15), img{3}, img{4});
b = cat(3, img{5}, img{6}, zeros(m,n,15+11+7));
f = cat(3, zeros(m,n,23), img{7}, img{8}, img{9}, zeros(m,n,7));
gamma = cat(3, zeros(m,n,23+20), img{10}, img{11}, zeros(m,n,7));
h = cat(3, img{12}, img{13}, img{14}, zeros(m,n,11+7));
r = cat(3, img{15}, img{16}, img{17}, zeros(m,n,11+7));

img = {b, r, h, f, gamma, at633, at647n};

% threshold

mask = cell(length(img));
for i = 1:length(img)
    mask{i} = imbinarize(var(img{i},0,3));
end

% concatenate into predicators and classes
x=[];
y=[];
for i = 1:length(img)
    tmp = reshape(img{i}, m*n, size(img{i},3));
    obj = mask{i}(:);
    bgndmask = imerode(~mask{i}, strel('square', 50));
    bgnd = bgndmask(:);
    x = cat(1, x, tmp(obj,:));
    x = cat(1, x, tmp(bgnd,:));
    
    y = cat(1, y, ones(sum(obj),1).*i);
    y = cat(1, y, zeros(sum(bgnd),1));
end  
end

