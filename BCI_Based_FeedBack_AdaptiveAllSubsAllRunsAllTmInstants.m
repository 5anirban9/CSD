clc;
clear all;
CSDResultsAdaptive={'SubName' 'Run' 'tw' 'FeedBackacc' 'sWarn' 'shiftVal'};
SubjectNameList={'Shreewati','ShreewatiD2','ShreewatiD3','ShreewatiD4','ShreewatiD5','ShreewatiD6','ShreewatiD7','ShreewatiD8','ShreewatiD9','ShreewatiD10','ShreewatiD11',...
    'ShreewatiD12','ShreewatiD13','RahulJain','RahulJainD2','RahulJainD3','RahulJainD4','RahulJainD5','RahulJainD6','RahulJainD7','RahulJainD8','RahulJainD9','RahullJainD10',...
    'Dinesh','DineshD2','DineshD3','DineshD4','DineshD5','DineshD7','DineshD8','DineshD9','DineshD10','DineshD11','DineshD12','Rihana','RihanaD3',...
    'RihanaD4','RihanaD5','RihanaD6','Balrajswami','CPSuklaD1','GangaVishnuD1','MahadevPrasad','RamChandra','SSachan','SSachanD2','ShivShankar',...
    'UrmilaTiwariD1','UrmilaTiwariD2','UrmilaTiwariD3','Nisha','Shishir','Umesh'};
RunList=[3*ones(1,13)   3*ones(1,10) 3*ones(1,11) 3*ones(1,5) 3 1 2 3 2 3 3 3 3 3 3 3 3 3];
load gong.mat;
% src_path='H:\DatabaseForResultGenerationPaper2\InputData\';
% src_path2='H:\DatabaseForResultGenerationPaper2\OutputResult\';

src_path='J:\tempInputDataFromUUdesktop\';
src_path2='J:\Writing Phase_FromIITKDesktopJuly27th\Paper2\ResultFactory\OutputResult\';

