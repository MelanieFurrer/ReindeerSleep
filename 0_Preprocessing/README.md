# Preprocessing

These scripts were used to pre-process EEG data.


1. Create files for scoring: "A2_create_scoring_file_withBipolarDerivation_resample.m"

-> filter 0.5 - 40 Hz, downsample to 128 Hz, re-reference for bipolar derivation and for EMG signal, calculate "NREM index" for scoring

Input:
- .edf files (raw EEG data, 12 hours per file)

Output:
- files used for scoring program
- .mat files (filtered and downsampled EEG data, 12 hours per file)



2. Calculate power and artefact rejection, combine 12 hour files, temporally align data: "B_preprocessing.m"

Input:
- .mat files (filtered and downsampled EEG data, 12 hours per file)

Output:
- .mat file with artefact-index and scoring-info including power values per epoch in 0.25 Hz resolution (approx. 91 hours per file, 1 file per reindeer in each season)
- .mat file with artefact-index and scoring-info including pre-processed EEG data (approx. 91 hours per file, 1 file per reindeer in each season)
