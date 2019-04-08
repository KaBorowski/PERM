
    X=run{1};
    sizee=size(X);
    sizee=sizee/32;
    s_run=spectrogram(X, sizee(1), 0);
    s_run=abs(s_run);
%     figure;
%     imagesc(s_run);
    s_run3_log=log(s_run);
%     figure;
%     imagesc(s_run3_log);
    E_run3 = mean(s_run);
    E_run3_log = mean(s_run3_log);
%     figure;
%     plot(E_run);
