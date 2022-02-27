function [lambda,z_last,x_initial,sigma_error_2,LCL_ini, UCL_ini]=f_Shift_Detection_Param(z_pc_Train,lambda, L)

% Choice of Lambda
  x=z_pc_Train;
%% Initialization Phase
%----------------------------------------
for j=1:10
    mean_x=mean(x); % Mean of the training data
    z(1)=mean_x; % Assign the mean of training to be use as as Z(i-1)

    for i=2:length(x) %% For loop for computing the Z-values of training
        z(i)=(lambda(j)*x(i))+(1-lambda(j))*z(i-1);
    end

    z_last=z(length(z)); % Assign the last of Z as initial Z for testing 
    x_last=x(length(x)); % Assign the last value of training observation
                        % as first observation for testing data.
                        
    for i=2:length(x)  % Compute, Error
        error(i)=(x(i)-z(i-1));
    end

    for i=2:length(x)  % Compute, the sum of the squared 1-step ahead prediction
        sigma_error_2(j)=sum((x(i)-z(i-1)).^2)./length(x);
    end
    clear z;
end

figure(3)
plot(0.1:0.10:1,sigma_error_2) 
xlabel('lambda')
ylabel('std(error)')
hold on
sigma_error_2_MIN=find(sigma_error_2==(min(sigma_error_2)));
lambda=lambda(sigma_error_2_MIN); % select the lambda
plot(lambda,min(sigma_error_2),'r*')
hold off

% Two Stage
confirm_detections=zeros(1,1);
[z_last,x_initial,sigma_error_2,LCL_ini,UCL_ini]=f_CSD_EWMA_Training_Two_Level(z_pc_Train, lambda,L);


end