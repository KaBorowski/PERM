
load('sounds.mat');

GO=go{4};
STOP=stop{4};
RUN=run{4};

GO_size=size(GO);
GO_size=GO_size/32;
go_spect=spectrogram(GO, GO_size(1), 0);
go_spect=abs(go_spect);
% figure;
% imagesc(go_spect);
go_spect_log=log(go_spect);
% figure;
% imagesc(go_spect_log);
E_go = mean(go_spect);
E_go_log = mean(go_spect_log);
% figure;
% plot(E_go);

RUN_size=size(RUN);
RUN_size=RUN_size/32;
run_spect=spectrogram(RUN, RUN_size(1), 0);
run_spect=abs(run_spect);
% figure;
% imagesc(run_spect);
run_spect_log=log(run_spect);
% figure;
% imagesc(run_spect_log);
E_run = mean(run_spect);
E_run_log = mean(run_spect_log);
% figure;
% plot(E_run);

STOP_size=size(STOP);
STOP_size=STOP_size/31;
stop_spect=spectrogram(STOP, STOP_size(1), 0);
stop_spect=abs(stop_spect);
% figure;
% imagesc(stop_spect);
stop_spect_log=log(stop_spect);
% figure;
% imagesc(stop_spect_log);
E_stop = mean(stop_spect);
E_stop_log = mean(stop_spect_log);
% figure;
% plot(E_stop);