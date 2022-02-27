function [P,h] = Hotelling_Haider(X_1,X_2,alphaa)


[N1,p]=size(X_1); % Size of first sample
[N2,p]=size(X_2); % Size of second sample
n=[N1,N2];

M1=mean(X_1); % Mean of First Sample
M2=mean(X_2); % Mean of Second Sample
S1=cov(X_1);  % Covariance of First Sample
S2=cov(X_2); % Covariance of Second Sample

dM=(M1-M2); % Difference in Mean 1 and Mean 2
T2=dM*inv((S1/n(1))+(S2/n(2)))*dM';  %Hotelling's T-Squared statistic.

X2=T2;
v=p;
P=1-chi2cdf(X2,v);  %probability that null Ho: is true.

if P >= alphaa;
    h=0;
%    disp('Both samples are same.');
else
    h=1;
%    disp('Both samples are different.');
end;

