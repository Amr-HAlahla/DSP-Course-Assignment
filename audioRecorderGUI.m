function audioRecorderGUI()
    % Create a figure
    fig = figure('Name', 'Audio Recorder', 'NumberTitle', 'off', 'Position', [100, 100, 400, 200]);

    % Create UI components
    uicontrol('Style', 'text', 'String', 'Recording Status:', 'Position', [20, 160, 120, 20]);
    statusText = uicontrol('Style', 'text', 'String', 'Not Recording', 'Position', [140, 160, 120, 20]);

    recordButton = uicontrol('Style', 'pushbutton', 'String', 'Record', 'Position', [20, 120, 80, 30], 'Callback', @recordCallback);
    playButton = uicontrol('Style', 'pushbutton', 'String', 'Play', 'Position', [120, 120, 80, 30], 'Callback', @playCallback);
    saveButton = uicontrol('Style', 'pushbutton', 'String', 'Save', 'Position', [220, 120, 80, 30], 'Callback', @saveCallback);

    % Initialize variables
    isRecording = false;
    recordedData = [];

    % Audio recording callback
    function recordCallback(~, ~)
        if ~isRecording
            statusText.String = 'Recording...';

            % Record audio for 2 seconds
            recorder = audiorecorder(44100, 16, 1);
            record(recorder, 2);

            % Update status and store recorder object
            statusText.String = 'Recording...';
            setappdata(fig, 'recorder', recorder);
            isRecording = true;

            % Timer to stop recording after 2 seconds
            timerObj = timer('TimerFcn', @stopRecording, 'StartDelay', 2);
            start(timerObj);
        end
    end

    % Timer callback to stop recording
    function stopRecording(~, ~)
        recorder = getappdata(fig, 'recorder');
        stop(recorder);

        % Get recorded data
        recordedData = getaudiodata(recorder);

        % Update status
        statusText.String = 'Recording Complete';
        isRecording = false;
    end

    % Audio playing callback
    function playCallback(~, ~)
        if ~isempty(recordedData)
            % Play recorded audio
            soundsc(recordedData, 44100);
        else
            % Display a message if no audio is recorded
            msgbox('No recorded audio available.', 'Info', 'warn');
        end
    end

    % Audio saving callback
    function saveCallback(~, ~)
        if ~isempty(recordedData)
            % Save recorded audio to a file
            [filename, path] = uiputfile('male_01.wav', './Records/');
            if filename ~= 0
                audiowrite(fullfile(path, filename), recordedData, 44100);
                msgbox('Audio saved successfully!', 'Info', 'info');
            end
        else
            % Display a message if no audio is recorded
            msgbox('No recorded audio available.', 'Info', 'warn');
        end
    end
end
