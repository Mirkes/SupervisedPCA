function [ res, lab ] = SupervisedPCATestGeneratorND( K, L, N, d1, d2, ang, shift )
%SupervisedPCATestGenerator generates L sets of N points in K dimensional
%space. The first coordinates of points follows uniform distribution
%U(-d1,d1). All other coordinates of points follows uniform distribution
%U(-d2,d2).
%
%The second set is shifted along the coordinate shift(1) on 10*d2 with
%respect to the first set, the third set is shifted along the coordinate
%shift(2) on 10*d2 with respect to the second set and rotate in coordinate
%space of the first coordinate and shift(1) coordinate on pi/2, etc. 
%
%Each pair of coordinates then rotated by matrix 
% cos(ang)   -sin(ang)
% sin(ang)    cos(ang)

    %Preallocate data
    lab = zeros(L*N,1);
    res = 2*rand(L*N,K)-1;
    
    %Complete data generation
    res(:,1) = res(:,1)*d1;
    res(:,2:K) = res(:,2:K)*d2;
    
    %Fill labels data and shifts points
    sh = [1, shift];
    rot = [ cos(pi/2),   -sin(pi/2);  sin(pi/2),    cos(pi/2)];
    for k=1:L
        lab((k-1)*N+1:k*N) = k;
        for kk = 2:k
            res((k-1)*N+1:k*N,sh(kk)) = res((k-1)*N+1:k*N,sh(kk)) + 10*d2;
        end
        if k>2 
            tmp = [res((k-1)*N+1:k*N,sh(kk-2)), res((k-1)*N+1:k*N,sh(kk-1))] * rot;
            res((k-1)*N+1:k*N,sh(kk-2)) = tmp(:,1);
            res((k-1)*N+1:k*N,sh(kk-1)) = tmp(:,2);
        end
    end
    
    %Create matrix
    rot = [ cos(ang),   -sin(ang);  sin(ang),    cos(ang)];
    %Go over pair of coordinates
    for k=1:K-1
        for r=k+1:K
            tmp = [res(:,k), res(:,r)] * rot;
            res(:,k) = tmp(:,1);
            res(:,r) = tmp(:,2);
        end
    end
end

