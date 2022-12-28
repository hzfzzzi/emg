[e,l] = pre_process(3,true);
f = feature_extrationV2(e);

ee = num2cell(e,[2 3]);
XTrain = cell(40,1);
YTrain = cell(40,1);
XTest = cell(20,1);
YTest = cell(20,1);
for i = 1:40
     XTrain{i,:} = squeeze(ee{i});
     Label = l(i).*ones(1,3001);
     YTrain{i,:} = categorical(Label);
end
for i = 41:60
    XTest{i-40,:} = squeeze(ee{i});
    Label = l(i).*ones(1,3001);
    YTest{i-40,:} = categorical(Label);
end
save('subject3Train1.mat','XTrain','YTrain')
save('subject3Test1.mat','XTest','YTest')