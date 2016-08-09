function spectralearner( rawdir, refdir, outdir )
%SPRECTRALEARNER Main function for spectra learner toolbox
%   Detailed explanation goes here

% check input
if nargin == 0
    rawdir = fullfile('..', 'raw');
    refdir = fullfile('..', 'references');
    outdir = fullfile('..', 'output');
elseif nargin == 1
    refdir = fullfile('..', 'references');
    outdir = fullfile('..', 'output');
elseif nargin == 2
    outdir = fullfile('..', 'output');
end
    
% load model or generate model
if exist(fullfile(refdir, 'model.mat'), 'file')
    load(fullfile(refdir, 'model.mat'));
else 
    [X, Y, classes] = getrefdata(refdir);
    mdl =  train(X,Y);
    save(fullfile(refdir, 'model.mat'), 'mdl', '-v7.3');
end

% import raw data
filegrps = setuprawdata(rawdir);

% process raw data
for i = 1:size(filegrps, 2)
    % get raw data
    [img, grayimg] = getrawdata(filegrps(i).Path);
    
    % check dimensions
    if size(img, 3) ~= numel(mdl.PredictorNames)
        error('Number of spectral bands in reference does not match the number of bands in the raw spectral image');
    end
    
    % classify raw image
    [stack, rgbimg] = classify(mdl, img, grayimg);
    
    % save processed data
    stackwrite(stack, fullfile(outdir, [filegrps(i).Name '_stack.tif']));
    imwrite(rgbimg, fullfile(outdir, [filegrps(i).Name '_color.jpg']));
end

end

