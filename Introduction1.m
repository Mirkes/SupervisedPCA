clc;clear;close all
%%  Create the dataset
n = 100;
t = 1:n;
data = [sin(2*pi*t/50)' cos(2*pi*t/50)' t'/100];
data = zscore(data);
% The 3D plot of the data set
subplot(4,4,[1 2 5 6])
scatter3(data(:,1),data(:,2),data(:,3))
hold on
scatter3(0,0,0) % Origin
%%  Set up the cameras
% Number of cameras
n_camera = 4;
% Position of cameras
camera = rand(3,n_camera)*2-1;
% Data recorded by the cameras
data_camera = zeros(n,n_camera*2);
color = [0.9290 0.6940 0.1250;...
         0.4940 0.1840 0.5560;...
         0.4660 0.6740 0.1880;...
         0.3010 0.7450 0.9330];
for i = 1:n_camera
    % Normalize the position of cameras, we only need the direction of each camera
    camera(:,i) = camera(:,i)/((camera(:,i)'*camera(:,i))^(1/2));
    subplot(4,4,[1 2 5 6])
    % Draw the cameras
    scatter3(camera(1,i)*3,camera(2,i)*3,camera(3,i)*3,72,'filled','MarkerEdgeColor',color(i,:))
    line([0,camera(1,i)*3],[0,camera(2,i)*3],[0,camera(3,i)*3],'Color',color(i,:))
    text(camera(1,i)*3,camera(2,i)*3,camera(3,i)*3+0.5,...
        ['Camera ' num2str(i)],'HorizontalAlignment','center','fontsize',15)
    
    % Project the data on a plane which perpendicular to the direction of the camera
    xplane = [-camera(2,i) camera(1,i) 0];
    yplane = cross(camera(:,i),xplane);
    xplane = xplane/norm(xplane);
    yplane = yplane/norm(yplane);
    x = data*xplane'+randn(n,1)/100;
    y = data*yplane'+randn(n,1)/100;
    % Record the projection of the data as the data recorded by the cameras
    data_camera(:,2*i-1) = x;
    data_camera(:,2*i) = y;
    % Plot the projection of the data as the 'pictures' recorded by the cameras
    if i<=2
        k=i+2;
    else
        k=i+4;
    end
    subplot(4,4,k)
    scatter(x,y)
    axis([-2.5 2.5 -2.5 2.5])
    xlabel(['h_' num2str(i)],'fontsize',12)
    ylabel(['v_' num2str(i)],'fontsize',12,'Rotation',0)
    title(['''Pictures'' recorded by camera ' num2str(i)],'fontsize',12)
end
% Description
subplot(4,4,[1 2 5 6])
legend('Data','Origin','Location','northeast')
title('A ball in motion','fontsize',12)
axis([-3 3 -3 3 -3 3])
xlabel('x','fontsize',12)
ylabel('y','fontsize',12)
zlabel('z','fontsize',12,'Rotation',0)
%%  PCA
data_camera = zscore(data_camera);
[ V, D ] = eigs(data_camera'*data_camera,8);
projection = data_camera*V(:,1:3);
% Plot the result of PCA
subplot(4,4,[9 10 13 14])
scatter3(projection(:,1),projection(:,2),projection(:,3))
title('Reconstructed ball motion graph','fontsize',12)
xlabel('PC_1','fontsize',12)
ylabel('PC_2','fontsize',12)
zlabel('PC_3','fontsize',12,'Rotation',0)
%  Plot the eigenvalues
subplot(4,4,[11 12 15 16])
plot(1:8,diag(D),'o-');
text(1:8,diag(D)+20,string(round(diag(D),3)))
axis([0.5 8.5 0 500])
xlabel('Principal components','fontsize',12)
title('Principal components and the corresponding eigenvalues','fontsize',12)
annotation('textbox',[0.11 0.56 0 0],'String','a','fontWeight','bold','fontsize',24)
annotation('textbox',[0.51 0.56 0 0],'String','b','fontWeight','bold','fontsize',24)
annotation('textbox',[0.11 0.1 0 0],'String','c','fontWeight','bold','fontsize',24)
annotation('textbox',[0.51 0.1 0 0],'String','d','fontWeight','bold','fontsize',24)