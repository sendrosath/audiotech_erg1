% Load the audio file
[x, fs] = audioread('piano.wav');

% Define the filter parameters
cutoff_frequency = 1100; % Hz
filter_order = 8;

% Design a high-pass filter
[b, a] = butter(filter_order, cutoff_frequency/(fs/2), 'high');

% Apply the filter to the audio signal
x_filtered = filter(b, a, x);

% Define frame parameters
frame_length = 256;
overlap = 0.5;

% Analyze the audio using frame_wind
X = frame_wind(x_filtered, frame_length, overlap);
E = sum(abs(X).^2, 1); % Sum along the rows (dimension 1) to get energy for each frame

% Compute energy variation
dE = abs([0, diff(E)]); % Use comma instead of semicolon to create a row vector

% Define a threshold for onset detection
threshold = 0.35;
onsets = dE > threshold;

% Create the Z matrix
Z = zeros(size(X, 2), 1);
Z(onsets) = 1;

% Reconstruct the audio signal z from Z
z = frame_recon(X(:, Z == 1), overlap);

% Plot the energy variation and detected onsets
figure;

subplot(3, 1, 1);
plot(1:length(E), E, 'g');
xlabel('Frame');
ylabel('Energy');
title('Energy');

subplot(3, 1, 2);
plot(1:length(dE), dE, 'b');
xlabel('Frame');
ylabel('\deltaE(k)');
title('Energy Variation');

subplot(3, 1, 3);
stem(1:length(Z), Z, 'r', 'Marker', 'none');
xlabel('Frame');
ylabel('Onset');
title('Detected Onsets');

% Listen to the reconstructed audio
soundsc(z, fs);
