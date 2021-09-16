clc;clear;close all
%%  Input the dataset
Data_wdbc = importdata('wdbc.data');
labels = char(Data_wdbc.textdata(:,2))=='M';
data = Data_wdbc.data;
n = length(data);
data = zscore(data);    % Normalise
%%
accuracy_training = zeros(8,8,4);
accuracy_test = zeros(8,8,4);
for t = 1:10   % 10 times
    labels_10times = randi([1 10],n,1);
    t   % Progress bar
    for f = 1:10   % 10 fold
        % Assign training set and test set
        labels_10fcv = labels_10times == f;
        data_test = data(labels_10fcv,:);
        labels_test = labels(labels_10fcv);
        data_training = data(~labels_10fcv,:);
        labels_training = labels(~labels_10fcv);
        l_test = sum(labels_10fcv);
        for k = 1:4     % About the number of principal component
            for i = 1:8     % k1
                for j = 1:8     % k2
                    %%  SPCA
                    reduced_W = [-i+2 1; 1 -j+2];
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
                    accuracy_training(i,j,k) = accuracy_training(i,j,k) + (1 - error / (n-l_test) )/100;
                    
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
                    accuracy_test(i,j,k) = accuracy_test(i,j,k) + (1 - error / l_test)/100;
                end
            end
        end
    end
end
accuracy2_test = accuracy_test(:,:,1);
accuracy3_test = accuracy_test(:,:,2);
accuracy4_test = accuracy_test(:,:,3);
accuracy5_test = accuracy_test(:,:,4);
accuracy2_training = accuracy_training(:,:,1);
accuracy3_training = accuracy_training(:,:,2);
accuracy4_training = accuracy_training(:,:,3);
accuracy5_training = accuracy_training(:,:,4);