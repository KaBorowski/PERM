% x - nagranie
% Fs - częstotliwość próbkowania
[x, Fs] = audioread('funf.wav');
plot(x)
% x - sygnał 
% 128 - długość okna analizy
% 64 - nakładanie pomiędzy kolejnymi oknami
% [] - ilość punktów FFT na okno (domyślnie)
% Fs - częstotliwość próbkowania sygnału
% 'yaxis' - czętotliwości na osi y, czas na osi x
figure;
spectrogram(x, 1024, 64, [], Fs, 'yaxis');
title('window = 1024, n = 64');
figure;
spectrogram(x, 2, 0, [], Fs, 'yaxis');
title('window = 2, n = 0');
figure;
spectrogram(x, 1024, 0, [], Fs, 'yaxis');
title('window = 1024, n = 0');
figure;
spectrogram(x, 1024, 512, [], Fs, 'yaxis');
title('window = 1024, n = 512');

%%%%%%wraz ze wzrostem długości okna rozdzielczość spektrogramu spada