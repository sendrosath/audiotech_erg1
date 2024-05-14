% Φόρτωση του αρχείου ήχου
[x, fs] = audioread('guit2.wav');

% Παράμετροι frame και ovrlp
frame = 256;
ovrlp = 0.5;

% Ανάλυση του ήχου σε frames
X = frame_wind(x, frame, ovrlp);

% Υπολογισμός ενέργειας και Zero-Crossing Rate για κάθε frame
energy = sum(X.^2);
zcr = sum(abs(diff(sign(X)))) / (2 * frame);

% Παράμετροι a και b
a=0.4;
b=0.4;

% Χωρισμός των frames σε φωνούμενα και μη-φωνούμενα
unvoiced_frames = energy < a * max(energy) & zcr > b * max(zcr);
voiced_frames = ~unvoiced_frames;

% Δημιουργία φωνούμενων και μη-φωνούμενων τμημάτων του X
X_voiced = X;
X_unvoiced = X;
X_voiced(:, unvoiced_frames) = 0;
X_unvoiced(:, voiced_frames) = 0;

% Ανασύνθεση των φωνούμενων και μη-φωνούμενων frames
voiced_signal = frame_recon(X_voiced, ovrlp);
unvoiced_signal = frame_recon(X_unvoiced, ovrlp);

% Αναπαραγωγή των δύο κυματομορφών
disp('Now hearing voiced signal')
soundsc(voiced_signal, fs);
pause(length(voiced_signal) / fs + 1);
disp('Now hearing unvoiced signal')
soundsc(unvoiced_signal, fs);
pause(length(unvoiced_signal) / fs + 1);

% Απεικόνιση των δύο κυματομορφών
figure;
subplot(3,1,1);
plot(voiced_signal);
title('Φωνούμενο Τμήμα');
subplot(3,1,2);
plot(unvoiced_signal);
title('Μη-Φωνούμενο Τμήμα');

% Πρόσθεση των δύο κυματομορφών
sum_signal = voiced_signal + unvoiced_signal;

% Αναπαραγωγή του αθροίσματος
disp('Now hearing the sum of voiced and unvoiced signals');
soundsc(sum_signal, fs);

% Απεικόνιση του αθροίσματος των δύο κυματομορφών
subplot(3,1,3);
plot(sum_signal);
title('Άθροισμα');