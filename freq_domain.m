function splitAndTrainData()
    % Remove existing folders
    if exist('./MaleTraining', 'dir')
        rmdir('./MaleTraining', 's');
    end

    if exist('./FemaleTraining', 'dir')
        rmdir('./FemaleTraining', 's');
    end
    
    if exist('./MaleTesting', 'dir')
        rmdir('./MaleTesting', 's');
    end

    if exist('./FemaleTesting', 'dir')
        rmdir('./FemaleTesting', 's');
    end
    
    splitData();
    
    % Load training data
    training_files_male = dir('./MaleTraining/*.wav');
    training_files_female = dir('./FemaleTraining/*.wav');

    % Train based on the peak frequency
    avgPeakFreqMale = trainModel(training_files_male, 'male');
    avgPeakFreqFemale = trainModel(training_files_female, 'female');
    % Save the trained features
    save('trained_features.mat', 'avgPeakFreqMale', 'avgPeakFreqFemale');
    splitAndClassifyData();
end

function avgPeakFreq = trainModel(files, label)
    peakFreqList = [];

    for i = 1:length(files)
        file_path = fullfile(files(i).folder, files(i).name);
        [y, fs] = audioread(file_path);

        % Calculate the Power Spectral Density (PSD)
        [psd, freq] = pwelch(y, [], [], [], fs);

        % Find the frequency corresponding to the maximum PSD
        [~, maxIndex] = max(psd);
        peakFreq = freq(maxIndex);

        % Display features for each training data
        %fprintf('Training file [%s] #%d peak frequency:\n', label, i);
        %disp(peakFreq);

        peakFreqList = [peakFreqList; peakFreq];
    end

    % Calculate the average peak frequency for training
    avgPeakFreq = mean(peakFreqList);
    % Print the average peak frequency value
    fprintf('Average Peak Frequency for [%s] training: %.2f\n', label, avgPeakFreq);
end

function splitAndClassifyData()
    % Load testing data
    testing_files_male = dir('./MaleTesting/*.wav');
    testing_files_female = dir('./FemaleTesting/*.wav');

    % Load trained features
    load('trained_features.mat');

    % Classify male testing files
    [correct_male, total_male] = classifyFiles(testing_files_male, avgPeakFreqMale, avgPeakFreqFemale, 'male');

    % Classify female testing files
    [correct_female, total_female] = classifyFiles(testing_files_female, avgPeakFreqMale, avgPeakFreqFemale, 'female');

    % Calculate accuracy
    accuracy_male = correct_male / total_male * 100;
    accuracy_female = correct_female / total_female * 100;
    overall_accuracy = (correct_male + correct_female) / (total_male + total_female) * 100;

    fprintf('Accuracy for male: %.2f%%\n', accuracy_male);
    fprintf('Accuracy for female: %.2f%%\n', accuracy_female);
    fprintf('Overall Accuracy: %.2f%%\n', overall_accuracy);
end

function [correct, total] = classifyFiles(files, avgPeakFreqMale, avgPeakFreqFemale, label)
    correct = 0;
    total = length(files);

    for i = 1:total
        file_path = fullfile(files(i).folder, files(i).name);
        [y, fs] = audioread(file_path);

        % Calculate the Power Spectral Density (PSD)
        [psd, freq] = pwelch(y, [], [], [], fs);

        % Find the frequency corresponding to the maximum PSD
        [~, maxIndex] = max(psd);
        peakFreq = freq(maxIndex);

        % Display features for each data being tested
        fprintf('Test file [%s] #%d peak frequency: ', label, i);
        disp(peakFreq);

        % Classify based on the saved average peak frequency
        dm = abs(avgPeakFreqMale - peakFreq); % distance to male's voice peak
        df = abs(avgPeakFreqFemale - peakFreq); % distance to female's voice peak

        if (dm <= df)
            fprintf('Test file [%s] #%d classified as male\n', label, i);
            if strcmp(label, 'male')
                correct = correct + 1;
            end
        else
            fprintf('Test file [%s] #%d classified as female\n', label, i);
            if strcmp(label, 'female')
                correct = correct + 1;
            end
        end
    end
end
