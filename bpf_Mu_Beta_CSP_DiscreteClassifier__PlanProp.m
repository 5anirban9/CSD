function [sys,x0,str,ts,simStateCompliance] = bpf_Mu_Beta_CSP_DiscreteClassifier__PlanProp(t,x,u,flag,order,low_CutOff_u,high_CutOff_u,low_CutOff_beta,high_CutOff_beta,Smp_Rate,TR_MDL_TimeLine,Time_Win_List,chList)

switch flag,

  %%%%%%%%%%%%%%%%%%
  % Initialization %
  %%%%%%%%%%%%%%%%%%
  case 0,
    [sys,x0,str,ts,simStateCompliance]=mdlInitializeSizes(order,low_CutOff_u,high_CutOff_u,low_CutOff_beta,high_CutOff_beta,Smp_Rate,Time_Win_List);

  %%%%%%%%%%%%%%%
  % Derivatives %
  %%%%%%%%%%%%%%%
  case 1,
    sys=mdlDerivatives(t,x,u);

  %%%%%%%%%%
  % Update %
  %%%%%%%%%%
  case 2,
    sys=mdlUpdate(t,x,u);

  %%%%%%%%%%%
  % Outputs %
  %%%%%%%%%%%
  case 3,
    sys=mdlOutputs(t,x,u,TR_MDL_TimeLine,Time_Win_List,chList);

  %%%%%%%%%%%%%%%%%%%%%%%
  % GetTimeOfNextVarHit %
  %%%%%%%%%%%%%%%%%%%%%%%
  case 4,
    sys=mdlGetTimeOfNextVarHit(t,x,u);

  %%%%%%%%%%%%%
  % Terminate %
  %%%%%%%%%%%%%
  case 9,
         
    sys=mdlTerminate(t,x,u);
    
  %%%%%%%%%%%%%%%%%%%%
  % Unexpected flags %
  %%%%%%%%%%%%%%%%%%%%
  otherwise
    DAStudio.error('Simulink:blocks:unhandledFlag', num2str(flag));

end


%
function [sys,x0,str,ts,simStateCompliance]=mdlInitializeSizes(order,low_CutOff_u,high_CutOff_u,low_CutOff_beta,high_CutOff_beta,Smp_Rate,Time_Win_List)


sizes = simsizes;

sizes.NumContStates  = 0;
sizes.NumDiscStates  = 0;
sizes.NumOutputs     = 1;
sizes.NumInputs      = -1;
sizes.DirFeedthrough = 1;
sizes.NumSampleTimes = 1;   % at least one sample time is needed
sys = simsizes(sizes);
global B_u A_u B_b A_b  prevLabel    countLabel allCh winLength  fdBck featClassStoreOnline;
band_u=[low_CutOff_u high_CutOff_u];
band_beta=[low_CutOff_beta high_CutOff_beta];
[B_u,A_u]=butter(order,band_u/Smp_Rate*2);
[B_b,A_b]=butter(order,band_beta/Smp_Rate*2);


featClassStoreOnline=[];
fdBck=0;
% chList=[17 17 17];
prevLabel=0;
countLabel=1535;
for i=1:size(Time_Win_List,1)
    allCh{i}=[];
end
winLength=Time_Win_List(1,2)-Time_Win_List(1,1)+1;
%
% initialize the initial conditions
%
x0  = [];

%
% str is always an empty matrix
%
str = [];

%
% initialize the array of sample times
%
ts  = [-1 0];


simStateCompliance = 'UnknownSimState';

% end mdlInitializeSizes

%
%=============================================================================
% mdlDerivatives
% Return the derivatives for the continuous states.
%=============================================================================
%
function sys=mdlDerivatives(t,x,u)

sys = [];

% end mdlDerivatives

%
%=============================================================================
% mdlUpdate
% Handle discrete state updates, sample time hits, and major time step
% requirements.
%=============================================================================
%
function sys=mdlUpdate(t,x,u)

sys = [];

% end mdlUpdate

%
%=============================================================================
% mdlOutputs
% Return the block outputs.
%=============================================================================
%
function sys=mdlOutputs(t,x,u,TR_MDL_TimeLine,Time_Win_List,chList)
    global B_u A_u B_b A_b  prevLabel    countLabel allCh winLength  fdBck featClassStoreOnline;
    sys=0;
    labelNow=u(16);
    if(labelNow~=0 && prevLabel==0)
        fdBck=1;
    end
    if(fdBck==1)
        countLabel=countLabel+1;
        for winCount=1:size(Time_Win_List,1)
            if(countLabel>=Time_Win_List(winCount,1) && countLabel<=Time_Win_List(winCount,2))
                allCh{winCount}=[allCh{winCount} u(chList-3)];
                
                if(size(allCh{winCount},2)==winLength)
                    temp=allCh{winCount};
                    for chIndex=1:size(allCh{winCount},1)
                        Temp_Buf_u(chIndex,:)=filter(B_u,A_u,temp(chIndex,:));
                        Temp_Buf_b(chIndex,:)=filter(B_b,A_b,temp(chIndex,:));
                    end
                    Data_CSP_MU=TR_MDL_TimeLine{winCount}.W_CSP_Mu*Temp_Buf_u;
                    Data_CSP_BETA=TR_MDL_TimeLine{winCount}.W_CSP_Beta*Temp_Buf_b;
                    Data_CSP_MU=Data_CSP_MU';
                    Data_CSP_BETA=Data_CSP_BETA';
                    
                    Feat_Mu=log(var(Data_CSP_MU(:,:),1)); 
                    Feat_Beta=log(var(Data_CSP_BETA(:,:),1)); 
                    
                    feat=[Feat_Mu(1) Feat_Mu(length(chList)) Feat_Beta(1) Feat_Beta(length(chList))];
                    predictedClass = svmclassify(TR_MDL_TimeLine{winCount}.svm_mdls,feat);
                    sys=predictedClass;
                    featClassStoreOnline=[featClassStoreOnline;[feat predictedClass winCount]];
                end
            end
        end
    end
    
    if(labelNow==0 && prevLabel~=0)
        for i=1:size(Time_Win_List,1)
            allCh{i}=[];
        end
        countLabel=1535;
        fdBck=0;
    end
    
    prevLabel=labelNow;
      
                      
                     
           
    
    
    
% end mdlOutputs

%
%=============================================================================
% mdlGetTimeOfNextVarHit
% Return the time of the next hit for this block.  Note that the result is
% absolute time.  Note that this function is only used when you specify a
% variable discrete-time sample time [-2 0] in the sample time array in
% mdlInitializeSizes.
%=============================================================================
%
function sys=mdlGetTimeOfNextVarHit(t,x,u)

sampleTime = 1;    %  Example, set the next hit to be one second later.
sys = t + sampleTime;

% end mdlGetTimeOfNextVarHit

%
%=============================================================================
% mdlTerminate
% Perform any end of simulation tasks.
%=============================================================================
%
function sys=mdlTerminate(t,x,u)
global featClassStoreOnline
save('featClassStoreOnline.mat','featClassStoreOnline');
sys = [];

% end mdlTerminate
