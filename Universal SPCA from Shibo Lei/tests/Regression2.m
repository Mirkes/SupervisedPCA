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
V = cell(n_pcs,n_e);    % Save the results of SPCA

for i = 1:n_pcs
    for j = 1:n_e
        GetW = @(b1, e1, b2, e2)MyGetW_for_regression( target, exponent(j), b1, e1, b2, e2 );
        [ V{i,j}, ~ ] = BigdataSPCA( data, i, GetW );
    end
end

%L times K-fold cross validation
L = 10;
K = 10;
% Save all results
overall_MSE_training_set = cell(n_pcs,n_e);
overall_MSE_test_set = cell(n_pcs,n_e);
% Split data for L times K-fold cross validation
label_10fcv = randi([1 K],n,L);

for l = 1:L     % L times
    l   % Progress bar
    tmp_label_10fcv = label_10fcv(:,l); % Split data
    
    for k = 1:K     % K-fold cross validation
        % Determine training set and test set
        label_set = tmp_label_10fcv == k;
        n_test_set = sum(label_set);    % Length of test set
        training_set = data(~label_set,:);
        test_set = data(label_set,:);
        training_target = target(~label_set,:);
        test_target = target(label_set,:);
        
        for i = 1:n_pcs	% The loop about the exponent
            for j = 1:n_e	% The loop about the number of required principal components
                % Result of SPCA
                projection = training_set * V{i,j};
                % Regression
                [b,bint,r] = regress(training_target, [projection ones(n-n_test_set,1)]);
                
                % MSE of the training set
                overall_MSE_training_set{i,j}(l,k) = mean(r.^2);
                projection = test_set * V{i,j};
                r = test_target - ( projection * b(1:end-1) + b(end) );
                
                % MSE of the test set
                overall_MSE_test_set{i,j}(l,k) = mean(r.^2);
                
            end
        end
    end
end

% Mean of MSE
MSE_training_set = zeros(n_pcs,n_e);
MSE_test_set = zeros(n_pcs,n_e);
% Variance of MSE
Var_MSE_training_set = zeros(n_pcs,n_e);
Var_MSE_test_set = zeros(n_pcs,n_e);

for i = 1:n_pcs
    for j = 1:n_e
        % Mean of MSE
        MSE_training_set(i,j) = mean(overall_MSE_training_set{i,j},'all');
        MSE_test_set(i,j) = mean(overall_MSE_test_set{i,j},'all');
        % Variance of MSE
        Var_MSE_training_set(i,j) = var(overall_MSE_training_set{i,j},0,'all');
        Var_MSE_test_set(i,j) = var(overall_MSE_test_set{i,j},0,'all');
    end
end

ftest_for_MSE = zeros(n_pcs-1,n_e);
for i = 1:n_pcs-1
    for j = 1:n_e
        dfF = round(0.9*n)-j-2;
        f_statistics = (MSE_training_set(i,j)-MSE_training_set(i+1,j))/...
            MSE_training_set(i+1,j)*dfF;
        ftest_for_MSE(i,j) = 1 - fcdf(f_statistics,1,dfF);
    end
end

ttest_for_MSE = zeros(n_pcs-1,n_e);
for i = 1:n_pcs-1
    for j = 1:n_e
        [H,ttest_for_MSE(i,j),CI,STATS] = ...
            ttest2(overall_MSE_training_set{i,j}(:),overall_MSE_training_set{i+1,j}(:));
    end
end