addpath(genpath('J:\Writing Phase_FromIITKDesktopJuly27th\Paper2\ResultFactory\functions_UU_March2016\'));
UCLstore=[];LCLstore=[];xxStore=[];
for subID=24:length(SubjectNameList)

SubjectName=SubjectNameList{subID};
Planning=1;
    if(subID<=length(SubjectNameList)-3 && subID~=18 && subID~=42)
        Propreoception=1;
    else
        Propreoception=0;
    end

for Run=1:RunList(subID)

disp('########  Loading Parameters for FeedBack Paradigm ##################');
load([src_path2 'TrainingAnalysisReport' num2str(Planning) num2str(0) SubjectName '.mat']);
load([src_path 'FeedBackDataBase' num2str(Planning) num2str(Propreoception) '_' SubjectName num2str(Run) '.mat']);
FeedBackData_sub=eval(['FeedBackData' num2str(Planning) num2str(Propreoception) '_' SubjectName  num2str(Run)]);
for trl=1:nofTrials
    allCh(:,trl,:)=FeedBackData_sub(chList,trialStartIndexes(trl):trialEndIndexes(trl)-1);
    trl=trl+1;
end
classLabels=classLabels';
for tw=1:8
W_CSP_MU=TR_MDL_TimeLine{tw}.W_CSP_Mu;
W_CSP_BETA=TR_MDL_TimeLine{tw}.W_CSP_Beta;
TR_MDL.svm_mdls=TR_MDL_TimeLine{tw}.svm_mdls;
Time_Win=Time_Win_List(tw,1):Time_Win_List(tw,2); % Time of Interest

band_u=[low_CutOff_u high_CutOff_u];band_b=[low_CutOff_beta high_CutOff_beta];
[B_u,A_u]=butter(order,band_u/Smp_Rate*2); 
[B_b,A_b]=butter(order,band_b/Smp_Rate*2); 
%%%%%%%%%Adaptive%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
shiftWarning=0;shiftValidated=0;
ii=[];xx=[];z=[];alpha=[];var_e=[];std_e=[];LCL=[];UCL=[];uu=[];label=[];Err=[];
TR_MDL_update=TR_MDL.svm_mdls;
ii=0;z(1)=z_last_TimeLine{tw};xx(1)=x_initial_TimeLine{tw};alpha=0.10;
var_e(1)=sigma_error_2_TimeLine{tw};
std_e(1)=sqrt(var_e(1));
LCL(1)=LCL_ini_TimeLine{tw};
UCL(1)=UCL_ini_TimeLine{tw};
count=0;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    
for trl=1:nofTrials
    temp=squeeze(allCh(:,trl,:));
    for chIndex=1:length(chList)
        Temp_Buf_u(chIndex,:)=filter(B_u,A_u,temp(chIndex,Time_Win));
    end     
            
    
    Data_CSP_MU=W_CSP_MU*Temp_Buf_u;
    Data_CSP_MU=Data_CSP_MU';
    Feat_Mu=log(var(Data_CSP_MU(:,:),1));
    
    for chIndex=1:length(chList)
        Temp_Buf_b(chIndex,:)=filter(B_b,A_b,temp(chIndex,Time_Win));
    end
    
    Data_CSP_BETA=W_CSP_BETA*Temp_Buf_b;
    Data_CSP_BETA=Data_CSP_BETA';
    Feat_Beta=log(var(Data_CSP_BETA(:,:),1));  
    
    CSP_Features_FeedBack(trl,:)=[Feat_Mu(1) Feat_Mu(length(chList)) Feat_Beta(1) Feat_Beta(length(chList))];
    %%%%%%%%%%%%%%%%%%%%%%%Adaptive Classifier%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    u=[Feat_Mu Feat_Beta]';
    ii=ii+1;
    if(ii>=2)
     z_pc_Test=COEFF_TimeLine{tw}*u([1,length(chList),length(chList)+1,2*length(chList)]); % Indepened Components =COEFF * Original Data
     xx(ii)=z_pc_Test(1,:); % Select the required components
     z(ii)=(xx(ii)*lambda_TimeLine{tw})+((1-lambda_TimeLine{tw})*z(ii-1));%% Z-statistics
     error(ii)=xx(ii)-z(ii-1); % Error
     var_e(ii)=alpha*((error(ii)).^2)+(1-alpha)*var_e(ii-1);% Smoothed variance of Prediction Error
     std_e(ii)=sqrt(var_e(ii)); % SD of Prediction error 
     LCL(ii)=z(ii-1)-(L_TimeLine{tw}*std_e(ii-1)); % Compute the LCL limit
     UCL(ii)=z(ii-1)+(L_TimeLine{tw}*std_e(ii-1)); % Compute the UCL limit
     
     if (xx(ii)> UCL(ii) || xx(ii)< LCL(ii))
%          disp('SHIFT WARNING');
        shiftWarning=shiftWarning+1;
        ERD_Current=cat(2,Data_CSP_MU(:,[1,length(chList)]),Data_CSP_BETA(:,[1,length(chList)]));
        ERD_Current=ERD_Current';
        alphaa=0.05;
        [p, h]=Hotelling_Haider(ERD_Mean_TimeLine{tw},ERD_Current,alphaa);
        if(p<=0.05)
            p;
            shiftValidated=shiftValidated+1;
            
            sound(y(1:2000));
            disp('CSD at trail:');
            disp(ii);
            %Apply Retraining
            tw;
            Err=classLabels(1:ii-1)-label(1:ii-1); % Check the correct predicted labels
            for j=1:length(Err)
                if(Err(j)==0)
                    count=count+1;
                  New_Train_X(count,:)=uu(j,:);% Obtained new data from eval
                  New_Train_Y(count)=classLabels(j);% Obtained new labels from eval
                end
            end 
            
            if(count~=0)
            Comb_Train_X=cat(2,Train_X_TimeLine{tw},New_Train_X');
            Comb_Train_Y=horzcat(Train_Y_TimeLine{tw}',New_Train_Y);
            TR_MDL_update=svmtrain(Comb_Train_X(fi,:),Comb_Train_Y,'showplot',false,'kktviolationlevel',0.05,'kernel_function','linear');
            end
            count=0;
            
        end
     end
    end
    uu(ii,:)=u([1,length(chList),length(chList)+1,2*length(chList)])';
    label(ii)=svmclassify(TR_MDL_update,uu(ii,fi));
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end


FeedBackClassLabels=classLabels;
FeedBackacc=length(find(label==(classLabels)))/length(classLabels);
Group=label;

CSDResultsAdaptive=[CSDResultsAdaptive;{SubjectName Run tw FeedBackacc shiftWarning shiftValidated }];

UCLstore=[UCLstore UCL];
LCLstore=[LCLstore LCL];
xxStore=[xxStore xx];

end
[SubjectName '         '  num2str(Run)]
eval(['clear' ' TrainingAnalysisReport' num2str(Planning) num2str(0) SubjectName '.mat']);
eval(['clear' ' FeedBackData' num2str(Planning) num2str(Propreoception) '_' SubjectName  num2str(Run)]);
end
end

% save([src_path2 'FeedBackAnalysisReportAdaptive.mat'],'CSDResultsAdaptive');
hold on;
% figure(10)
% plot(CSDResults(:,3)*100,'-ob','MarkerSize',5,'LineWidth',5);








