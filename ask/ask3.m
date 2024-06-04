% deesser.m

% Φόρτωση του αρχείου ήχου
[x, fs] = audioread('vocals_deess.wav');

% Παράμετροι frame και ovrlp
frame = 1024;  % Μεγαλύτερο frame για ρυθμό δειγματοληψίας 44.1 kHz
ovrlp = 0.5;

% Ανάλυση του ήχου σε frames
X = frame_wind(x, frame, ovrlp);

% Υπολογισμός ενέργειας και Zero-Crossing Rate για κάθε frame
energy = sum(X.^2);
zcr = sum((sign(X(2:end, :)) - sign(X(1:end-1, :))).^2);

% Παράμετροι a και b
a = 0.9;
b = 0.5;

% Χωρισμός των frames σε "σσ/ες" και όχι "σσ/ες"
unvoiced_frames = energy < a * max(energy) & zcr > b * max(zcr);
voiced_frames = ~unvoiced_frames;

% Εξασθένηση των "σσ/ες" frames
attenuation_factor = 0.5;  % Παράγοντας εξασθένησης (0.5 = 50%)
X(:, unvoiced_frames) = X(:, unvoiced_frames) * attenuation_factor;

% Ανασύνθεση των frames
deessed_signal = frame_recon(X, ovrlp);

% Αναπαραγωγή του αρχικού και του επεξεργασμένου σήματος
disp('Αρχικό σήμα:')
soundsc(x, fs);
pause(length(x) / fs + 1);
disp('Επεξεργασμένο σήμα (De-essed):')
soundsc(deessed_signal, fs);

% Απεικόνιση των δύο σημάτων
figure;
subplot(2,1,1);
plot(x);
title('Αρχικό Σήμα');
subplot(2,1,2);
plot(deessed_signal);
title('Επεξεργασμένο Σήμα (De-essed)');