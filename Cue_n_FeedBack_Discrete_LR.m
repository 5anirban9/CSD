function [sys,x0,str,ts,simStateCompliance] = Cue_n_FeedBack_Discrete_LR(t,x,u,flag,video3,Planning,hardwareConn,classLabels,initDelay)
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
global arduino
switch flag,
  %%%%%%%%%%%%%%%%%%
  % Initialization %
  %%%%%%%%%%%%%%%%%%
  % Initialize the states, sample times, and state ordering strings.
  case 0
    [sys,x0,str,ts,simStateCompliance]=mdlInitializeSizes(hardwareConn);

  %%%%%%%%%%%
  % Outputs %
  %%%%%%%%%%%
  % Return the outputs of the S-function block.
  case 3
    sys=mdlOutputs(t,x,u,video3,Planning,hardwareConn,classLabels,initDelay);

  %%%%%%%%%%%%%%%%%%%
  % Unhandled flags %
  %%%%%%%%%%%%%%%%%%%
  % There are no termination tasks (flag=9) to be handled.
  % Also, there are no continuous or discrete states,
  % so flags 1,2, and 4 are not used, so return an empty
  % matrix 
  case { 1, 2, 4,9 }
     if(hardwareConn==1) 
          if(flag==9)
              openedPort=instrfind;
              if(~isempty(openedPort))
                 fclose(openedPort);
              end
              close all;
          end
     end
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
function [sys,x0,str,ts,simStateCompliance] = mdlInitializeSizes(hardwareConn)

sizes = simsizes;
sizes.NumContStates  = 0;
sizes.NumDiscStates  = 0;
sizes.NumOutputs     = 0;  % dynamically sized
sizes.NumInputs      = -1;  % dynamically sized
sizes.DirFeedthrough = 1;   % has direct feedthrough
sizes.NumSampleTimes = 1;
global ready prepLeft prepRight RightNow blank LeftNow fdStart     imStatus   arduino   trlNum score
ready=rgb2gray(imread('Images\BeReady.jpg'));
prepLeft=rgb2gray(imread('Images\LeftNow.jpg'));
prepRight=rgb2gray(imread('Images\RightNow.jpg'));
RightNow=rgb2gray(imread('Images\prepRight.jpg'));
LeftNow=rgb2gray(imread('Images\prepLeft.jpg'));
blank=rgb2gray(imread('Images\blank.jpg'));
fdStart=rgb2gray(imread('Images\FeedBackStart.jpg'));
trlNum=0;
score=0;

imStatus=[0 0 0 0];

if(hardwareConn==1) 
    openedPort=instrfind;
    if(~isempty(openedPort))
        fclose(openedPort);
    end
    arduino=serial('COM28','BaudRate',9600);
    fopen(arduino);
end

figure(10);
set(gcf,'units','normalized','outerposition',[0 0 1 1]);
set(gcf,'Unit','normalized','Position',[0 0 1 1]);
set(gcf,'menubar','none');
set(gcf,'NumberTitle','off');

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
function sys = mdlOutputs(t,x,u,video3,Planning,hardwareConn,classLabels,initDelay) 
global ready prepLeft prepRight RightNow blank LeftNow fdStart     imStatus   arduino   trlNum score

trig=u(1);
label=u(2);
output=u(3);

% figure(10);

    if(imStatus(1)==0)
        imshow(fdStart,'InitialMagnification','fit');
        imStatus(1)=1;
        
    elseif(trig==1 && imStatus(2)==0)
        trlNum=trlNum+1;
        if(Planning==1)
            if(classLabels(trlNum)==1)
                imshow(prepRight,'InitialMagnification','fit');
            elseif(classLabels(trlNum)==2)
                imshow(prepLeft,'InitialMagnification','fit');
            end
        else
            imshow(ready,'InitialMagnification','fit');
        end
        imStatus=[1 1 0 0 0];
        score=0;
    elseif(label==1 && imStatus(3)==0)
        
        imshow(RightNow,'InitialMagnification','fit');imStatus(3)=1;
       
    elseif(label==2 && imStatus(3)==0)
        
        imshow(LeftNow,'InitialMagnification','fit');imStatus(3)=1;
    
    elseif(imStatus(3)==1)
        if(output==label)
            score=score+1;
            if(label==1)
                imshow(video3(:,:,:,(9-score)*10),'InitialMagnification','fit');
            else
                imshow(flipdim(video3(:,:,:,(9-score)*10),2),'InitialMagnification','fit');
            end
            if(hardwareConn==1)
                fwrite(arduino,round((score/8)*100));
            end
        end
    end
    if(trlNum>0 && trig==0 && imStatus(4)==0)
        imshow(blank,'InitialMagnification','fit');imStatus=[1 0 0 1];
        if(hardwareConn==1)
            fwrite(arduino,111);
        end
    end
 sys=[];
            
                
            
                
                    
               
                      



% end mdlOutputs

