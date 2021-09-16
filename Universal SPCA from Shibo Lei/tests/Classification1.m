clc;clear;close all
%%  Input the dataset
Data_wdbc = importdata('wdbc.data');
labels = char(Data_wdbc.textdata(:,2))=='M';
data = Data_wdbc.data;
n = length(data);
data = zscore(data);    % Normalise
%%  SPCA
reduced_W = [-2 1; 1 -2];
[ V, D ] = ClassSPCA( data, labels, 30, reduced_W );
%% Plot
plot(abs(diag(D)),'o-','LineWidth',1,'MarkerSize',6)
yline(mean(abs(diag(D))),'-',['  ' num2str(round(mean(abs(diag(D)))),3)],...
    'Color',[0.8500, 0.3250, 0.0980],'LineWidth',2,...
    'LabelHorizontalAlignment','left',...
    'LabelVerticalAlignment','bottom','fontsize',12)
yline(D(1,1)/10,'-',['  ' num2str(round(D(1,1)/10),3)],...
    'Color',[0.9290, 0.6940, 0.1250],'LineWidth',2,...
    'LabelHorizontalAlignment','left','fontsize',12)
xlabel('Components','fontsize',12)
legend('Eigenvalues','Kaiser rule','Conditional number rule','fontsize',12)
