function y_dees = deesser(x, frame, ovrlp, threshold, reduction_factor)
    % De-esser function using frame_wind and frame_recon

    % Parameters
    fs = 44100;        % Sample rate
    low_freq = 4000;   % Lower frequency for sibilance detection
    high_freq = 8000;  % Upper frequency for sibilance detection

    % Frame analysis with windowing
    X = frame_wind(x, frame, ovrlp);

    % Fourier Transform of each frame
    Xf = fft(X);

    % Convert frequencies to indices
    low_index = round(low_freq / fs * frame) + 1;
    high_index = round(high_freq / fs * frame) + 1;

    % Calculate energy in the target frequencies
    energy = sum(abs(Xf(low_index:high_index, :)), 1);

    % Smooth energy with a moving average filter
    energy = movmean(energy, 5);

    % Set a dynamic threshold
    threshold = 0.18 * max(energy);

    % Detect frames with sibilance
    mask = energy > threshold;

    % Attenuate sibilance in detected frames
    Xf(:, mask) = Xf(:, mask) * reduction_factor;

    % Inverse Fourier Transform
    X_dees = ifft(Xf, 'symmetric');

    % Signal reconstruction
    y_dees = frame_recon(X_dees, ovrlp);

    % --- Plotting ---

    figure;
    subplot(3, 1, 1);
    plot(x);
    title('Original Signal');
    xlabel('Frame');
    ylabel('Amplitude');

    subplot(3, 1, 2);
    plot(energy);
    hold on;
    plot([1, length(energy)], [threshold, threshold], 'r--');
    hold off;
    title('Energy in Target Frequencies (Red line is threshold)');
    xlabel('Frame');
    ylabel('Energy');
    ylim([0, max(energy) * 1.2]);

    subplot(3, 1, 3);
    plot(y_dees);
    title('Processed Signal (De-essed)');
    xlabel('Frame');
    ylabel('Amplitude');
end

% --- Load and process the audio ---
[x, fs] = audioread('vocals_deess.wav');
y_dees = deesser(x, 1024, 0.5, 0.18, 0.33);  % frame=1024, ovrlp=0.5

% --- Listen to the results ---
soundsc(x, fs);
pause(length(x)/fs + 1); 
soundsc(y_dees, fs);