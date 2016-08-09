# Spectra Learner
A classification toolbox for the analysis of spectral microscopy images.

## Purpose
Many recent confocal microscope system come equipped with a spectral detector. These systems often come packaged with linear spectral unmixing software that is able to decompose raw spectral signatures into different channels based on a set of defined reference spectra. Linear unmixing is particularly useful when you have two or more fluorescent signatures overlapped in one area. Linear unmixing solves the least squares problem to divide the observed signals into their respective component channels. Unmixing has proven useful for a variety of techniques including FRET and the removal of autofluorescence. However, linear unmixing is not ideal for the analysis of spectral methods such as combinatorial labeling.[^fn1] In these techniques, combinations of fluorescent tags are used to identify a biological target of interest such that each target has a unique spectral signature. Instead of unmixing the signals, what we really want to do is correctly classify the signatures. For this reason, I have written this classification toolbox for the analysis of spectral microscopy images.

The Spectra Learner toolbox builds a classification models based on a provided set of reference spectra. This classification model is used to identify each signature in a set of raw spectral images.

## Compatibility and Requirements
Spectra Learner was written in MATLAB 2016a, and has been tested on unix-based systems. This toolbox requires the following MATLAB toolboxes: Statistics and Machine Learning, Image Processing, and Parallel Computing.

## Experimental Setup
### Reference Spectra
There are a variety of opinions on how 

[^fn1]: Valm, A.M., Welch, J.L.M. and Borisy, G.G., 2012. CLASI-FISH: principles of combinatorial labeling and spectral imaging. Systematic and applied microbiology, 35(8), pp.496-502.