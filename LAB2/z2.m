% x - nagranie
% Fs - cz�stotliwo�� pr�bkowania
[x, Fs] = audioread('funf.wav');
plot(x)
% x - sygna� 
% 128 - d�ugo�� okna analizy
% 64 - nak�adanie pomi�dzy kolejnymi oknami
% [] - ilo�� punkt�w FFT na okno (domy�lnie)
% Fs - cz�stotliwo�� pr�bkowania sygna�u
% 'yaxis' - cz�totliwo�ci na osi y, czas na osi x
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

%%%%%%wraz ze wzrostem d�ugo�ci okna rozdzielczo�� spektrogramu spada