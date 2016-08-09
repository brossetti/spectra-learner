%test
clear all

%% get files

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
    m = round(imginfo(1).Width);
    n = round(imginfo(1).Height);
    nslices = length(imginfo);
    img{i} = zeros(m,n,nslices,'uint16');

    for j=1:nslices
%        img{i}(:,:,j) = imresize(imread(filepaths{i},'Index',j,'Info',imginfo), [m,n]);
       img{i}(:,:,j) = imread(filepaths{i},'Index',j,'Info',imginfo);
    end

end
 
%% normalize each file and group

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

%% threshold

mask = cell(length(img));
for i = 1:length(img)
    mask{i} = imbinarize(var(img{i},0,3));
end

%% concatenate into predicators and classes
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

%% randomly select predictors for training
idx = randperm(size(x,1)); 
trainidx = idx(1:round(2*size(x,1)/3));
testidx = idx(length(trainidx)+1:end);

%% train model
gcp;
tic
paroptions=statset('UseParallel',true);
Mdl = fitcecoc(x(trainidx,:),y(trainidx), 'Options', paroptions);
% tTree = templateTree('surrogate','all');
% tEnsemble = templateEnsemble('AdaBoostM2', 100, tTree);
% Mdl = fitcecoc(x(trainidx,:),y(trainidx), 'Coding', 'onevsall', 'Learner', tEnsemble,...
%     'Prior', 'uniform', 'Options', paroptions);
% Mdl = fitensemble(x,categorical(y), 'AdaboostM2', 100, tTree,...
%     'Prior', 'uniform');
toc
save(fullfile(rootdir, 'model.mat'), 'Mdl', '-v7.3');

%% check model with test set
predclass = predict(Mdl, x(testidx,:));
confMat = confusionmat(y(testidx), predclass);

%% open raw image files

rootdir = fullfile('..', 'raw');
ext = '.tif';

files = dir(fullfile(rootdir, ['*' ext]));
dirIdx = [files.isdir];
files = {files(~dirIdx).name}';
numFiles = length(files);


filepaths = cell(1,numFiles);
for i = 1:numFiles
    filepaths{i} = fullfile(rootdir,files{i});
    
    imginfo = imfinfo(filepaths{i});
    m = imginfo(1).Width;
    n = imginfo(1).Height;
    nslices = length(imginfo);
    img{i} = zeros(m,n,nslices,'uint16');

    for j=1:nslices
       img{i}(:,:,j) = imread(filepaths{i},'Index',j,'Info',imginfo);
    end
end

%% normalize raw files

for i = 1:length(img)
    img{i} = double(img{i})./max(max(max(double(img{i}))))*255;
end

%% concatenate raw files

img = cat(3, img{1},img{2},img{3},img{4},img{5});

%% get predictions
toc
classes = predict(Mdl, reshape(img, m*n, size(img,3)));
toc
%% create output file
img = reshape(img, m*n,size(img,3));
imgval = mean(img,2);
result = zeros(m*n,8);
for i = 1:m*n
    result(i,classes(i)+1) = imgval(i); 
end    

result = uint8(mat2gray(reshape(result, m, n, 8)).*255);

%% write output file

imwrite(result(:,:,1), fullfile(rootdir, 'classified.tif'));
for i = 2:7
    imwrite(result(:,:,i), fullfile(rootdir, 'classified.tif'), 'writemode', 'append')
end
