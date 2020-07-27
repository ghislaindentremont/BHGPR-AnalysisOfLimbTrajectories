# BAYESIAN HIERARCHIAL GAUSSIAN PROCESS REGRESSION FOR ANALYSIS OF LIMB TRAJECTORIES

## Summary 

The code in this folder contains all the participant data and analysis code required to reproduce the results described in the manuscript. Moreover, the MATLAB code stored in the ‘Experiment Code’ folder should enable the reader to replicate the methods used in this experiment. 

The following **Contents** should hold true for these package/software specifications unless otherwise specified:
- R version 4.0.2 (2020-06-22) 
- rstan_2.19.3 
- Rstudio Version 1.3.959
- macOS Catalina 10.15.6

NOTE: ‘optotrak_data.csv’ and ‘post_1000_15_mtd17.rdata’ are stored using Git Large File Storage (LFS). To download these files, you will need to download the git lfs software and clone the repository using git. Follow these steps to install git lfs on your computer: https://docs.github.com/en/github/managing-large-files/installing-git-large-file-storage. 

## Contents
‘trajectory_analysis.R’: The primary analysis script. 
1. It downloads, cleans, and analyzes the touch screen data. 
2. It downloads, preprocesses, and analyzes the optotrak data. 
3. It formats and generates the data object for the FANOVAN analysis (see ‘fda_analysis.m’), and displays the corresponding results. 
4. It formats and generates the data object required for the BHGPR analysis (see ‘cluster_analysis.R’), and displays the corresponding results. 
5. It generates all the graphs presented in the manuscript. 

’touch_screen_data.csv’: The participant touch screen data from the experiment. 

‘optotrak_data.csv’: The participant optotrak data from the experiment. 

‘mat_long_trim.csv’: The data packaged for the FANOVAN analysis (see ‘fda_analysis.m’). 

‘fda_analysis.m’: MATLAB code for FANOVAN analysis.

‘FDA_for_Reach’: Folder containing files required to conduct FDA analysis. 

‘fanovan_norm_time’: The results of the FANOVAN analysis, to be handled by ‘trajectory_analysis.R’. 

‘data_for_stan15.RData’: The data list to be fed to the BHGPR model via the ‘cluster_analysis.R’ script. 

‘cluster_analysis.R’ : The script fed to Dalhousie’s computer cluster to compute the Bayesian posterior distributions. Note: this script was used to generate ‘post_1000_15_mtd17.rdata’ in 2017. The versions of R and rstan run by the cluster computers are unknown. The script current generates a “Cluster setup failed” error message with the aforementioned specifications. I am unsure of the solution at the moment.

‘gp_regression.stan’: The BHGPR model. The ‘cluster_analysis.R’ script loads this model. 

‘post_1000_15_mtd17.rdata’: The results of the BHGPR analysis run on the cluster. This data file contains all the information regarding the posterior distributions of the Bayesian model. 

‘Experiment Code’ : The MATLAB files in this folder were used to run the experiment on the touch screen described in the methods section of the manuscript as well as to control the PLATO goggles. 
