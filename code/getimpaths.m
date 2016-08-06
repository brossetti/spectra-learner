function [ filepaths ] = getimpaths( rootdir, ext )
%GETIMPATHS Retrieves full files paths with a define extension in a defined
%diretory
%   Detailed explanation goes here

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

