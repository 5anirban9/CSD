function [EEG_SIG, label, Triggers]=f_Convert_Data_format_modAnirban(Data1, Data2, Data3, label)

Data1(isnan(Data1))=0;
Data2(isnan(Data2))=0;
Data3(isnan(Data3))=0;

DataC3=reshape(Data1,1,2000*160)';
DataCz=reshape(Data2,1,2000*160)';
DataC4=reshape(Data3,1,2000*160)';



EEG_SIG=[DataC3 DataCz DataC4]';

Data_len=length(EEG_SIG);
Triggers.Start_Pos=(1:2000:Data_len);
Triggers.End_Pos=(2000:2000:Data_len);
end