function [feature_data] = feature_extrationV2(emg)
%this only for high pass filter 
    num_session = size(emg,1);
    seq_len = size(emg,3);
    channel = size(emg,2);
    feature_data = zeros(num_session,channel,seq_len);
    %flit,square,smooth
    filt = designfilt('highpassfir','StopbandFrequency',15, ...
                    'PassbandFrequency',30,'StopbandAttenuation',60,'PassbandRipple',1, ...
                    'SampleRate',500);
    for i = 1:num_session
        for j = 1:channel
            e = emg(i,j,:);
            e = squeeze(e);
            e = filtfilt(filt,e');
            feature_data(i,j,:) = e;
        end
    end
end
