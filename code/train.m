function [ output_args ] = train(rootdir)
%TRAIN Trains the spectral SVM based on the reference spectra
%   Detailed explanation goes here

if nargin == 0
    rootdir = fullfile('..', 'references');
end

% check reference dir
if ~exist(rootdir, 'dir')
    error('Reference directory does not exist.');
end

ext = '.czi';

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
{class, group}  = cellfun(@(x) strsplit(x, '_'), files, 'UniformOutput', false);


end

function [ norm ] = imnorm( img )
%IMNORM Normalizes an image to its maximum value



end