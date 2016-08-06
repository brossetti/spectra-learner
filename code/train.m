function [ mdl ] = train( X, Y )
%TRAIN Trains the spectral SVM based on the reference spectra
%   Detailed explanation goes here

% randomly select predictors for training
idx = randperm(size(X,1)); 
trainidx = idx(1:round(2*size(X,1)/3));
testidx = idx(length(trainidx)+1:end);

% train model
gcp;
paroptions=statset('UseParallel',true);
mdl = fitcecoc(X(trainidx,:),Y(trainidx), 'Options', paroptions);

% check model with test set
predclass = predict(Mdl, X(testidx,:));
confMat = confusionmat(Y(testidx), predclass);

end