function [sys,x0,str,ts,simStateCompliance] = f_S_Classify_Non_Adaptive_UKRI(t,x,u,flag,TR_MDL,COEFF,z_last,x_last,sigma_error_2,lambda,L,LCL_ini,UCL_ini,ERD_Mean,Train_X,Train_Y,classLabelsOrg,Time_Win)
%TIMESTWO S-function whose output is two times its input.
% S-Function: Haider Raza
% For Covaraite Shift-Detection and Classification
% 02/July/2015

switch flag,
  %%%%%%%%%%%%%%%%%%
  % lastization %
  %%%%%%%%%%%%%%%%%%
  % lastize the states, sample times, and state ordering strings.
  case 0
    [sys,x0,str,ts,simStateCompliance]=mdllastizeSizes(TR_MDL,z_last,x_last,sigma_error_2,LCL_ini,UCL_ini,classLabelsOrg);

  %%%%%%%%%%%
  % Outputs %
  %%%%%%%%%%%
  % Return the outputs of the S-function block.
  case 3
    sys=mdlOutputs(t,x,u,TR_MDL,COEFF,z_last,x_last,sigma_error_2,lambda,L,ERD_Mean,Train_X,Train_Y,Time_Win);

  %%%%%%%%%%%%%%%%%%%
  % Unhandled flags %
  %%%%%%%%%%%%%%%%%%%
  % There are no termination tasks (flag=9) to be handled.
  % Also, there are no continuous or discrete states,
  % so flags 1,2, and 4 are not used, so return an empty
  % matrix 
  case { 1, 2, 4}
    sys=[];
    case 9
        global TR_MDL_update;
        save('TR_MDL_update.mat','TR_MDL_update');
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % Unexpected flags (error handling)%
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % Return an error message for unhandled flag values.
  otherwise
    DAStudio.error('Simulink:blocks:unhandledFlag', num2str(flag));

end

% end timestwo

%
%=============================================================================
% mdllastizeSizes
% Return the sizes, last conditions, and sample times for the S-function.
%=============================================================================
%
function [sys,x0,str,ts,simStateCompliance] = mdllastizeSizes(TR_MDL,z_last,x_last,sigma_error_2, LCL_ini,UCL_ini,classLabelsOrg)

sizes = simsizes;
sizes.NumContStates  = 0;
sizes.NumDiscStates  = 0;
sizes.NumOutputs     = 1;  % dynamically sized
sizes.NumInputs      = -1;  % dynamically sized
sizes.DirFeedthrough = 1;   % has direct feedthrough
sizes.NumSampleTimes = 1;

sys = simsizes(sizes);
str = [];
x0  = [];
ts  = [-1 0];   % inherited sample time

global ii xx z alpha var_e std_e LCL UCL uu label Err TR_MDL_update count classLabels;
ii=[];
xx=[];
z=[];
alpha=[];
var_e=[];
std_e=[];
LCL=[];
UCL=[];
uu=[];
label=[];
Err=[];
TR_MDL_update=TR_MDL.svm_mdls;

ii=0;
z(1)=z_last;
xx(1)=x_last;
alpha=0.10;
var_e(1)=sigma_error_2;
std_e(1)=sqrt(var_e(1));
LCL(1)=LCL_ini;
UCL(1)=UCL_ini;
count=0;
classLabels=classLabelsOrg';
simStateCompliance = 'DefaultSimState';

% end mdllastizeSizes

%
%=============================================================================
% mdlOutputs
% Return the output vector for the S-function
%=============================================================================
%
function sys = mdlOutputs(t,x,u,TR_MDL,COEFF,z_last,x_last,sigma_error_2,lambda,L,ERD_Mean,Train_X,Train_Y,Time_Win)
global ii xx z alpha var_e std_e LCL UCL uu label Err TR_MDL_update count classLabels;

if(u(1:6,:)==[0;0;0;0;0;0])
    sys=0;
elseif(u(1:6,:)==[1;1;1;1;1;1])
    sys=-1;
else
    ii=ii+1;
    if(ii>=2)
     z_pc_Test=COEFF*u([1,3,4,6]); % Indepened Components =COEFF * Original Data
     xx(ii)=z_pc_Test(1,:); % Select the required components
     z(ii)=(xx(ii)*lambda)+((1-lambda)*z(ii-1));%% Z-statistics
     error(ii)=xx(ii)-z(ii-1); % Error
     var_e(ii)=alpha*((error(ii)).^2)+(1-alpha)*var_e(ii-1);% Smoothed variance of Prediction Error
     std_e(ii)=sqrt(var_e(ii)); % SD of Prediction error 
     LCL(ii)=z(ii-1)-(L*std_e(ii-1)); % Compute the LCL limit
     UCL(ii)=z(ii-1)+(L*std_e(ii-1)); % Compute the UCL limit
     
     if (xx(ii)> UCL(ii) || xx(ii)< LCL(ii))
         disp('SHIFT WARNING')
        load('Data_CSP_MU.mat');
        load('Data_CSP_BETA.mat');
        ERD_Current=cat(2,Data_CSP_MU(Time_Win,[1,3]),Data_CSP_BETA(Time_Win,[1,3]));
        ERD_Current=ERD_Current';
        alphaa=0.05;
        [p, h]=Hotelling_Haider(ERD_Mean,ERD_Current,alphaa);
        if(p<=1)
            load gong.mat;
            sound(y(1:2000));
            disp('CSD at trail:');
            disp(ii);
            % Apply Retraining
            
            Err=classLabels(1:ii-1)-label(1:ii-1); % Check the correct predicted labels
            for j=1:length(Err)
                if(Err(j)==0)
                    count=count+1;
                  New_Train_X(count,:)=uu(j,:);% Obtained new data from eval
                  New_Train_Y(count)=classLabels(j);% Obtained new labels from eval
                end
            end  
            
            if(count~=0)
            Comb_Train_X=cat(2,Train_X,New_Train_X');
            Comb_Train_Y=horzcat(Train_Y',New_Train_Y);
%             TR_MDL_update=svmtrain(Comb_Train_X,Comb_Train_Y,'showplot',false,'kktviolationlevel',0.05);
%            
            end
            count=0;
            
        end
     end
    
    end
    uu(ii,:)=u([1,3,4,6])';
    label(ii)=svmclassify(TR_MDL_update,uu(ii,:));
    if(label(ii)==1)
    sys=4;
      
    else
    sys=-4;
     
    end
end

% end mdlOutputs

