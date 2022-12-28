[e,l1] = pre_process(3,true);
[e,l2] =   (3,false);
l = cat(1,l1,l2);
%f = feature_extrationV3(e);
load f.mat
load f2.mat
f = cat(1,f,f2);
lgraph = layerGraph();

tempLayers = [
    imageInputLayer([4 500 1],"Name","imageinput1")
    convolution2dLayer([4 4],1,"Name","conv1","Padding","same","Stride",[1 32])
    reluLayer("Name","relu_4")
    flattenLayer("Name","flatten1")];
lgraph = addLayers(lgraph,tempLayers);

tempLayers = [
    imageInputLayer([4 250 1],"Name","imageinput2")
    convolution2dLayer([4 4],1,"Name","conv2","Padding","same","Stride",[1 16])
    reluLayer("Name","relu_1")
    flattenLayer("Name","flatten2")];
lgraph = addLayers(lgraph,tempLayers);

tempLayers = [
    imageInputLayer([4 125 1],"Name","imageinput3")
    convolution2dLayer([4 4],2,"Name","conv3","Padding","same","Stride",[1 8])
    reluLayer("Name","relu_2")
    flattenLayer("Name","flatten3")];
lgraph = addLayers(lgraph,tempLayers);

tempLayers = [
    imageInputLayer([4 125 1],"Name","imageinput4")
    convolution2dLayer([4 4],4,"Name","conv4","Padding","same","Stride",[1 4])
    reluLayer("Name","relu_3")
    flattenLayer("Name","flatten4")];
lgraph = addLayers(lgraph,tempLayers);

tempLayers = [
    concatenationLayer(1,4,"Name","concat")
    layerNormalizationLayer("Name","layernorm")
    fullyConnectedLayer(3,"Name","fc2")
    dropoutLayer(0.5,"Name","dropout")
    reluLayer("Name","relu_5")
    softmaxLayer("Name","softmax")
    classificationLayer("Name","classoutput")];
lgraph = addLayers(lgraph,tempLayers);

% 清理辅助变量
clear tempLayers;
lgraph = connectLayers(lgraph,"flatten4","concat/in4");
lgraph = connectLayers(lgraph,"flatten3","concat/in3");
lgraph = connectLayers(lgraph,"flatten1","concat/in1");
lgraph = connectLayers(lgraph,"flatten2","concat/in2");

options = trainingOptions('sgdm', ...
    'MaxEpochs',20, ...
    'GradientThreshold',2, ...
    'Verbose',0, ...
    'Plots','none');


test_acc = zeros(400,1);
train_acc = zeros(400,1);
for i = 1:400
    i
    Xtrain = f(1:120,i,:,:);
    ltrain = l(1:120);
    Xtrain = permute(Xtrain,[3 4 2 1]);
    X1Train = Xtrain(:,1:500,:,:);
    X2Train = Xtrain(:,501:750,:,:);
    X3Train = Xtrain(:,751:875,:,:);
    X4Train = Xtrain(:,876:1000,:,:);
    TTrain = categorical(ltrain);
    dsX1Train = arrayDatastore(X1Train,IterationDimension=4);
    dsX2Train = arrayDatastore(X2Train,IterationDimension=4);
    dsX3Train = arrayDatastore(X3Train,IterationDimension=4);
    dsX4Train = arrayDatastore(X4Train,IterationDimension=4);
    dsTTrain = arrayDatastore(TTrain);
    dsTrain = combine(dsX1Train,dsX2Train,dsX3Train,dsX4Train,dsTTrain);
    
    Xtest = f(121:150,i,:,:);
    ltest = l(121:150);
    Xtest = permute(Xtest,[3 4 2 1]);
    X1Test = Xtest(:,1:500,:,:);
    X2Test = Xtest(:,501:750,:,:);
    X3Test = Xtest(:,751:875,:,:);
    X4Test = Xtest(:,876:1000,:,:);
    TTest = categorical(ltest);
    dsX1Test = arrayDatastore(X1Test,IterationDimension=4);
    dsX2Test = arrayDatastore(X2Test,IterationDimension=4);
    dsX3Test = arrayDatastore(X3Test,IterationDimension=4);
    dsX4Test = arrayDatastore(X4Test,IterationDimension=4);
    dsTTest = arrayDatastore(TTest);
    dsTest = combine(dsX1Test,dsX2Test,dsX3Test,dsX4Test,dsTTest);
    
    [net,info] = trainNetwork(dsTrain,lgraph,options);
    
    Ypre = classify(net,dsTest);
    train_acc(i) = max(info.TrainingAccuracy)
    test_acc(i) = sum(Ypre == TTest)/numel(TTest)
end
subplot(2,1,1)
plot(test_acc)
subplot(2,1,2)
plot(train_acc)
% figure
% confusionchart(TTest,Ypre)