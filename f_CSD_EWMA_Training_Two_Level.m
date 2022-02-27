 function [z_last,x_initial,sigma_error_2,LCL_ini,UCL_ini]=f_CSD_EWMA_Training_Two_Level(x, lambda,L)

mean_x=mean(x); % Mean of the training data
z(1)=mean_x; % Assign the mean of training to be use as as Z(i-1)

for i=2:length(x) %% For loop for computing the Z-values of training
    z(i)=(lambda*x(i))+(1-lambda)*z(i-1);
end

z_last=z(length(z)); % Assign the last of Z as initial Z for testing 
x_initial=x(length(x)); % Assign the last value of training observation
                        % as first observation for testing data.

for i=2:length(x)  % Compute, the sum of the squared 1-step ahead prediction
  error(i)=(x(i)-z(i-1));
end

for i=2:length(x)  % Compute, the sum of the squared 1-step ahead prediction
  sigma_error_2=sum((x(i)-z(i-1)).^2)./length(x);
end

LCL_ini=z_last-(L*sqrt(sigma_error_2));
UCL_ini=z_last+(L*sqrt(sigma_error_2));