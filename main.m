%% Transformée de Fourier à fenêtre glissante

close all;
clear;
% Chargement des variables à partir du fichier SigDop.mat
data = load('SigPiano.mat'); % Charge toutes les variables

% Extraction des variables
signal = data.Sig; % Signal
Fe = data.Fe; % Fréquence d'échantillonnage

% Vérification des données chargées 
disp('Signal et fréquence d echantillonnage charges :');
disp(['Taille du signal : ', num2str(length(signal))]);
disp(['Fréquence d echantillonnage : ', num2str(Fe), ' Hz']);

% Définition des paramètres
LongFen = 1024; % Taille de la fenêtre de stationnarité
UnSurQ = 1; % Facteur d'échantillonnage des fenêtres 
M = LongFen; % Nombre de points pour la FFT )

% Découpage du signal en fenêtres de longueur LongFen
MatSig = Decoupe(signal, LongFen, UnSurQ); % Matrice de taille LongFen × P

% Application de la transformée de Fourier sur chaque fenêtre
MatFFT = fft(MatSig, M); % Matrice de taille M × P

% Calcul du périodogramme
Periogramme = abs(MatFFT).^2; % Matrice de taille M × P

PerioNormalise = NormSpec(Periogramme, 'M').*(Fe/M);

figure;
t = (0:length(signal)-1) / Fe; % Temps associé au signal
plot(t, signal, 'b'); % Tracé du signal
xlabel('Temps (s)');
ylabel('Amplitude');
title('Signal temporel');
grid on;

figure;
f = linspace(0,Fe,M); % Fréquences
idx = f <= 2000; % Index des fréquences jusqu'à 2000 Hz
imagesc(1:size(MatSig, 2), f(idx), PerioNormalise(idx, :)); 
colorbar;
xlabel('Fenêtres');
ylabel('Fréquences');
axis("xy")
title('Périodogramme Normalisé (TF fenêtre glissante)');

%% Transformée de Gabor

clear;
% Chargement des variables à partir du fichier SigDop.mat
data = load('SigPiano.mat'); % Charge toutes les variables

% Extraction des variables
signal = data.Sig; % Signal
Fe = data.Fe; % Fréquence d'échantillonnage

% Vérification des données chargées 
disp('Signal et fréquence d echantillonnage charges :');
disp(['Taille du signal : ', num2str(length(signal))]);
disp(['Fréquence d echantillonnage : ', num2str(Fe), ' Hz']);

% Définition des paramètres
LongFen = 1024; % Taille de la fenêtre de stationnarité
UnSurQ = 1; % Facteur d'échantillonnage des fenêtres 
M = LongFen; % Nombre de points pour la FFT )

% Découpage du signal en fenêtres de longueur LongFen
MatSig = Decoupe(signal, LongFen, UnSurQ); % Matrice de taille LongFen × P

% Calcul de la fenêtre d'apodisation (gaussienne)
win = FenetreApodisation('Gaussian',LongFen);

% On multiplie chaque segment par la fenêtre d'apodisation
MatSig = MatSig.*win';

% Application de la transformée de Fourier sur chaque fenêtre
MatFFT = fft(MatSig, M); % Matrice de taille M × P


% Calcul du périodogramme
Periogramme = abs(MatFFT).^2; % Matrice de taille M × P

PerioNormalise = NormSpec(Periogramme, 'M').*(Fe/M);

figure;
f = linspace(0,Fe,M); % Fréquences corrigées
idx = f <= 2000; % Index des fréquences jusqu'à 1000 Hz
imagesc(1:size(MatSig, 2), f(idx), PerioNormalise(idx, :));
colorbar;
xlabel('Fenêtres');
ylabel('Fréquences');
axis("xy")
title('Périodogramme Normalisé (Gabor)');

%% Transformée de Gabor inverse


% On obtient g(n_p, k) via ifft() sur chaque colonne du spectrogramme
g = ifft(Periogramme, [], 1); % Matrice de taille M × P

[k, P] = size(Periogramme); % Taille du périodogramme

% Initialiser la reconstruction
sigRecons = zeros(1, k);

