function [ filepaths ] = getimpaths( rootdir, ext )
%GETIMPATHS Retrieves full files for all images in rootdir ending with ext
%   getimpaths() is a function for retrieving all filenames in a root
%   directory of a given extension. This function does not recursively
%   travel the directory tree.
%
%   Example:
%       [ filepaths ] = getimpaths( rootdir, '.tif' )
%
%   Compatibility: Written and tested on MATLAB v9.0.0.341360 (2016a)
%
%   Author: Blair Rossetti
%

% chec input
if nargin < 2
    ext = '.tif';
end

files = dir(fullfile(rootdir, ['*' ext]));
dirIdx = [files.isdir];
files = {files(~dirIdx).name}';
nfiles = length(files);

% build full file path
filepaths = cell(1,nfiles);
for i = 1:nfiles
    filepaths{i} = fullfile(rootdir,files{i});
end

end

