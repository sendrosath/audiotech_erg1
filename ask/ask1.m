% Φόρτωση του αρχείου ήχου
[x, fs] = audioread('guit1.wav');

% Παράμετροι frame και ovrlp
frame = 256;
ovrlp = 0.5;

% Ανάλυση του ήχου
X = frame_wind(x, frame, ovrlp);

% Ανακατασκευή του ήχου
y = frame_recon(X, ovrlp);

% Αναπαραγωγή του αρχικού ήχου
soundsc(x, fs);

% Αναμονή διάρκειας αρχικού ήχου και ενός δευτερολέπτου
pause(length(x)/fs + 1); 

% Αναπαραγωγή του ανακατασκευασμένου ήχου
soundsc(y, fs);