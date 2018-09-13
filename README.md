# kk_om_utils
This repository contains code that I started writing in 2016, for my projects that use large scale electrophysiology in NHP. This was written mainly to run computations done for each Utah array site in parallel in a HPC (openmind at MIT).  

To run these in openmind, make sure you do the following:

1. add the head folder and all subfolder in the MATLAB path
       addpath(genpath('\path-to-head-folder'));
       
2. make a config file for yourself and put it on the headfolder
A sample config file, config.mat is placed on the head folder (you can choose to just modify that)
