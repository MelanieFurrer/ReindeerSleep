# Cross-Frequency Coupling
        
**A_prepare_data.m:**  
Input: .mat files with pre-processed EEG data (filtered 0.1 - 45 Hz, down-sampled to 256 Hz) including artefact and scoring info  
Output: EEG data prepared for cross-frequency coupling (20s epochs of NREM sleep with 4 sec overlap)  


**B_cfc_coupling_hightspindledensity.m:**  
Input: EEG data prepared for cross-frequency coupling (20s epochs of NREM sleep with 4 sec overlap) for both NREM sleep and rumination  
Output: Plots showing modulation index for both NREM sleep and rumination  
