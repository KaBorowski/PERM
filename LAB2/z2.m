% x - nagranie
% Fs - czêstotliwoœæ próbkowania
[x, Fs] = audioread('funf.wav');
plot(x)
% x - sygna³ 
% 128 - d³ugoœæ okna analizy
% 64 - nak³adanie pomiêdzy kolejnymi oknami
% [] - iloœæ punktów FFT na okno (domyœlnie)
% Fs - czêstotliwoœæ próbkowania sygna³u
% 'yaxis' - czêtotliwoœci na osi y, czas na osi x
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

%%%%%%wraz ze wzrostem d³ugoœci okna rozdzielczoœæ spektrogramu spada