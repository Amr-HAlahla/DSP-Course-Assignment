function splitAndClassifyData()
    % Remove existing folders
    folders = {'./MaleTraining', './MaleTesting', './FemaleTraining', './FemaleTesting'};
    for i = 1:length(folders)
        if exist(folders{i}, 'dir')
            rmdir(folders{i}, 's');
        end
    end
    
    splitData();
    
    % Load training and testing data
    [training_files_male, testing_files_male, training_files_female, testing_files_female] = loadFiles();

    % Calculate features for male and female training data
    data_male = calculateFeatures(training_files_male);
    fprintf('The features for male are \n');
    disp(mean(data_male));

    data_female = calculateFeatures(training_files_female);
    fprintf('The features for female are \n');
    disp(mean(data_female));

    % Classify testing files
    [correct_male, total_male] = classifyFiles(testing_files_male, data_male, data_female, 'male');
    [correct_female, total_female] = classifyFiles(testing_files_female, data_male, data_female, 'female');

    % Calculate accuracy
    accuracy_male = correct_male / total_male * 100;
    accuracy_female = correct_female / total_female * 100;
    overall_accuracy = (correct_male + correct_female) / (total_male + total_female) * 100;

    fprintf('Accuracy for male: %.2f%%\n', accuracy_male);
    fprintf('Accuracy for female: %.2f%%\n', accuracy_female);
    fprintf('Overall Accuracy: %.2f%%\n', overall_accuracy);
end

function [training_files_male, testing_files_male, training_files_female, testing_files_female] = loadFiles()
    training_files_male = dir('./MaleTraining/*.wav');
    testing_files_male = dir('./MaleTesting/*.wav');
    training_files_female = dir('./FemaleTraining/*.wav');
    testing_files_female = dir('./FemaleTesting/*.wav');
end

function data = calculateFeatures(files)
    data = [];
    
    for i = 1:length(files)
        file_path = fullfile(files(i).folder, files(i).name);
        [y, ~] = audioread(file_path);

        % Modify or add features as needed
        ZCR1 = mean(abs(diff(sign(y(1:floor(end/3))))))./2;
        ZCR2 = mean(abs(diff(sign(y(floor(end/3):floor(end*2/3))))))./2;
        ZCR3 = mean(abs(diff(sign(y(floor(end*2/3):end)))))./2;
        energy = sum(y.^2);
        cross_corr_1_2 = max(abs(xcorr(y(1:floor(end/3)), y(floor(end/3):floor(end*2/3)))));

        % Do not normalize features for now
        features = [ZCR1 ZCR2 ZCR3 energy cross_corr_1_2];

        data = [data; features];
    end
end

function [correct, total] = classifyFiles(files, data_male, data_female, label)
    correct = 0;
    total = length(files);

    for i = 1:total
        file_path = fullfile(files(i).folder, files(i).name);
        [y, ~] = audioread(file_path);

        % Modify or add features as needed
        ZCR1 = mean(abs(diff(sign(y(1:floor(end/3))))))./2;
        ZCR2 = mean(abs(diff(sign(y(floor(end/3):floor(end*2/3))))))./2;
        ZCR3 = mean(abs(diff(sign(y(floor(end*2/3):end)))))./2;
        energy = sum(y.^2);
        cross_corr_1_2 = max(abs(xcorr(y(1:floor(end/3)), y(floor(end/3):floor(end*2/3)))));

        % Do not normalize features for now
        fileFeatures = [ZCR1 ZCR2 ZCR3 energy cross_corr_1_2];

        % Display features for each data being tested
        fprintf('Test file [%s] #%d features:\n', label, i);
        disp(fileFeatures);

        % Make the decision based on Euclidean distance
        dist_male = pdist([fileFeatures; mean(data_male)], 'Euclidean');
        dist_female = pdist([fileFeatures; mean(data_female)], 'Euclidean');
        
        % Experiment with different distance metrics
        if (dist_male < dist_female)
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
