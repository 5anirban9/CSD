function [EEG_SIG_Tr]=f_convert_into_continous_UKRI(FC3, CP3, FC1, CP1, FCz, CPz, FC2, CP2, FC4, CP4, tEMG1, tEMG2, iEMG3, iEMG4, mEMG5, mEMG6)

[Tr_Len,No_Tr]=size(FC3{1, 1});

FC_3=FC3{1,1};
CP_3=CP3{1, 1};
FC_1=FC1{1, 1};
CP_1=CP1{1, 1};
FC_z=FCz{1, 1};
CP_z=CPz{1, 1};
FC_2=FC2{1, 1};
CP_2=CP2{1, 1};
FC_4=FC4{1, 1};
CP_4=CP4{1, 1};
tEMG_1=tEMG1{1, 1};
tEMG_2=tEMG2{1, 1};
iEMG_3=iEMG3{1, 1};
iEMG_4=iEMG4{1, 1};
mEMG_5=mEMG5{1, 1};
mEMG_6=mEMG6{1, 1};

CFC3=FC_3(:,1);
CCP3=CP_3(:,1);
CFC1=FC_1(:,1);
CCP1=CP_1(:,1);
CFCz=FC_z(:,1);
CCPz=CP_z(:,1);
CFC2=FC_2(:,1);
CCP2=CP_2(:,1);
CFC4=FC_4(:,1);
CCP4=CP_4(:,1);
CtEMG1=tEMG_1(:,1);
CtEMG2=tEMG_2(:,1);
CiEMG3=iEMG_3(:,1);
CiEMG4=iEMG_4(:,1);
CmEMG5=mEMG_5(:,1);
CmEMG6=mEMG_6(:,1);

for i=2:No_Tr

temp_1=FC_3(:,i);
temp_2=CP_3(:,i);
temp_3=FC_1(:,i);
temp_4=CP_1(:,i);
temp_5=FC_z(:,i);
temp_6=CP_z(:,i);
temp_7=FC_2(:,i);
temp_8=CP_2(:,i);
temp_9=FC_4(:,i);
temp_10=CP_4(:,i);
temp_11=tEMG_1(:,i);
temp_12=tEMG_2(:,i);
temp_13=iEMG_3(:,i);
temp_14=iEMG_4(:,i);
temp_15=mEMG_5(:,i);
temp_16=mEMG_6(:,i);

CFC3=vertcat(CFC3,temp_1);
CCP3=vertcat(CCP3,temp_2);
CFC1=vertcat(CFC1,temp_3);
CCP1=vertcat(CCP1,temp_4);
CFCz=vertcat(CFCz,temp_5);
CCPz=vertcat(CCPz,temp_6);
CFC2=vertcat(CFC2,temp_7);
CCP2=vertcat(CCP2,temp_8);
CFC4=vertcat(CFC4,temp_9);
CCP4=vertcat(CCP4,temp_10);
CtEMG1=vertcat(CtEMG1,temp_11);
CtEMG2=vertcat(CtEMG2,temp_12);
CiEMG3=vertcat(CiEMG3,temp_13);
CiEMG4=vertcat(CiEMG4,temp_14);
CmEMG5=vertcat(CmEMG5,temp_15);
CmEMG6=vertcat(CmEMG6,temp_16);

end

EEG_SIG_Tr(:,1)=CFC3;
EEG_SIG_Tr(:,2)=CCP3;
EEG_SIG_Tr(:,3)=CFC1;
EEG_SIG_Tr(:,4)=CCP1;
EEG_SIG_Tr(:,5)=CFCz;
EEG_SIG_Tr(:,6)=CCPz;
EEG_SIG_Tr(:,7)=CFC2;
EEG_SIG_Tr(:,8)=CCP2;
EEG_SIG_Tr(:,9)=CFC4;
EEG_SIG_Tr(:,10)=CCP4;
EEG_SIG_Tr(:,11)=CtEMG1;
EEG_SIG_Tr(:,12)=CtEMG2;
EEG_SIG_Tr(:,13)=CiEMG3;
EEG_SIG_Tr(:,14)=CiEMG4;
EEG_SIG_Tr(:,15)=CmEMG5;
EEG_SIG_Tr(:,16)=CmEMG6;

end
