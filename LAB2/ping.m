file = load('syg.mat');
syg = file.syg;
V_sound = 340.3;% [m/s]
error = 0.3;
window=32;
f = 200000;% [kHz]
 
syg_size = size(syg);
window_size = syg_size(1)/window; %32 okna 

spect = spectrogram(syg, window_size, 0);
spect = abs(spect);
E_syg = mean(log(spect));

average = mean(E_syg);
limit = average - srednia*error;

for i=1:window
    if E_syg(i) > limit
        response_window = i;
        break;
    end
end

response_time = response_window * window_size / f;
distance = response_time * V_sound / 2;

disp(strcat('Distance = ', num2str(distance), ' m'));





