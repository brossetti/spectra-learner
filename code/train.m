function [ mdl ] = train( X, Y )
%TRAIN Trains the spectral SVM based on the reference spectra
%   Detailed explanation goes here

% randomly select predictors for training
idx = randperm(size(X,1)); 
trainidx = idx(1:round(3*size(X,1)/4));
testidx = idx(length(trainidx)+1:end);

% train model
gcp;
paroptions=statset('UseParallel',true);
t = templateSVM('KernelFunction', 'polynomial', 'PolynomialOrder', 2);
mdl = fitcecoc(X(trainidx,:),Y(trainidx), 'Learner', t, ...
    'Prior', 'uniform', 'Options', paroptions);

% check model with test set
predclass = predict(mdl, X(testidx,:));
confMat = confusionmat(Y(testidx), predclass)

end