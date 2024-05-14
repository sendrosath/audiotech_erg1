% Φόρτωση του αρχείου ήχου
[x, fs] = audioread('guit2.wav');

% Παράμετροι frame και ovrlp
frame = 256;
ovrlp = 0.5;

% Ανάλυση του ήχου σε frames
X = frame_wind(x, frame, ovrlp);

% Υπολογισμός της ενέργειας για κάθε frame
E = sum(X.^2);

% Απεικόνιση της μεταβλητής Ε
figure;
plot((1:length(E)) * frame, E);
xlabel('Frames');
ylabel('Ενέργεια');
title('Ενέργεια ανά frame');

% Θέτουμε κατώφλι για να κρίνουμε εάν υπάρχει ομιλία σε ένα frame
threshold = 0.05;

% Δημιουργία του πίνακα Υ με τα ενεργά frames
Y = X(:, E > threshold);

% Ανασύνθεση του ήχου από τον πίνακα Υ
y = frame_recon(Y, ovrlp);

% Αναπαραγωγή του ανακατασκευασμένου ήχου
soundsc(y, fs);

% Υπολογισμός του ποσοστού ανενεργών frames
inactive_frames_percentage = sum(E <= threshold) / length(E) * 100;
disp(['Το ποσοστό των ανενεργών frames είναι: ' num2str(inactive_frames_percentage) '%']);