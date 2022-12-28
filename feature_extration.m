function [feature_data] = feature_extration(emg)
    num_session = 60;
    feature_data = zeros(num_session,400,48);
    channel = 4;
    cue = 1501; %motion onset is the 1501 timestep
    win1 = 1000;
    win2 = 500;
    win3 = 250;
    win4 = 125;
    win_list = [win1 win2 win3 win4];
    t0_start = 1001;
    t0_end = 3001;
    slide_window = 5;%10ms
    smooth_window = 5;
    filt = designfilt('highpassfir','StopbandFrequency',15, ...
                    'PassbandFrequency',30,'StopbandAttenuation',60,'PassbandRipple',1, ...
                    'SampleRate',500);
    for i = 1:num_session
        for j = 1:channel
            e = emg(i,j,:);
            e = squeeze(e);
            e = filtfilt(filt,e');
            e = e.^2;
            emg(i,j,:) = e;
        end
    end
    for s = 1:num_session
        s
        f0 = zeros(400,48);
        i = 1;
        for t1 =t0_start:slide_window:t0_end
            f1 = zeros(4,4,3);
            ii = 1;
            for w = win_list
                x = 1:1:w+1;
                w_emg = emg(s,:,t1-w:t1);
                w_emg = squeeze(w_emg);
                f2 = zeros(4,3);
                for c = 1:channel
                    c_emg = w_emg(c,:);
                    smooth_emg = smoothdata(c_emg,'movmean',smooth_window);
                    f2(c,:) = curve_fitting(smooth_emg,w);
                end
                f1(ii,:) = reshape(f2,[1,12]);
                ii = ii+1;
            end
            f1 = reshape(f1,[48,1]);
            feature_data(s,i,:) = f1;
            i = i+1;
        end
    end
end