[e1,l1] = pre_process(5,true);
[e2,l2] = pre_process(5,false);
e = [e1;e2];
l = [l1;l2];
e = e(:,:,1500:3001);
f1 = feature_extrationV2(e);
f2 = feature_extrationV4(f1);
f3 = feature_extrationV5(f2);
l_ts = l;
l = categorical(l);
ee = num2cell(f3,[2 3]);

train_test_rate = 0.7; 
e_size = size(e,1);
train_size = round(train_test_rate*e_size);
test_size = e_size-train_size;

XTrain = cell(train_size,1);
YTrain = l(1:train_size);
YTrain_ts = cell(train_size,1);
XTest = cell(test_size,1);
YTest = l(train_size+1:e_size);
YTest_ts = cell(test_size,1);
for i = 1:train_size
     XTrain{i,:} = squeeze(ee{i});
     Label = l_ts(i).*ones(1,150);
     YTrain_ts{i,:} = categorical(Label);
end
for i = train_size+1:e_size
    XTest{i-train_size,:} = squeeze(ee{i});
    Label = l_ts(i).*ones(1,150);
    YTest_ts{i-train_size,:} = categorical(Label);
end
save('subject5Train1.mat','XTrain','YTrain','YTrain_ts')
save('subject5Test1.mat','XTest','YTest','YTest_ts')