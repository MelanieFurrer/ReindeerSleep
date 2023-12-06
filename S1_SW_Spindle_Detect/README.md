# Spindle and Slow Wave Detection

Spindle detection:  
        
**A1_spindle_detect_BP.m:** Detect Spindles  
Input:  .mat file with pre-processed EEG data, artefact and scoring info  
Output: .mat file with spindle info  

**A2_findepochs_highSD_nrem.m:** Find NREM-Sleep epochs with high spindle density  
Input: spindle info, artefact info, EEG data prepared for cross-frequency coupling (20s epochs of NREM sleep with 4 sec overlap)  
Output: EEG data prepared for cross-frequency coupling (20s epochs of NREM sleep with 4 sec overlap). Only epochs with more than X spindles per minute.  

**A2_findepochs_highSD_rum.m:** same as "A2_findepochs_highSD_nrem.m", but for rumination epochs  
     
<br/><br/>          
Slow-Wave Detection:  

**B0_filterdata_for_swdetect.m:** Filter Data for slow-wave detection  (e.g. 0.5 - 4 Hz)  
Input: .mat file with pre-processed EEG data, artefact and scoring info  
Output: .mat file with filtered EEG data for slow-wave detection, artefact and scoring info   
**B1_ToDoSwdetect.m:** Run slow-wave detection  
Input: .mat file with filtered EEG data for slow-wave detection, artefact and scoring info  
Output: .mat file with filtered EEG data, artefact and scoring info and slow-wave detection info  


<br/><br/>          
Illustrative Plot for Supplementary Figure:  

**S_plotsignal.m**  
Input: Pre-Processed EEG data, EEG data filtered for slow-wave detection, slow-wave detection info, spindle detection info (with filtered signal used for detection)  
Output: Illustrative plot
