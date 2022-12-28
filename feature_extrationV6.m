function feature_data = feature_extrationV6(emg)
    num_session = size(emg,1);
    seq_len = size(emg,3);
    channel = size(emg,2);
    targetSampleRate = 50;
    feature_data = zeros(num_session,channel,round(seq_len/(500/targetSampleRate)+1));
    for i = 1:num_session
        for j = 1:channel
            feature_data(i,j,:) = preprocess(squeeze(emg(i,j,:)));
        end
    end
end