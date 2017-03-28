function [ filegrps ] = setuprawdata( rootdir, ext )
%SETUPRAWDATA Searches files in raw spectral image directory for groups
%   setuprawdata() is a function in the Spectra Learner pipeline. It takes 
%   a root directory and a file extension, and returns an array structure
%   containing the name and path of all raw data groups (each group is a
%   separate entry in the array. This function is used to handle sequential
%   spectral images, and require that the user abide by the file naming
%   scheme in README.md.
%
%   Example:
%       [ filegrps ] = setuprawdata( rootdir, ext )
%
%   Compatibility: Written and tested on MATLAB v9.0.0.341360 (2016a)
%
%   Author: Blair Rossetti
%

if nargin == 0
    rootdir = fullfile('..', 'raw');
end

% check reference dir
if ~exist(rootdir, 'dir')
    error('Raw spectral image directory does not exist.');
end

% get list of files
filepaths = getimpaths(rootdir, ext);

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

