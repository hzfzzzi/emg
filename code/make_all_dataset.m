%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
%s1train = load('subject1Train.mat');
%s1test = load('subject1Test.mat');
s2train = load('subject2Train.mat');
s2test = load('subject2Test.mat');
s3train = load('subject3Train.mat');
s3test = load('subject3Test.mat');
s4train = load('subject4Train.mat');
s4test = load('subject4Test.mat');
s5train = load('subject5Train.mat');
s5test = load('subject5Test.mat');

%sum all data
XTrain = [s2train.XTrain;s3train.XTrain;s4train.XTrain;s5train.XTrain];
YTrain = [s2train.YTrain;s3train.YTrain;s4train.YTrain;s5train.YTrain];
YTrain_ts = [s2train.YTrain_ts;s3train.YTrain_ts;s4train.YTrain_ts;s5train.YTrain_ts];

XTest = [s2test.XTest;s3test.XTest;s4test.XTest;s5test.XTest];
YTest = [s2test.YTest;s3test.YTest;s4test.YTest;s5test.YTest];
YTest_ts = [s2test.YTest_ts;s3test.YTest_ts;s4test.YTest_ts;s5test.YTest_ts];
