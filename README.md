# DSP-Course-Assignment
## Gender Recognition and Classification of Speech Signals

This repository contains the implementation of a simple gender recognition and classification system for speech signals using MATLAB. The primary goal is to distinguish between male and female speakers, utilizing both time and frequency domains for the analysis.

## Assignment Overview:

In this assignment, the goal was to develop a system capable of analyzing speech signals using various features in both time and frequency domains. The system classifies speakers as either male or female based on recorded sentences, with a focus on the word "zero."

## Key Objectives:

- **Utilize Time and Frequency Domains:** The system utilizes features from both time and frequency domains to enhance the accuracy of gender classification in speech signals.

- **Implement Signal Analysis Techniques:** Various signal analysis techniques, including Zero-Crossing Rate (ZCR), Energy, Correlation, and Power Spectral Density (PSD), are applied to extract meaningful features.

- **Dataset Requirements:** A sufficient dataset comprising recordings from different male and female speakers, considering factors such as age, environment, and other variations.

## Included MATLAB Scripts:

1. `audioRecorderGUI.m` A script providing a graphical user interface for recording, playing back, and saving audio files. Used to collect voice recordings for dataset creation.

2. `splitData.m` Splits the dataset into records for male and female speakers and further divides them into training and testing sets.

3. `time_domain.m` Implements the time-domain system for training and classification, utilizing ZCR, Energy, and Correlation features.

4. `freq_domain.m` Implements the frequency-domain system for training and classification, utilizing Power Spectral Density (PSD) as the main feature.

## Assignment PDF:

Refer to the assignment PDF file provided by the course instructor for comprehensive instructions and requirements (Assignment_DSP.pdf).

## Testing Data and Performance

### Testing Data Description

- Dataset includes recordings from both male and female speakers.
- Sentences recorded focus on the word "zero."
- Audio files are two seconds long with a constant sampling frequency of 44100 Hz.
- Limited dataset affects training and classification accuracy.

### Performance of Each System

#### Time-Domain System

- Utilizes ZCR, Energy, and Correlation features.
- Female classification accuracy typically 100%, influenced by uniform recording conditions.
- Male classification accuracy varies; diverse data collection recommended for improvement.

#### Frequency-Domain System

- Uses PSD and average peak frequency for classification.
- Varied accuracy based on differences in the dataset.

#### Conclusion

- Content differences in gender-specific recordings affect accuracy.
- Time domain outperforms frequency domain in some cases.
- Larger, higher-quality datasets would enhance results.

## System Improvement and Extension

### Time Domain

- Explore additional time-domain features.
- Experiment with different machine learning models.
- Apply signal processing techniques for feature refinement.

### Frequency Domain

- Investigate advanced frequency-domain features.
- Implement sophisticated classifiers, e.g., neural networks.
- Consider noise reduction through pre-processing steps.

### Extension to Different Words

- Diversify dataset with recordings for various words and phrases.
- Design features capturing broader speech characteristics.
- Transition to multi-class classification.
- Ensure adaptability to different languages and accents.


## Usage:

1. Execute `audioRecorderGUI.m` to record and save audio files.
2. Run `splitData.m` to divide the dataset into training and testing files.
3. Execute either `time_domain.m` or `freq_domain.m` for training and classification.
