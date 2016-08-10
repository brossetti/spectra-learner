# Spectra Learner
A classification toolbox for the analysis of spectral microscopy images.

## Motivation
Many microscope systems equipped with spectral detectors come packaged with software for linear unmixing. These linear unmixing functions solve the least squares problem to decompose your spectral microscopy images into component channels based on a set of predefined reference spectra. Although linear unmixing is great for separating signals that overlap within a given pixel (ex. autofluorescence + fluorescent tag), the least squares equation is not well suited for classification problems. Techniques such as Combinatorial Labeling and Spectral Imaging Fluorescence *in situ* Hybridization (CLASI-FISH) use unique sets of fluorescent tags to identify spatially disparate targets of interest. Since the fluorescent signatures are not overlapping within any given pixel, we need only classify each pixel based on its observed spectrum.

The Spectra Learner toolbox provides a convenient way to analyze raw spectral microscopy images without the need for complex linear unmixing pipelines. Spectra Learner builds a classification model based on a set of reference spectra, and uses the learned model to accurately and efficiently predict the identity of unknown pixels within a raw spectral microscopy image. The Spectra Learner toolbox allows you to classify your images by simply dragging and dropping your files into the appropriate directories. Spectra Learner has been designed to handle sets of images from sequentially acquired spectral microscopy images. If you don’t mind getting your hands dirty, the modular functions of this toolbox can be modified for a tailored analysis routine.

There are many elements to spectral microscopy experiments, but techniques leveraging the spectral dimension can be extremely powerful. I have provided some tips below to get the most out of this toolbox and your experiment.

## Compatibility and Requirements
Spectra Learner was written in MATLAB 2016a, and has been tested on unix-based systems. This toolbox requires the following MATLAB toolboxes: Statistics and Machine Learning, Image Processing, and Parallel Computing.

## Experimental Setup
### Overview
There are two basic modes for a spectral microscopy experiment: simultaneous scan and sequential scan. 

### Reference Images
The Spectra Learner classification model makes predictions by first learning all possible signatures during the training phase. The user provides reference images of each spectral signature. Reference images should be acquired under similar physical conditions to those of the experimental images. The reference images are assumed to be grayscale TIFF stacks with a black background. 

The resolution and bit depth of your reference images will impact the duration of the training phase. A good balance between speed and accuracy can be obtained with 8-bit images at 256x256 resolution. 

###

### References
Valm, A.M., Welch, J.L.M. and Borisy, G.G., 2012. CLASI-FISH: principles of combinatorial labeling and spectral imaging. *Systematic and applied microbiology*, 35(8), pp.496-502.