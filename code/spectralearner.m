function spectralearner( rawdir, refdir, outdir )
%SPRECTRALEARNER Main function for spectra learner toolbox
%   Detailed explanation goes here

% set parameters
ext = '.tif';        % spectral image file extension (only supports tiff)
includebgnd = true;  % include the background as a class
samplesize = 0;      % reference sample size for each class (0 = minimum class size)
plt = true;          % display segmentation images and plots

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
    disp('Loading saved model...');
    load(fullfile(refdir, 'model.mat'));
    confTable = readtable(fullfile(refdir, 'confusion_matrix.csv'),'ReadRowNames', true);
    disp(confTable);
else 
    disp('Assembling reference data...');
    [X, Y, classes] = getrefdata(refdir, ext, includebgnd, samplesize, plt);
    disp('Training model...');
    [mdl, confMat] = train(X,Y);
    confTable = array2table(confMat,'RowNames', classes,'VariableNames', classes);
    disp(confTable);
    disp('Saving model...');
    save(fullfile(refdir, 'model.mat'), 'mdl', '-v7.3');
    writetable(confTable, fullfile(refdir, 'confusion_matrix.csv'), 'WriteRowNames', true);
end

% import raw data
filegrps = setuprawdata(rawdir);

% process raw data
for i = 1:size(filegrps, 2)
    fprintf('Image %i:\n',i);
    % get raw data
    disp('    Assembling raw data...');
    [img, grayimg] = getrawdata(filegrps(i).Path);
    
    % check dimensions
    if size(img, 3) ~= numel(mdl.PredictorNames)
        error('    Number of spectral bands in reference does not match the number of bands in the raw spectral image');
    end
    
    % classify raw image
    disp('    Predicting classes...');
    [stack, rgbimg] = classify(mdl, includebgnd, img, grayimg);
    
    % save processed data
    disp('    Saving results...');
    stackwrite(stack, fullfile(outdir, [filegrps(i).Name '_stack.tif']));
    imwrite(rgbimg, fullfile(outdir, [filegrps(i).Name '_color.jpg']));
end

end

