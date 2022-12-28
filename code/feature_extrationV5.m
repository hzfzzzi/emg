function [feature_data3] = feature_extrationV5(emg)
%this use pca 
    num_session = size(emg,1);
    time_window = size(emg,3);
    feature_data3 = zeros(num_session,3,time_window);
    for i = 1:num_session
        temp = squeeze(emg(i,:,:));
        temp = temp';
        [coeff,score,latent,tsquared] = pca(temp);
        filted_data = score(:,1:3);
        feature_data3(i,:,:) = filted_data';
    end
end
