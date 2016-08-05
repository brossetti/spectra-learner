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
    [X, Y, classes] = getreddata(refdir);
    mdl =  train(X,Y);
    save(fullfile(refdir, 'model.mat'), 'mdl', '-v7.3');
end

% import raw data
[imgs, names] = getrawdata(rawdir);

% process raw data
for i = 1:length(imgs)
    % classify raw image
    [stack, clrimg] = classify(mdl, imgs{i});
    
    % save processed data
    stackwrite(stack, fullfile(outdir, [names{i} '_stack.tif']));
    imwrite(clrimg, fullfile(outdir, [names{i} '_color.tif']));
end

end

