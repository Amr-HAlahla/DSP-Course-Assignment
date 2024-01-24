function splitData()
    % Set the ratio for training and testing data
    trainingRatio = 0.7;
    testingRatio = 1 - trainingRatio;

    % Load all data
    allData = dir('./Records/*.wav');

    % Separate male and female data using regular expressions
    maleData = allData(~cellfun('isempty', regexp({allData.name}, '^male')));
    femaleData = allData(~cellfun('isempty', regexp({allData.name}, '^female')));

    % Shuffle the data for randomness (if needed)
    maleData = maleData(randperm(length(maleData)));
    femaleData = femaleData(randperm(length(femaleData)));

    % Determine the number of files for training and testing
    numMaleTraining = round(trainingRatio * length(maleData));
    numFemaleTraining = round(trainingRatio * length(femaleData));

    % Check if folders already exist, and create them if not
    if ~exist('./MaleTraining', 'dir')
        mkdir('./MaleTraining');
    end

    if ~exist('./MaleTesting', 'dir')
        mkdir('./MaleTesting');
    end

    if ~exist('./FemaleTraining', 'dir')
        mkdir('./FemaleTraining');
    end

    if ~exist('./FemaleTesting', 'dir')
        mkdir('./FemaleTesting');
    end

    % Create MaleTraining set
    for i = 1:numMaleTraining
        copyfile(fullfile('./Records', maleData(i).name), './MaleTraining');
    end

    % Create MaleTesting set
    for i = numMaleTraining + 1:length(maleData)
        copyfile(fullfile('./Records', maleData(i).name), './MaleTesting');
    end

    % Create FemaleTraining set
    for i = 1:numFemaleTraining
        copyfile(fullfile('./Records', femaleData(i).name), './FemaleTraining');
    end

    % Create FemaleTesting set
    for i = numFemaleTraining + 1:length(femaleData)
        copyfile(fullfile('./Records', femaleData(i).name), './FemaleTesting');
    end

    disp('Data splitting completed.');
end
