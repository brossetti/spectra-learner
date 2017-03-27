function [ mdl, confMat ] = train( X, Y )
%TRAIN Trains the spectral SVM based on the reference spectra
%   train() is a function in the Spectra Learner pipeline. It takes a matrix
%   of predictors, X, and a vector of class labels, Y. X is a p by q 
%   matrix, where p is the number of pixels and q is the number of spectral
%   bands, and Y is a p by 1 vector. A random selection of 0.75 of the data
%   is used to train a gaussian SVM. The trained model applied to the
%   remaining 0.25 of the data to create a confusion matrix. The confusion
%   matrix gives an idea of how well the model classifies correctly. The
%   resulting model and confusion matrix are returned.
%
%   Example:
%       [ mdl, confMat ] = train( X, Y)
%
%   Compatibility: Written and tested on MATLAB v9.0.0.341360 (2016a)
%   Required Toolboxes: Statistics and Machine Learning and Parallel 
%                       Computing
%
%   Author: Blair Rossetti
%

% randomly select 75% of predictors for training
idx = randperm(size(X,1)); 
trainidx = idx(1:round(3*size(X,1)/4));
testidx = idx(length(trainidx)+1:end);

% train model
gcp;
paroptions=statset('UseParallel',true);
t = templateSVM('KernelFunction', 'gaussian');
mdl = fitcecoc(X(trainidx,:),Y(trainidx), 'Learner', t, ...
    'Prior', 'uniform', 'FitPosterior', false, 'Options', paroptions);

% check model with test set
predclass = predict(mdl, X(testidx,:));
confMat = confusionmat(Y(testidx), predclass);

end