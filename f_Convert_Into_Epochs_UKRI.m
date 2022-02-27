function [left, right]=f_Convert_Into_Epochs_UKRI(Signal_out, Triggers, Labels, time_point)
% This code is for Coverting the Data Into Epochs

 % (c) Haider Raza, Intelligent System Research Center, University of Ulster, Northern Ireland, UK.
%     Raza-H@email.ulster.ac.uk
%     Date: 03-Oct-2014

% Input:
%       Signal_out:  Band-passed EEG Signals, 
              % 1st Dim - sampling points, 
              % 2nd Dim - channels, 
              
%       Tiggers:  Triggers of The Cue
%       Label: Labels of the session
% 
% Output:
%       left: Left hand data
%       right: right hand data

for i=1:length(Labels) 
    
trail_points=((i-1)*4096+1):((i-1)*4096+1)+4095;
EEG.FC3(:,:,i)=squeeze(Signal_out(trail_points,1));
EEG.CP3(:,:,i)=squeeze(Signal_out(trail_points,2));
EEG.FC1(:,:,i)=squeeze(Signal_out(trail_points,3));
EEG.CP1(:,:,i)=squeeze(Signal_out(trail_points,4));
EEG.FCz(:,:,i)=squeeze(Signal_out(trail_points,5));
EEG.CPz(:,:,i)=squeeze(Signal_out(trail_points,6));
EEG.FC2(:,:,i)=squeeze(Signal_out(trail_points,7));
EEG.CP2(:,:,i)=squeeze(Signal_out(trail_points,8));
EEG.FC4(:,:,i)=squeeze(Signal_out(trail_points,9));
EEG.CP4(:,:,i)=squeeze(Signal_out(trail_points,10));
EEG.tEMG1(:,:,i)=squeeze(Signal_out(trail_points,11));
EEG.tEMG2(:,:,i)=squeeze(Signal_out(trail_points,12));
EEG.iEMG3(:,:,i)=squeeze(Signal_out(trail_points,13));
EEG.iEMG4(:,:,i)=squeeze(Signal_out(trail_points,14));
EEG.mEMG5(:,:,i)=squeeze(Signal_out(trail_points,15));
EEG.mEMG6(:,:,i)=squeeze(Signal_out(trail_points,16));
end

%------------------------------------------------------------------------
%##########################################################
% Fetch the data according to Left hand and Right hand Trials

lindex=find(Labels(:,1)==1); % Find the left Labels
rindex=find(Labels(:,1)==2); % Find the right labels

left.FC3=EEG.FC3(time_point,:,lindex); 
left.CP3=EEG.CP3(time_point,:,lindex); 
left.FC1=EEG.FC1(time_point,:,lindex); 
left.CP1=EEG.CP1(time_point,:,lindex); 
left.FCz=EEG.FCz(time_point,:,lindex); 
left.CPz=EEG.CPz(time_point,:,lindex); 
left.FC2=EEG.FC2(time_point,:,lindex); 
left.CP2=EEG.CP2(time_point,:,lindex); 
left.FC4=EEG.FC4(time_point,:,lindex); 
left.CP4=EEG.CP4(time_point,:,lindex); 
left.tEMG1=EEG.tEMG1(time_point,:,lindex); 
left.tEMG2=EEG.tEMG2(time_point,:,lindex); 
left.iEMG3=EEG.iEMG3(time_point,:,lindex); 
left.iEMG4=EEG.iEMG4(time_point,:,lindex); 
left.mEMG5=EEG.mEMG5(time_point,:,lindex); 
left.mEMG6=EEG.mEMG6(time_point,:,lindex); 

right.FC3=EEG.FC3(time_point,:,rindex); 
right.CP3=EEG.CP3(time_point,:,rindex); 
right.FC1=EEG.FC1(time_point,:,rindex); 
right.CP1=EEG.CP1(time_point,:,rindex); 
right.FCz=EEG.FCz(time_point,:,rindex); 
right.CPz=EEG.CPz(time_point,:,rindex); 
right.FC2=EEG.FC2(time_point,:,rindex); 
right.CP2=EEG.CP2(time_point,:,rindex); 
right.FC4=EEG.FC4(time_point,:,rindex); 
right.CP4=EEG.CP4(time_point,:,rindex); 
right.tEMG1=EEG.tEMG1(time_point,:,rindex); 
right.tEMG2=EEG.tEMG2(time_point,:,rindex); 
right.iEMG3=EEG.iEMG3(time_point,:,rindex); 
right.iEMG4=EEG.iEMG4(time_point,:,rindex); 
right.mEMG5=EEG.mEMG5(time_point,:,rindex); 
right.mEMG6=EEG.mEMG6(time_point,:,rindex); 
end