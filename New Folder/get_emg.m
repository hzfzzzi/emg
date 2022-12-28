function [emg,label] = get_emg(subject_id,is_ca)
%%%
%input parameters:
% subject_id:subject from 1 to 5
% is_ca: if true,get CA dataset;else get VR dataset

%output parameters:
% emg signal:shape[session,channel,timestamp]

% label:shape[session,value]
%%%
    load data\AllDFLStepData.mat
    if is_ca
        session = 2;
    else
        session = 3;
    end
    repeat = 30;
    emg = zeros(30.*             session,4,3001);
    label = zeros(30.*session,1);
    if is_ca
        for s = 1:session
            for r = 1:repeat
                for c = 1:4
                    emg(30*(s-1)+r,c,:) = AllDFLStepData(subject_id).DFLStepDataSet_Calib(s).DFLData(r).EMG(c,:);
                end
                
                label(30*(s-1)+r,:) = AllDFLStepData(subject_id).DFLStepDataSet_Calib(s).CueLabels(r);              
            end
        end
    else
        for s = 1:session
            for r = 1:repeat
                for c = 1:4
                    emg(30*(s-1)+r,c,:) = AllDFLStepData(subject_id).DFLStepDataSet_VR(s).DFLData(r).EMG(c,:);
                end
                
                label(30*(s-1)+r,:) = AllDFLStepData(subject_id).DFLStepDataSet_VR(s).CueLabels(r);              
            end
        end
    end
end
