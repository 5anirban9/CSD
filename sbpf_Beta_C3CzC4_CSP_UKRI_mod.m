function [sys,x0,str,ts,simStateCompliance] = sbpf_Beta_C3CzC4_CSP_UKRI_mod(t,x,u,flag,W_CSP_BETA, Time_Win)

switch flag,

  %%%%%%%%%%%%%%%%%%
  % Initialization %
  %%%%%%%%%%%%%%%%%%
  case 0,
    [sys,x0,str,ts,simStateCompliance]=mdlInitializeSizes;
    
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
    sys=mdlOutputs(t,x,u,W_CSP_BETA,Time_Win);

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

% end sfuntmpl

%
%=============================================================================
% mdlInitializeSizes
% Return the sizes, initial conditions, and sample times for the S-function.
%=============================================================================
%
function [sys,x0,str,ts,simStateCompliance]=mdlInitializeSizes


sizes = simsizes;

sizes.NumContStates  = 0;
sizes.NumDiscStates  = 0;
sizes.NumOutputs     = 3;
sizes.NumInputs      = -1;
sizes.DirFeedthrough = 1;
sizes.NumSampleTimes = 1;   % at least one sample time is needed
global ib;
global Signal_in_c3_b Signal_in_cz_b Signal_in_c4_b;
global order band_b Smp_Rate A_b B_b fbp_c3_b fbp_cz_b fbp_c4_u  fb;
ib=1;Signal_in_c3_b=[];Signal_in_cz_b=[];Signal_in_c4_b=[];fb=1;

order=4;band_b=[16 24];Smp_Rate=512;
[B_b,A_b]=butter(order,band_b/Smp_Rate*2); 
sys = simsizes(sizes);

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
ts  = [0 0];


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
function sys=mdlOutputs(t,x,u,W_CSP_BETA,Time_Win)
global ib Signal_in_c3_b Signal_in_cz_b Signal_in_c4_b A_b B_b fbp_c3_b fbp_cz_b fbp_c4_u fb;
Signal_in_c3_b(ib)=u(1); % input Signal C3
Signal_in_cz_b(ib)=u(2); % input Signal Cz
Signal_in_c4_b(ib)=u(3); % input Signal C4
trig=u(6);
if(trig==1)
    if(ib==4096)        
        Signal_mean_c3=mean(Signal_in_c3_b,2);  
        Signal_mean_cz=mean(Signal_in_cz_b,2); 
        Signal_mean_c4=mean(Signal_in_c4_b,2);
        Signal_in_c3_b=Signal_in_c3_b-Signal_mean_c3; 
        Signal_in_cz_b=Signal_in_cz_b-Signal_mean_cz;% Make EEG Data to Zero mean for each channel
        Signal_in_c4_b=Signal_in_c4_b-Signal_mean_c4;
        Signal_out_c3 = filter(B_b,A_b,Signal_in_c3_b);  % Filtering
        Signal_out_cz = filter(B_b,A_b,Signal_in_cz_b); % Filtering
        Signal_out_c4 = filter(B_b,A_b,Signal_in_c4_b);  % Filtering
        fbp_c3_b(fb,:) = Signal_out_c3;  
        fbp_cz_b(fb,:) = Signal_out_cz;  
        fbp_c4_u(fb,:) = Signal_out_c4; 
    
        % Temp Buffer to apply CSP
        Temp_Buf(1,:)=Signal_out_c3;
        Temp_Buf(2,:)=Signal_out_cz;
        Temp_Buf(3,:)=Signal_out_c4;
    
        % Apply CSP
    
        Data_CSP_BETA=W_CSP_BETA*Temp_Buf;
        Data_CSP_BETA=Data_CSP_BETA';
        save('Data_CSP_BETA.mat','Data_CSP_BETA');
        Feat=log(var(Data_CSP_BETA(Time_Win,:),1));    

    fb=fb+1;
    ib=1;
    sys=Feat;
    else
        sys = [0 0 0];
        ib=ib+1;
    end
else
    sys = [0 0 0];
end

if(t==304)
   save('fbp_c3_b.mat');
   save('fbp_cz_b.mat');
   save('fbp_c4_b.mat');
end


function sys=mdlGetTimeOfNextVarHit(t,x,u)

sampleTime = 1;    %  Example, set the next hit to be one second later.
sys = t + sampleTime;


function sys=mdlTerminate(t,x,u)

sys = [];

% end mdlTerminate
