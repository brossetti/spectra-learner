function [ filepaths ] = getimpaths( rootdir, ext )
%GETIMPATHS Retrieves full paths for all files in rootdir ending with ext
%   getimpaths() is a function for retrieving all paths in a root
%   directory with a given extension. This function does not recursively
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

