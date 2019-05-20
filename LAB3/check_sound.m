function command = check_sound(sound)
%%

go_count=0;
stop_count=0;
run_count=0;

add_basic_commands();
sound_size=size(sound);
sound_size=sound_size/32;

sound_spect=spectrogram(sound, sound_size(1), 0);
sound_spect=abs(sound_spect);

sizee=size(sound_spect);
disp(sizee(2));
for i = 31:0.2:33
    if sizee(2) ~= 31
        sound_size=size(sound);
        sound_size=sound_size/i;
        sound_spect=spectrogram(sound, sound_size(1), 0);
        sound_spect=abs(sound_spect);
        sizee=size(sound_spect);
    end
end

sound_spect_log=log(sound_spect);
E_sound = mean(sound_spect);
disp(size(E_sound));
E_sound_log = mean(sound_spect_log);

%% DTW
cmp_go = dtw(E_sound, E_go);
cmp_run = dtw(E_sound, E_run);
cmp_stop = dtw(E_sound, E_stop);

result = min([cmp_go, cmp_run, cmp_stop]);

if result == cmp_go
    go_count=go_count+1;
end
if result == cmp_run
    run_count=run_count+1;
end
if result == cmp_stop
    stop_count=stop_count+1;
end

%% DTW LOG

cmp_go = dtw(E_sound_log, E_go_log);
cmp_run = dtw(E_sound_log, E_run_log);
cmp_stop = dtw(E_sound_log, E_stop_log);

result = min([cmp_go, cmp_run, cmp_stop]);

if result == cmp_go
    go_count=go_count+1;
end
if result == cmp_run
    run_count=run_count+1;
end
if result == cmp_stop
    stop_count=stop_count+1;
end

%% GDF   Ground distance between two vectors

cmp_go = norm(E_sound - E_go, 2);
cmp_run = norm(E_sound - E_run, 2);
cmp_stop = norm(E_sound - E_stop, 2);

result = min([cmp_go, cmp_run, cmp_stop]);

if result == cmp_go
    go_count=go_count+1;
end
if result == cmp_run
    run_count=run_count+1;
end
if result == cmp_stop
    stop_count=stop_count+1;
end

%% GDF LOG Ground distance between two vectors

% cmp_go = norm(E_sound_log - E_go_log, 2);
% cmp_run = norm(E_sound_log - E_run_log, 2);
% cmp_stop = norm(E_sound_log - E_stop_log, 2);
% 
% result = min([cmp_go, cmp_run, cmp_stop]);
% 
% if result == cmp_go
%     go_count=go_count+1;
% end
% if result == cmp_run
%     run_count=run_count+1;
% end
% if result == cmp_stop
%     stop_count=stop_count+1;
% end

%% Compare results

result = max([go_count, run_count, stop_count]);

if result == go_count && (result == run_count || result == stop_count)
    command='Compare failed';
    return;
end
if result == run_count && (result == go_count || result == stop_count)
    command='Compare failed';
    return;
end
if result == stop_count && (result == go_count || result == run_count)
    command='Compare failed';
    return;
end

if result == go_count
    command='GO';
end
if result == run_count
    command='RUN';
end
if result == stop_count
    command='STOP';
end


end

