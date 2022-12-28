[e,l] = pre_process(5,true);
f = feature_extration(e);
% load data\AllDFLStepData.mat
% x = 1:1:3001;
% y1 = AllDFLStepData(4).DFLStepDataSet_Calib(1).DFLData(30).EMG(1,:);
% plot(x,y1)
pre_acc = zeros(1,200);
for j = 1:1:200
    f1 = f(:,j.*2,:);
    X = squeeze(f1);
    Y = l;
    
    classOrder = unique(Y);
    t = templateSVM('Standardize',true);
    PMdl = fitcecoc(X,Y,'Holdout',0.34,'Learners',t,'ClassNames',classOrder);
    Mdl = PMdl.Trained{1};
    
    testInds = test(PMdl.Partition);  % Extract the test indices
    XTest = X(testInds,:);
    YTest = Y(testInds,:);
    labels = predict(Mdl,XTest);
    
    idx = randsample(sum(testInds),20);
    table(YTest(idx),labels(idx),...
        'VariableNames',{'TrueLabels','PredictedLabels'});
    acc = 0;
    for i = idx'
        if labels(i) == YTest(i)
            acc = acc+1;
        end
    end
    pre_acc(1,j) = acc./20;

end

x = 1:1:200;
plot(x,pre_acc)
subject5_f = f;
save subject5_f