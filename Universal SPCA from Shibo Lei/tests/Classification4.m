clc;clear;close all
%%  Input the dataset
Data_wdbc = importdata('wdbc.data');
labels = char(Data_wdbc.textdata(:,2))=='M';
data = Data_wdbc.data;
n = length(data);
data = zscore(data);    % Normalise
%%
accuracy_training = zeros(4,8);
accuracy_test = zeros(4,8);
for t = 1:10   % 10 times
    labels_10times = randi([1 10],n,1);
    for f = 1:10   % 10 fold
        % Assign training set and test set
        labels_10fcv = labels_10times == f;
        data_test = data(labels_10fcv,:);
        labels_test = labels(labels_10fcv);
        data_training = data(~labels_10fcv,:);
        labels_training = labels(~labels_10fcv);
        l_test = sum(labels_10fcv);
        for k = 1:4     % About the number of principal component
            for i = 1:8     % k
                    %%  SPCA
                    reduced_W = [-1 i; i -1];
                    [ V, D ] = ClassSPCA( data_training, labels_training, k+1, reduced_W );
                    projection_traning = data_training * V;
                    projection_test = data_test * V;

                    %%  LDA for training set
                    projection_M = projection_traning(labels_training==1,:);
                    projection_B = projection_traning(labels_training==0,:);

                    mean_M = mean(projection_M);
                    mean_B = mean(projection_B);
                    cov_M = cov(projection_M);
                    cov_B = cov(projection_B);
                    w = (cov_M+cov_B)\(mean_M-mean_B)';
                    c = dot(w,(mean_M+mean_B))/2;

                    LDA_M = projection_M * w;
                    LDA_B = projection_B * w;
                    error = (length(find(LDA_M<c)) + length(find(LDA_B>c)));
                    accuracy_training(k,i) = accuracy_training(k,i) + (1 - error / (n-l_test) )/100;
                    
                    %%  LDA for test set
                    projection_M = projection_test(labels_test==1,:);
                    projection_B = projection_test(labels_test==0,:);

                    mean_M = mean(projection_M);
                    mean_B = mean(projection_B);
                    cov_M = cov(projection_M);
                    cov_B = cov(projection_B);
                    w = (cov_M+cov_B)\(mean_M-mean_B)';
                    c = dot(w,(mean_M+mean_B))/2;

                    LDA_M = projection_M * w;
                    LDA_B = projection_B * w;
                    error = (length(find(LDA_M<c)) + length(find(LDA_B>c)));
                    accuracy_test(k,i) = accuracy_test(k,i) + (1 - error / l_test)/100;
            end
        end
    end
end