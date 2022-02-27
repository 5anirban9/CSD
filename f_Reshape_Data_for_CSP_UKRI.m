function [LHH, RHH]=f_Reshape_Data_for_CSP_UKRI(left, right)

% This code is for Re-Shaping the Data for CSP

 % (c) Haider Raza, Intelligent System Research Center, University of Ulster, Northern Ireland, UK.
%     Raza-H@email.ulster.ac.uk
%     Date: 19-May-2015

% Input:
              
%        left:  left hand data
%       right: right hand data
% 
% Output:
%       left: Left hand data
%       right: right hand data



% Extract data in such a manner such that the CSP can be applied. 
Left_Class=cat(2,left.CP3(:,:,:),left.CPz(:,:,:),left.CP4(:,:,:));
Right_Class=cat(2,right.CP3(:,:,:),right.CPz(:,:,:),right.CP4(:,:,:));
% the Data is in 
% 1st Dim - sampling points, 
% 2nd Dim - trials.
% 3rd Dim - channels

N_Tr=size(Left_Class,3);

LHH=Left_Class(:,:,1);
    for i=2:N_Tr
         TEMP=Left_Class(:,:,i);
        LHH=vertcat(LHH,TEMP); % Features from each trial 
    end

RHH=Right_Class(:,:,1);
    for i=2:N_Tr
         TEMP=Right_Class(:,:,i);
         RHH=vertcat(RHH,TEMP);% Features from each trial     
    end

end