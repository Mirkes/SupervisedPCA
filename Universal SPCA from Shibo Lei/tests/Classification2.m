clc;clear;close all
%%  Input the dataset
Data_wdbc = importdata('wdbc.data');
labels = char(Data_wdbc.textdata(:,2))=='M';
data = Data_wdbc.data;
n = length(data);
data = zscore(data);    % Normalise
%%  
for i = 1:8
    for j = 1:8
        %%  SPCA
        reduced_W = [-i+2 1; 1 -j+2];
        [ V, D ] = ClassSPCA( data, labels, 10, reduced_W );
        V = V(:,1:2);
        projection = data * V;

        %%  LDA
        projection_M = projection(labels==1,:);
        projection_B = projection(labels==0,:);
        
        mean_M = mean(projection_M);
        mean_B = mean(projection_B);
        cov_M = cov(projection_M);
        cov_B = cov(projection_B);
        w = (cov_M+cov_B)\(mean_M-mean_B)';
        c = dot(w,(mean_M+mean_B))/2;
        
        LDA_M = projection_M * w;
        LDA_B = projection_B * w;
        error = (length(find(LDA_M<c)) + length(find(LDA_B>c)));
        accuracy = 1 - error / n;
        
        %%  Plot
        if i<=4
            figure(1)
            a = 16*i+j-16;  % Position of subplot
            b = 16*i+j-8;
        else
            figure(2)
            a = 16*(i-4)+j-16;  % Position of subplot
            b = 16*(i-4)+j-8;
        end
        subplot(8,8,a)  % Plot of eigenvalues
        plot(diag(abs(D)),'o-')
        ylim([0 abs(D(1,1))])
        title(['k1=' num2str(-i+2) ',k2=' num2str(-j+2)],'fontsize',12)
        
        subplot(8,8,b)  % Plot of projection
        scatter(projection_M(:,1),projection_M(:,2),18)
        hold on
        scatter(projection_B(:,1),projection_B(:,2),18)
        x1 = min([projection_M(:,1); projection_B(:,1)]);
        x2 = max([projection_M(:,1); projection_B(:,1)]);
        y1 = min([projection_M(:,2); projection_B(:,2)]);
        y2 = max([projection_M(:,2); projection_B(:,2)]);
        fplot(@(x) (c-w(1)*x)/w(2),[x1 x2],'LineWidth',2)   % Threshold of LDA
        axis([x1 x2 y1 y2])
        title(['Accuracy = ' num2str(round(accuracy*100,2)) '%'],'fontsize',12)
    end
end