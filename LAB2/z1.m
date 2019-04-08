clear all;
% Parametry systemu
Fs = 1000;     % Czêstotliwoœæ próbkowania [Hz]
T = 1/Fs;      % Okres próbkowania [s]
L = 1000;      % D³ugoœæ sygna³u (liczba próbek)
t = (0:L-1)*T; % Podstawa czasu
szum = 0;
odtwarzanie = 1;

% Przygotowanie sygna³u
N = 3;               % Liczba sinusoid w mieszaninie
A = [1   2  3] % Amplitudy kolejnych sinusoid
B = [ 1    2   3] % Czêstotliwoœci kolejnych sygna³ów [Hz]
C = [  0 0 0] % Przesuniêcia fazowe kolejnych sygna³ów


x = zeros(size(t));
d = zeros(size(t));
s = zeros(size(t));
if szum == 0 || odtwarzanie == 1
    for i = 1:N
      x = x + A(i) * cos(2 * pi * B(i) * t + C(i));
    end
    figure;
    plot(x)
    title('Sygna³ x - bez szumu')
end

if szum == 1 || odtwarzanie == 1
    for i = 1:N
        s = s + A(i) * cos(2 * pi * B(i) * t + C(i)) + randn;
    end
    figure;
    plot(s)
    title('Sygna³ x - z szumem')
end



if odtwarzanie == 1 || szum ==1
    Y = fft(s);
else
   Y = fft(x);     % transformata Fouriera
end



A = abs(Y);     % amplituda sygna³u
A = A/L;        % normalizacja amplitudy
A = A(1:L/2+1); % wyciêcie istotnej czêœci spektrum
A(2:end-1) = 2*A(2:end-1)
% figure;
% plot(A)
% title('Amplituda');

F = angle(Y);   % faza sygna³u
F = F(1:L/2+1); % wyciêcie istotnej czêœci spektrum
% figure;
% plot(F)
% title('Faza');

Z = sort(A);
y = Z(499:501)  % 3 najwiêksze wartoœci amplitudy
    for i = 1:N
      d = d + y(i) * cos(2 * pi * B(i) * t + C(i));
    end
    figure;
    hold on;
    plot(s)
    plot(d)
    plot(x)
    title('Sygna³ x - odtworzony')