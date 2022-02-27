function [FC3 CP3 FC1 CP1 FCz CPz FC2 CP2 FC4 CP4 tEMG1 tEMG2 iEMG3 iEMG4 mEMG5 mEMG6, classlabels]=f_load_Subject_Data_UKRI(Choosefiles,SubCat,Session ) 
% %Clear the workspace.
% clear all; clc
% warning off all
% global NoOfDataSets FC3 CP3 FCz CPz FC4 CP4

%Initialise the variables.
No_Channel = 16;
fullSession = (3+5)/60;
HalfSession = (3+5)/60;
bioSigFE=0; 
%% Data folder.

% Choosefiles='c:\Anirban_UKERI\Data_12_FEB_UKERI\AnirbanFeb2015\';
NoOfDataSets = 1;

% for iDataSet = 1:NoOfDataSets      
    fs=512;
%     if (iDataSet==2)|(iDataSet==7)|(iDataSet==8)|(iDataSet==9)|(iDataSet==10)
%         PrdgmLen=HalfSession*60;  
%     else
%         PrdgmLen=fullSession*60;
%     end
PrdgmLen=fullSession*60;    iDataSet = 1;
    tr_file= SubCat; trnNum=iDataSet:iDataSet; %can be used to combine multiple files coming for example from different runs of a session.

    tempY=[];
    for trn=trnNum(:)'
        temp=load([Choosefiles, tr_file, num2str(Session), '.mat']);
        tempY=[squeeze(tempY) squeeze(temp.RecSig.Data)];
        clear temp;
    end
    
    tempY=tempY';
    trigsig = tempY(:,17);
    classsig = tempY(:,18);
    
    %Trigger and start of action defined by class label.
    trigID=find(trigsig>0); a=find(diff(trigID)-1>0);triggers=trigID([1; a+1]); %Finds trigger point.
    trigID=find(classsig>0); a=find(diff(trigID)-1>0);classltrig=trigID([1; a+1]); classlabels=classsig(classltrig); %Find setting point of task label.
%     clear trigID trigsig classsig classltrig a;
    
    triggers=triggers(~isnan(classlabels));
    classlabels=classlabels(~isnan(classlabels)); classlabel=classlabels(:);
%     clear classlabels;
    
    sample_eachtrial=fs*PrdgmLen;
    y=tempY';
    nt = size(triggers);nt=nt(1,1);
    for i=1:nt-1
        xy1(:,i) = y(1,triggers(i,1)+1:triggers(i,1)+sample_eachtrial); %FC3
        xy2(:,i) = y(2,triggers(i,1)+1:triggers(i,1)+sample_eachtrial); %CP3
        xy3(:,i) = y(3,triggers(i,1)+1:triggers(i,1)+sample_eachtrial); %FCz
        xy4(:,i) = y(4,triggers(i,1)+1:triggers(i,1)+sample_eachtrial); %CPz
        xy5(:,i) = y(5,triggers(i,1)+1:triggers(i,1)+sample_eachtrial); %FC4
        xy6(:,i) = y(6,triggers(i,1)+1:triggers(i,1)+sample_eachtrial); %CP4
        xy7(:,i) = y(7,triggers(i,1)+1:triggers(i,1)+sample_eachtrial); %FC3
        xy8(:,i) = y(8,triggers(i,1)+1:triggers(i,1)+sample_eachtrial); %CP3
        xy9(:,i) = y(9,triggers(i,1)+1:triggers(i,1)+sample_eachtrial); %FCz
        xy10(:,i) = y(10,triggers(i,1)+1:triggers(i,1)+sample_eachtrial); %CPz
        xy11(:,i) = y(11,triggers(i,1)+1:triggers(i,1)+sample_eachtrial); %FC4
        xy12(:,i) = y(12,triggers(i,1)+1:triggers(i,1)+sample_eachtrial); %CP4
        xy13(:,i) = y(13,triggers(i,1)+1:triggers(i,1)+sample_eachtrial); %FCz
        xy14(:,i) = y(14,triggers(i,1)+1:triggers(i,1)+sample_eachtrial); %CPz
        xy15(:,i) = y(15,triggers(i,1)+1:triggers(i,1)+sample_eachtrial); %FC4
        xy16(:,i) = y(16,triggers(i,1)+1:triggers(i,1)+sample_eachtrial); %CP4
    end
    
  %Apply common average reference or Surface Laplacian to preprocess the signals.
  
%   CAR=(xy1+xy2+xy3+xy4+xy5+xy6+xy7+xy8+xy9+xy10+xy11+xy12+xy13+xy14+xy15+xy16)/15;
%   xy1 = xy1 - (CAR - xy1/15);
%   xy2 = xy2 - (CAR - xy2/15);
%   xy3 = xy3 - (CAR - xy3/15);
%   xy4 = xy4 - (CAR - xy4/15);
%   xy5 = xy5 - (CAR - xy5/15);
%   xy6 = xy6 - (CAR - xy6/15);
%   xy7 = xy7 - (CAR - xy7/15);
%   xy8 = xy8 - (CAR - xy8/15);
%   xy9 = xy9 - (CAR - xy9/15);
%   xy10 = xy10 - (CAR - xy10/15);
%   xy11 = xy11 - (CAR - xy11/15);
%   xy12 = xy12 - (CAR - xy12/15);
%   xy13 = xy13 - (CAR - xy13/15);  
%   xy14 = xy14 - (CAR - xy14/15);
%   xy15 = xy15 - (CAR - xy15/15);
%   xy16 = xy16 - (CAR - xy16/15);
  
  
%   fN=512/2;
%   [b,a]=butter(2,[.1 50]/fN);
%   xy4=filtfilt(b,a, xy4);
  
  FC3{iDataSet}=xy1;
  CP3{iDataSet}=xy2;
  FC1{iDataSet}=xy3;
  CP1{iDataSet}=xy4;
  FCz{iDataSet}=xy5;
  CPz{iDataSet}=xy6;
  FC2{iDataSet}=xy7;
  CP2{iDataSet}=xy8;
  FC4{iDataSet}=xy9;
  CP4{iDataSet}=xy10;
  tEMG1{iDataSet}=xy11;
  tEMG2{iDataSet}=xy12;
  iEMG3{iDataSet}=xy13;
  iEMG4{iDataSet}=xy14;
  mEMG5{iDataSet}=xy15;
  mEMG6{iDataSet}=xy16;
  
  clear xy1 xy2 xy3 xy4 xy5 xy6 xy7 xy8 xy9 xy10 xy11 xy12 xy13 xy14 xy15 xy16
end
