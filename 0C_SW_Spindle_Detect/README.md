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


<br/><br/>      
**A2_create_matfile_filter0145_resample256** and **B2_preprocessing_filter0145_resample256**: Pre-processing for slow-wave detection, spindle detection and cross-frequency coupling  

<br/><br/>  
**B3_artreject_rum**: Calculate power and do semi-automatic artefact rejection for rumination epochs (used for SWA decrease during rumination analysis)
