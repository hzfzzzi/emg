function [feature_data2] = feature_extrationV4(emg)
%this use curve-fitting 
    num_session = size(emg,1);
    seq_len = size(emg,3);
    channel = size(emg,2);
    slide_window = 10;%20ms
    feature_data2 = zeros(num_session,12,150);
    x = 1:slide_window;
    for i = 1:num_session
        %emg(i,:,:) = normalize(emg(i,:,:),2);
        cnt = 1;
        for k = slide_window+1:slide_window:seq_len
            temp = zeros(4,3);
            for j = 1:channel
                e = emg(i,j,k-slide_window:k-1);
                e = squeeze(e);
                fitted_weight = fit(x',e,'poly2');
                temp(j,:) = [fitted_weight.p1 fitted_weight.p2 fitted_weight.p3];
            end
            temp = reshape(temp,[12 1]);
            feature_data2(i,:,cnt) = temp;
            cnt = cnt+1;
        end
    end
end