for p_idx = 1:P
    num = sum(g(:,p_idx)); % Numérateur de la formule
    denom = sum(win); % Dénominateur de la formule
    sigRecons(p_idx) = num / denom; % Stockage de x_k
end

figure;
subplot(2,1,1)
t = (0:length(signal)-1) / Fe; % Temps associé au signal
plot(t, signal, 'b'); % Tracé du signal
xlabel('Temps (s)');
ylabel('Amplitude');
title('Signal temporel original');
grid on;

subplot(2,1,2)
t = (0:length(sigRecons)-1) / Fe; % Temps associé au signal
plot(t, sigRecons, 'b'); % Tracé du signal
xlabel('Temps (s)');
ylabel('Amplitude');
title('Signal temporel reconstruit (Inverse Gabor Transform)');
grid on;

%% Plot pour différentes tailles de fenêtre

% Définir les différentes tailles de fenêtre
window_sizes = [8, 32, 64, 256]; % Tailles de fenêtre à tester
colors = ['r', 'g', 'b', 'k']; % Couleurs pour les tracés

% Initialiser la figure
figure;
hold on;
legends = {};



for i = 1:length(window_sizes)
    LongFen = window_sizes(i); % Taille de la fenêtre courante
    M = LongFen; % Nombre de points pour la FFT

    % Découpage du signal en fenêtres de longueur LongFen
    MatSig = Decoupe(signal, LongFen, 1); % Matrice de taille LongFen × P

    % Calcul de la fenêtre d'apodisation (gaussienne)
    win = FenetreApodisation('Gaussian', LongFen);

    % On multiplie chaque segment par la fenêtre d'apodisation
    MatSig = MatSig .* win';

    % Application de la transformée de Fourier sur chaque fenêtre
    MatFFT = fft(MatSig, M); % Matrice de taille M × P

    % Calcul du périodogramme
    Periogramme = abs(MatFFT).^2; % Matrice de taille M × P
    PerioNormalise = NormSpec(abs(Periogramme), 'M') .* (Fe / M);

    % Inverse Transform
    g = ifft(MatFFT, [], 1); % Matrice de taille M × P
    [k, P] = size(MatFFT); % Taille du périodogramme

    % Reconstruction
    sigRecons = zeros(1, k);
    for p_idx = 1:P
        num = sum(g(:, p_idx)); % Numérateur de la formule
        denom = sum(win); % Dénominateur de la formule
        sigRecons(p_idx) = num / denom; % Stockage de x_k
    end

    % Temps associé
    t = (0:length(sigRecons) - 1) / Fe;

    % Tracé
    
    plot(t, sigRecons, colors(i), 'DisplayName', ['LongFen = ', num2str(LongFen)]);
    legends{end + 1} = ['LongFen = ', num2str(LongFen)];
end

% Finalisation du graphe
xlabel('Temps (s)');
ylabel('Amplitude');
title('Signal reconstruit pour différentes tailles de fenêtres');
grid on;
legend(legends);
hold off;

%% Transformée en ondelette

Type = 'Haar';
Par = 8;
L = 3;

qmf = MakeONFilter(Type,Par);


wc = FWT_PO(signal,L,qmf);

sigRecons = IWT_PO(wc,L,qmf);

figure;
f = (0:length(fft(signal))-1) / Fe; % Temps associé au signal
plot(f, fft(signal), 'b'); % Tracé du signal
xlabel('Fréquence (f)');
ylabel('Amplitude');
title('TF du signal');
grid on;

figure;
t = (0:length(wc)-1) / Fe; % Temps associé au signal
plot(t, wc, 'b'); % Tracé du signal
xlabel('Temps (s)');
ylabel('Amplitude');
title('Coefficients d ondelettes');
grid on;

figure;
t = (0:length(sigRecons)-1) / Fe; % Temps associé au signal
plot(t, sigRecons, 'b'); % Tracé du signal
xlabel('Temps (s)');
ylabel('Amplitude');
title('Signal temporel reconstruit (Inverse Wavelet Transform)');
grid on;




