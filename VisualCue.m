function [sys,x0,str,ts,simStateCompliance] = VisualCue(t,x,u,flag,classLabels,Planning,cueAppear,initDelay)
%TIMESTWO S-function whose output is two times its input.
%   This MATLAB file illustrates how to construct an MATLAB file S-function that
%   computes an output value based upon its input.  The output of this
%   S-function is two times the input value:
%
%     y = 2 * u;
%
%   See sfuntmpl.m for a general S-function template.
%
%   See also SFUNTMPL.
    
%   Copyright 1990-2009 The MathWorks, Inc.
%   $Revision: 1.1.6.2 $

%
% Dispatch the flag. The switch function controls the calls to 
% S-function routines at each simulation stage of the S-function.
%

switch flag,
  %%%%%%%%%%%%%%%%%%
  % Initialization %
  %%%%%%%%%%%%%%%%%%
  % Initialize the states, sample times, and state ordering strings.
  case 0
    [sys,x0,str,ts,simStateCompliance]=mdlInitializeSizes();

  %%%%%%%%%%%
  % Outputs %
  %%%%%%%%%%%
  % Return the outputs of the S-function block.
  case 3
    sys=mdlOutputs(t,x,u,classLabels,Planning,cueAppear,initDelay);

  %%%%%%%%%%%%%%%%%%%
  % Unhandled flags %
  %%%%%%%%%%%%%%%%%%%
  % There are no termination tasks (flag=9) to be handled.
  % Also, there are no continuous or discrete states,
  % so flags 1,2, and 4 are not used, so return an empty
  % matrix 
  case { 1, 2, 4,9 }
     
    sys=[];
 
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
% mdlInitializeSizes
% Return the sizes, initial conditions, and sample times for the S-function.
%=============================================================================
%
function [sys,x0,str,ts,simStateCompliance] = mdlInitializeSizes()

sizes = simsizes;
sizes.NumContStates  = 0;
sizes.NumDiscStates  = 0;
sizes.NumOutputs     = 0;  % dynamically sized
sizes.NumInputs      = -1;  % dynamically sized
sizes.DirFeedthrough = 1;   % has direct feedthrough
sizes.NumSampleTimes = 1;
global  ready blank trStart  tTrshld trlFlg imStatus trlNum prepLeft prepRight RightNow LeftNow
ready=rgb2gray(imread('Images\BeReady.jpg'));
prepLeft=rgb2gray(imread('Images\prepLeft.jpg'));
prepRight=rgb2gray(imread('Images\prepRight.jpg'));
RightNow=rgb2gray(imread('Images\RightNow.jpg'));
LeftNow=rgb2gray(imread('Images\LeftNow.jpg'));
blank=rgb2gray(imread('Images\blank.jpg'));


trStart=rgb2gray(imread('Images\TrainingStart.jpg'));
tTrshld=0;
trlFlg=1;
imStatus=[0 0 0 0 0 0];
trlNum=0;

sys = simsizes(sizes);
str = [];
x0  = [];
ts  = [-1 0];   % inherited sample time

% specify that the simState for this s-function is same as the default
             % Open Serial Port

simStateCompliance = 'DefaultSimState';

% end mdlInitializeSizes

%
%=============================================================================
% mdlOutputs
% Return the output vector for the S-function
%=============================================================================
%
function sys = mdlOutputs(t,x,u,classLabels,Planning,cueAppear,initDelay) 
global  ready blank  trStart tTrshld trlFlg trlStart trlInstant imStatus trlNum prepLeft prepRight RightNow LeftNow

trig=u(1);
label=u(2);


figure(10);
if(t-tTrshld>0.03125)
    tTrshld=t;
    if(t<initDelay)
        if(imStatus(1)==0)
            imshow(trStart);
            imStatus=[1 0 0 0 0 0];
        end
    else
        if(trig==1)
            if(trlFlg==1)
                trlStart=t;
                trlFlg=0;
                trlNum=trlNum+1;
            else
                trlInstant=t-trlStart;
               
                if(trlInstant<cueAppear)
                    if(imStatus(2)==0)
                        if(Planning==1)
                            if(classLabels(trlNum)==1)
                                imshow(prepRight);
                            elseif(classLabels(trlNum)==2)
                                imshow(prepLeft);
                            end
                        else
                            imshow(ready);
                        end
                        imStatus=[0 1 0 0 0 0];
                    end
                elseif(trlInstant>=cueAppear && trlInstant<=cueAppear+1)
                    if(label==1)
                        if(imStatus(3)==0)
                            imshow(RightNow);imStatus=[0 0 1 0 0 0];
                        end
                    elseif(label==2)
                        if(imStatus(4)==0)
                            imshow(LeftNow);imStatus=[0 0 0 1 0 0];
                        end
                    end
                      
                end
                              
            end
        else
             if(imStatus(6)==0)
                 imshow(blank);imStatus=[0 0 0 0 0 1];
                 
             end
            trlFlg=1;
        end
        
    end
     
end

sys=[];

% end mdlOutputs

