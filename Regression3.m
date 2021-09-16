clc;clear;close all

%% Input data
winequality = readtable('winequality-red.txt');

target = winequality.quality;
data = winequality(:,1:11).Variables;

% Normalize
data = data - mean(data,'omitnan');
data = data ./ std(data,'omitnan');
[n, m]= size(data);

% 3NN imputation for missing value
data = kNN_imputation( data, 3 );

%% SPCA, Regression, L times K-fold cross validation

% SPCA
exponent = 0:0.5:5;
n_e = length(exponent); % Number of exponent
n_pcs = m; % Maximun number of required principal components
eigenvalues = zeros(n_e,m); % Save the results of SPCA

for i = 1:n_e
    GetW = @(b1, e1, b2, e2)MyGetW_for_regression( target, exponent(i), b1, e1, b2, e2 );
    [ ~, D ] = BigdataSPCA( data, m, GetW );
    eigenvalues(i,:) = diag(D);
end

for i = 1:n_e
    subplot(3,4,i)
    plot(abs(eigenvalues(i,:)),'o-')
    yline(mean(abs(eigenvalues(i,:))),'-',['  ' num2str(round(mean(abs(eigenvalues(i,:)))),3)],...
        'Color',[0.8500, 0.3250, 0.0980],'LineWidth',2,...
        'LabelHorizontalAlignment','left','fontsize',12)
    yline(abs(eigenvalues(i,1))/10,'-',['  ' num2str(round(abs(eigenvalues(i,1))/10),3)],...
        'Color',[0.9290, 0.6940, 0.1250],'LineWidth',2,...
        'LabelHorizontalAlignment','left','fontsize',12)
    xlabel('Components','fontsize',12)
    legend('Eigenvalues','Kaiser rule','Conditional number rule','fontsize',12)
    title(['exponent = ' num2str(exponent(i))],'fontsize',12)
end