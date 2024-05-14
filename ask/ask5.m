% Φόρτωση του αρχείου ήχου
[x, fs] = audioread('piano.wav');

% Παράμετροι frame και ovrlp
frame = 256;
ovrlp = 0.5;

% Ανάλυση του ήχου σε frames
X = frame_wind(x, frame, ovrlp);
E = sum(X.^2);

% Υπολογισμός της μεταβολής της ενέργειας
dE = abs(diff(E, 1, 2));

% Ορισμός threshold για τον εντοπισμό των onset
threshold = 1.5;
onsets = dE > threshold;

% Δημιουργία του πίνακα Ζ
Z = zeros(size(X, 2), 1);
Z(onsets) = 1;

% Απεικόνιση της μεταβολής της ενέργειας
figure;
subplot(3, 1, 1);
plot(1:length(E), E, 'g');
xlabel('Frame');
ylabel('Ενέργεια');
title('Ενέργεια ανά frame');

subplot(3, 1, 2);
plot(1:length(dE), dE, 'b');
xlabel('Frame');
ylabel('\deltaE(k)');
title('Μεταβολή Ενέργειας ανά frame');

% Απεικόνιση των onsets
subplot(3, 1, 3);
stem(1:length(Z), Z, 'r', 'Marker', 'none');
xlabel('Frame');
ylabel('Onset');
title('Detected Onsets');

% Ανασύνθεση του ήχου z από τον πίνακα Ζ
z = frame_recon(X(:, Z == 1), ovrlp);

% Ακρόαση του ανασυνθεσμένου ήχου
soundsc(z, fs);