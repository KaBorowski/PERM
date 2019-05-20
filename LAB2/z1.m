clear all;
% Parametry systemu
Fs = 1000;     % Cz�stotliwo�� pr�bkowania [Hz]
T = 1/Fs;      % Okres pr�bkowania [s]
L = 1000;      % D�ugo�� sygna�u (liczba pr�bek)
t = (0:L-1)*T; % Podstawa czasu
szum = 0;
odtwarzanie = 1;

% Przygotowanie sygna�u
N = 3;               % Liczba sinusoid w mieszaninie
A = [1   2  3] % Amplitudy kolejnych sinusoid
B = [ 1    2   3] % Cz�stotliwo�ci kolejnych sygna��w [Hz]
C = [  0 0 0] % Przesuni�cia fazowe kolejnych sygna��w


x = zeros(size(t));
d = zeros(size(t));
s = zeros(size(t));
if szum == 0 || odtwarzanie == 1
    for i = 1:N
      x = x + A(i) * cos(2 * pi * B(i) * t + C(i));
    end
    figure;
    plot(x)
    title('Sygna� x - bez szumu')
end

if szum == 1 || odtwarzanie == 1
    for i = 1:N
        s = s + A(i) * cos(2 * pi * B(i) * t + C(i)) + randn;
    end
    figure;
    plot(s)
    title('Sygna� x - z szumem')
end



if odtwarzanie == 1 || szum ==1
    Y = fft(s);
else
   Y = fft(x);     % transformata Fouriera
end



A = abs(Y);     % amplituda sygna�u
A = A/L;        % normalizacja amplitudy
A = A(1:L/2+1); % wyci�cie istotnej cz�ci spektrum
A(2:end-1) = 2*A(2:end-1)
% figure;
% plot(A)
% title('Amplituda');

F = angle(Y);   % faza sygna�u
F = F(1:L/2+1); % wyci�cie istotnej cz�ci spektrum
% figure;
% plot(F)
% title('Faza');

Z = sort(A);
y = Z(499:501)  % 3 najwi�ksze warto�ci amplitudy
    for i = 1:N
      d = d + y(i) * cos(2 * pi * B(i) * t + C(i));
    end
    figure;
    hold on;
    plot(s)
    plot(d)
    plot(x)
    title('Sygna� x - odtworzony')