function [sys,x0,str,ts,simStateCompliance] = sbpf_uC3C4(t,x,u,flag)

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
    sys=mdlOutputs(t,x,u);

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
sizes.NumOutputs     = 1;
sizes.NumInputs      = -1;
sizes.DirFeedthrough = 1;
sizes.NumSampleTimes = 1;   % at least one sample time is needed
global i;
global Signal_in_c3_u Signal_in_c4_u;
global order band_u Smp_Rate A_u B_u fbp_c3_u fbp_c4_u  f;
i=1;Signal_in_c3_u=[];Signal_in_c4_u=[];f=1;

order=4;band_u=[8 12];Smp_Rate=250;
[B_u,A_u]=butter(order,band_u/Smp_Rate*2); 
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
function sys=mdlOutputs(t,x,u)
global i Signal_in_c3_u Signal_in_c4_u A_u B_u fbp_c3_u fbp_c4_u f;
Signal_in_c3_u(i)=u(1);
Signal_in_c4_u(i)=u(2);
if(i==2000)        
    Signal_mean_c3=mean(Signal_in_c3_u,2); 
    Signal_mean_c4=mean(Signal_in_c4_u,2);
    Signal_in_c3_u=Signal_in_c3_u-Signal_mean_c3; % Make EEG Data to Zero mean for each channel
    Signal_in_c4_u=Signal_in_c4_u-Signal_mean_c4;
    Signal_out_c3 = filter(B_u,A_u,Signal_in_c3_u);  %% Filtering
    Signal_out_c4 = filter(B_u,A_u,Signal_in_c4_u);  
    BP_Signal_c3=Signal_out_c3;
    BP_Signal_c4=Signal_out_c4;
fbp_c3_u(f,:) = BP_Signal_c3;  
fbp_c4_u(f,:) = BP_Signal_c4;  
f=f+1;
i=1;
sys=0;
else
sys = 0;
i=i+1;
end
if(t==1280)
   save('fbp_c3_u.mat');
   save('fbp_c4_u.mat');
end


function sys=mdlGetTimeOfNextVarHit(t,x,u)

sampleTime = 1;    %  Example, set the next hit to be one second later.
sys = t + sampleTime;


function sys=mdlTerminate(t,x,u)

sys = [];

% end mdlTerminate
