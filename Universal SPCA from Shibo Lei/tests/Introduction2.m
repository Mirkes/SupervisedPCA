clc;clear;close all
%%  Create the dataset
n1 = 100;
n2 = 100;
data1 = [(1:n1)'/n1-0.5 zeros(n1,1) zeros(n1,1)] + randn(n1,3)/20;
data2 = [zeros(n2,1) (1:n2)'/n2-0.5 ones(n2,1)] + randn(n2,3)/20;
data = [data1; data2];
data = zscore(data);
data1 = data(1:n1,:);
data2 = data(n1+1:end,:);
subplot(2,2,[1 2])
scatter3(data1(:,1),data1(:,2),data1(:,3))
hold on
scatter3(data2(:,1),data2(:,2),data2(:,3))
xlabel('x','fontsize',12)
ylabel('y','fontsize',12)
zlabel('z','fontsize',12,'Rotation',0)
legend('Class 1','Class 2','fontsize',12)
title('Dataset for classification','fontsize',12)
%%  PCA
[ V, ~ ] = eigs(data'*data,2);
projection1 = data1*V;
projection2 = data2*V;
subplot(2,2,3)
scatter(projection1(:,1),projection1(:,2))
hold on
scatter(projection2(:,1),projection2(:,2))
xlabel('C1','fontsize',12)
ylabel('C2','fontsize',12,'Rotation',0)
legend('Class 1','Class 2','fontsize',12)
title('The PCA projection','fontsize',12)
%%  SPCA
labels = [zeros(n1,1); ones(n2,1)];
reduced_W = [-1 1;
             1 -1];
[ V, ~ ] = ClassSPCA(data, labels, 2, reduced_W);
projection1 = data1*V;
projection2 = data2*V;
subplot(2,2,4)
scatter(projection1(:,1),projection1(:,2))
hold on
scatter(projection2(:,1),projection2(:,2))
xlabel('C1','fontsize',12)
ylabel('C2','fontsize',12,'Rotation',0)
legend('Class 1','Class 2','fontsize',12)
title('The SPCA projection','fontsize',12)