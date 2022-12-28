load s5f.mat
[e,l] = pre_process(5,true);
% X1 = squeeze(f(:,1,:));
% X100 = squeeze(f(:,250,:));
% X200 = squeeze(f(:,200,:));
% X400 = squeeze(f(:,400,:));
% X2 = reshape(e(:,:,1:1001),[60,4004]);
p = zeros(400,1);
for i = 1:1:400
    i
    X = squeeze(f(:,i,:));
    h = zeros(10,1);
    for j = 1:1:10
        [trainedClassifier, h(j)] = trainClassifier(X,l);
    end
    p(i) = mean(h);
end
%histogram(h)
plot(p)