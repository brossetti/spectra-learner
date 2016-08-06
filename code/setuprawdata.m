function [ filegrps ] = setuprawdata( rootdir )
%SETUPRAWDATA Searches files in raw spectral image directory for groups
%   Detailed explanation goes here

if nargin == 0
    rootdir = fullfile('..', 'raw');
end

% check reference dir
if ~exist(rootdir, 'dir')
    error('Raw spectral image directory does not exist.');
end

% get list of files
filepaths = getimpaths(rootdir);

% parse filenames
[~, filenames, ~] = cellfun(@fileparts, filepaths, 'UniformOutput', false);
nameparts = cellfun(@(x) strsplit(x, '_'), filenames, 'UniformOutput', false);
try
    nameparts = vertcat(nameparts{:});
catch
    error('Miscellaneous file found in raw spectral image directory');
end

% find group names
grpnames = unique(nameparts(:,1));

% create array of filepaths by groups
filegrps = struct([]);
for i = 1:length(grpnames)
    grpidx = ismember(nameparts(:,1), grpnames{i});
    filegrps(i).Path = filepaths(grpidx);
    filegrps(i).Name = grpnames{i};
end

end

