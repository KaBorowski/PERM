Fs = 200000;
t = (0:length(syg)-1)/Fs;
Wn = 0.4; %cut-off freq.
N = 50;   %

bhi = fir1(N,Wn,'high',chebwin(N+1,50));
freqz(bhi,1)
outhi = filter(bhi,1,syg);

subplot(3,1,1)
plot(t,syg)
title('Original Signal')

subplot(3,1,2)
plot(t,outhi)
title('Highpass Filtered Signal')
xlabel('Time (s)')

subplot(3,1,3)
spectrogram(outhi, 128, 64, [], Fs, 'yaxis')