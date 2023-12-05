# Preprocessing

These scripts were used to pre-process EEG data.  
<br/><br/>   
        
**A_create_scoring_file_withBipolarDerivation_resample.m:** Create files for scoring  
-> filter 0.5 - 40 Hz, downsample to 128 Hz, re-reference for bipolar derivation and for EMG signal, calculate "NREM index" for scoring  

Input:
- .edf files (raw EEG data, 12 hours per file)  

Output:
- files used for scoring program
- .mat files (filtered and downsampled EEG data, 12 hours per file)  
          
<br/><br/>          
**B_preprocessing.m:** Calculate power and do semi-automatic artefact rejection, combine 12 hour files, temporally align data  

Input:
- .mat files (filtered and downsampled EEG data, 12 hours per file)

Output:
- .mat files with artefact-index and scoring-info including power values per epoch in 0.25 Hz resolution (3 files per reindeer in each season)
- .mat files with artefact-index and scoring-info including pre-processed EEG data (3 files per reindeer in each season)
