function [out_feature_data] = feature_extrationV3(emg)
    num_session = size(emg,1);
    channel = 4;
    %flit,square,smooth
    filt = designfilt('highpassfir','StopbandFrequency',15, ...
                    'PassbandFrequency',30,'StopbandAttenuation',60,'PassbandRipple',1, ...
                    'SampleRate',500);
    smooth_window = 5;
    time_step = 5;
    window_len = 1000;
    count = (3000-window_len)./time_step;
    out_feature_data = zeros(num_session,count,channel,window_len+1);
    for i = 1:num_session
        for j = 1:count
            sub_emg = emg(i,:,1+5.*(j-1):window_len+1+5.*(j-1));
            for k = 1:channel
                e = sub_emg(:,k,:);
                e = squeeze(e);
                e = filtfilt(filt,e');
                e = e.^2;
                e = smoothdata(e,'movmean',smooth_window);
                out_feature_data(i,j,k,:) = e;
            end
        end
    end
end
