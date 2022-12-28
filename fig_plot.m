%% 0.得到原始EMG索引
load data\AllDFLStepData.mat
subject = 5;
session = 2;%2 for CA,3 for Game
repeat = 30;
emg = AllDFLStepData(subject).DFLStepDataSet_Calib(session).DFLData(repeat).EMG;
label = AllDFLStepData(subject).DFLStepDataSet_Calib(session).CueLabels(repeat);
cue = 1501; %motion onset is the 1501 timestep
%% 1.分出时间窗口  [t0-2s t0], [t0-1s t0], [t0-500ms t0], [t0-250ms t0].
t1 = 1001;
win1 = 1000;
win2 = 500;
win3 = 250;
win4 = 125;
p = (1:1:t1);
win1_emg = emg(:,t1-win1:t1);
win2_emg = emg(:,t1-win2:t1);
win3_emg = emg(:,t1-win3:t1);
win4_emg = emg(:,t1-win4:t1);
%plot raw emg
subplot(4,4,1)
plot(p,win1_emg(1,:))
title('raw emg')
subplot(4,4,5)
plot(p,win1_emg(2,:))
subplot(4,4,9)
plot(p,win1_emg(3,:))
subplot(4,4,13)
plot(p,win1_emg(4,:))
%% 2.求instantaneous AC power time-series
% 2.1 0相位高通滤波(15Hz)
filt = designfilt('highpassfir','StopbandFrequency',15,'PassbandFrequency',30,'StopbandAttenuation',60,'PassbandRipple',1,'SampleRate',500);
filt_emg1 = filtfilt(filt,win1_emg(1,:));
filt_emg2 = filtfilt(filt,win1_emg(2,:));
filt_emg3 = filtfilt(filt,win1_emg(3,:));
filt_emg4 = filtfilt(filt,win1_emg(4,:));
subplot(4,4,2)
plot(p,filt_emg1);
title('filted emg')
subplot(4,4,6)
plot(p,filt_emg2);
subplot(4,4,10)
plot(p,filt_emg3);
subplot(4,4,14)
plot(p,filt_emg4);
% 2.2 平方
sqrt_emg1 = filt_emg1.^2;
sqrt_emg2 = filt_emg2.^2;
sqrt_emg3 = filt_emg3.^2;
sqrt_emg4 = filt_emg4.^2;
subplot(4,4,3)
plot(p,sqrt_emg1);
title('sqrted emg')
subplot(4,4,7)
plot(p,sqrt_emg2);
subplot(4,4,11)
plot(p,sqrt_emg3);
subplot(4,4,15)
plot(p,sqrt_emg4);
% 2.3 10ms窗口平滑
smooth_win = 5;
smooth_emg1 = smoothdata(sqrt_emg1,'movmean',smooth_win);
smooth_emg2 = smoothdata(sqrt_emg2,'movmean',smooth_win);
smooth_emg3 = smoothdata(sqrt_emg3,'movmean',smooth_win);
smooth_emg4 = smoothdata(sqrt_emg4,'movmean',smooth_win);
subplot(4,4,4)
plot(p,smooth_emg1);
title('smoothed emg')
subplot(4,4,8)
plot(p,smooth_emg2);
subplot(4,4,12)
plot(p,smooth_emg3);
subplot(4,4,16)
plot(p,smooth_emg4);
%% 3. 2阶多项式拟合 cure-fitting toolbox
fitted_weight = fit(p',smooth_emg1','poly2');
p1 = fitted_weight.p1;
p2 = fitted_weight.p2;
p3 = fitted_weight.p3;
p_mat = [p1 p2 p3];
%% 4.划分训练数据/测试数据
%3折交叉验证
%% 5.ECOC SVM  Statistics and Machine Learning Toolbox