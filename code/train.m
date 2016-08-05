function [ mdl ] = train( rootdir )
%TRAIN Trains the spectral SVM based on the reference spectra
%   Detailed explanation goes here

% randomly select predictors for training
idx = randperm(size(x,1)); 
trainidx = idx(1:round(2*size(x,1)/3));
testidx = idx(length(trainidx)+1:end);

% train model
gcp;
paroptions=statset('UseParallel',true);
mdl = fitcecoc(x(trainidx,:),y(trainidx), 'Options', paroptions);

% check model with test set
predclass = predict(Mdl, x(testidx,:));
confMat = confusionmat(y(testidx), predclass);

end