function y = preprocess(x)
%  预处理输入 x
%    This function expects an input vector x.

% Generated by MATLAB(R) 9.13 and Signal Processing Toolbox 9.1.
% Generated on: 18-Dec-2022 19:20:47

y = detrend(x,'linear');

y = smoothdata(y,'movmean');

targetSampleRate = 50;
tx = 0:0.002:1.8;
y = resample(y,tx,targetSampleRate);