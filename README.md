# SONET SDH SIMULATOR RECEPTOR

_The objective is an educational view of sonet SDH receive datagrams wich are very important in the 
comunications system_

## Compatibility

_The scripts are compatible with Matlab and Octave 
```
Octave 5

Matlab 2018 - Matlab 2020b
```
## Contain description

_ **G709.pdf** pdf with techical information about SONET SDH datagram composition_
_ **MatrixTraining.m** overhead file, not important_
_ **PositiveJustificationHappens.m** function that compares two AUX pointers and determine if positive or negative justification happens_
_ **replaceRowWise.m** function that replaces part of an array or matrix into other one but the access is lineal like: 1:20 (more desc in the file info_ 
_ **sdhReceive.m** function that get **tx_NoJust.mat** or **tx_WithJust.mat** file and get two pictures contained in the datagrams_
_ **sdhTransmit.m** like **sdhReceive.m** but it send the image, it not works because was made by some person that make it so strange_
_ **tx_NoJust.mat** and **tx_WithJust.mat** binary files with the datagram compressed_

## Use guide

_ execute:

### in Octave:

_ get into the file directory:_

```
cd (files_directory_path);
tx = importdata('tx_NoJust.mat');
imgs = sdhReceive(tx);
```

### in Matlab:

_ get into the file directory:_

```
cd (files_directory_path);
tx = load('tx_NoJust.mat');
imgs = sdhReceive(tx);
```