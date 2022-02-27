clc;
clear all;
close all;

src_path='J:\tempInputDataFromUUdesktop\';
addpath(genpath('J:\Writing Phase_FromIITKDesktopJuly27th\Paper2\ResultFactory\functions_UU_March2016\'));

SubjectName='DineshD9';
Planning=1;
Propreoception=1;



band_u=[8 12];band_b=[16 24];order=4;Smp_Rate=512;
[B_u,A_u]=butter(order,band_u/Smp_Rate*2); 
[B_b,A_b]=butter(order,band_b/Smp_Rate*2); 
fi=1:2;

chF3=4;chFC3=5;chC3=6;chCP3=7;chP3=8;chFCz=9;chCPz=10;chP4=11;chFC4=12;chC4=13;chCP4=14;chF4=15;
chList=[4:15];

trlT=1;

    for Run=1:1
        load([src_path 'FeedbackDataBase' num2str(Planning) num2str(Propreoception) '_' SubjectName  num2str(Run) '.mat']);
        TrainingData_sub=eval(['FeedBackData' num2str(Planning) num2str(Propreoception) '_' SubjectName  num2str(Run)]);


        if(Run==1)
            for trl=1:nofTrials
                allCh(:,trlT,:)=TrainingData_sub(chList,trialStartIndexes(trl):trialEndIndexes(trl)-1);%-mean(TrainingData_sub(chList,trialStartIndexes(trl):trialEndIndexes(trl)-1),2)*ones(1,4096);
                trlT=trlT+1;
            end

            Labels_T=classLabels;
        else
            for trl=1:nofTrials
                allCh(:,trlT,:)=TrainingData_sub(chList,trialStartIndexes(trl):trialEndIndexes(trl)-1);%-mean(TrainingData_sub(chList,trialStartIndexes(trl):trialEndIndexes(trl)-1),2)*ones(1,4096);
                trlT=trlT+1;
            end

            Labels_T= [Labels_T ;classLabels];
        end
        clear TrainingData_sub trialStartIndexes trialEndIndexes nofTrials classLabels
    end

    for tw=1:8
        Time_Win=(5+tw)*0.5*512:((5+tw)*0.5+1.5)*512;
        stTw=Time_Win(1);endTw=Time_Win(length(Time_Win));
        Time_Win_List(tw,:)=[stTw endTw];
        for trlT=1:length(Labels_T)
            for chIndex=1:length(chList)
                bpf_u(chIndex,trlT,:)=filter(B_u,A_u,allCh(chIndex,trlT,Time_Win));
                bpf_b(chIndex,trlT,:)=filter(B_b,A_b,allCh(chIndex,trlT,Time_Win));
            end
        end
        trl_T_G=find(Labels_T==1);
        trl_T_R=find(Labels_T==2);

        bpf_u_G=bpf_u(:,trl_T_G,:);
        bpf_u_R=bpf_u(:,trl_T_R,:);


        bpf_b_G=bpf_b(:,trl_T_G,:);
        bpf_b_R=bpf_b(:,trl_T_R,:);

        len=length(trl_T_G)*length(Time_Win);
        bpf_alch_u_G=reshape(bpf_u_G,length(chList),len)';
        bpf_alch_u_R=reshape(bpf_u_R,length(chList),len)';

        bpf_alch_b_G=reshape(bpf_b_G,length(chList),len)';
        bpf_alch_b_R=reshape(bpf_b_R,length(chList),len)'; 

        [W_CSP_MU] = f_CSP(bpf_alch_u_G',bpf_alch_u_R');
        [W_CSP_BETA] = f_CSP(bpf_alch_b_G',bpf_alch_b_R');

        nofTrials=length(Labels_T);
        for trl=1:nofTrials
        
            temp=squeeze(allCh(:,trl,:));
        
            for chIndex=1:length(chList)
                Temp_Buf_u(chIndex,:)=filter(B_u,A_u,temp(chIndex,Time_Win));
            end
    
            Data_CSP_MU=W_CSP_MU*Temp_Buf_u;
            Data_CSP_MU=Data_CSP_MU';
            Data_CSP_MU_erd(:,:,trl)=Data_CSP_MU(:,[1 length(chList)]);
            Feat_Mu=log(var(Data_CSP_MU(:,:),1)./sum(var(Data_CSP_MU(:,:),1))); 

        for chIndex=1:length(chList)
            Temp_Buf_b(chIndex,:)=filter(B_b,A_b,temp(chIndex,Time_Win));
        end
    
            Data_CSP_BETA=W_CSP_BETA*Temp_Buf_b;
            Data_CSP_BETA=Data_CSP_BETA';
            Data_CSP_BETA_erd(:,:,trl)=Data_CSP_BETA(:,[1 length(chList)]);  
            Feat_Beta=log(var(Data_CSP_BETA(:,:),1)./sum(var(Data_CSP_BETA(:,:),1)));      
    
            CSP_Features_Training(trl,:)=[Feat_Mu(1) Feat_Mu(length(chList)) Feat_Beta(1) Feat_Beta(length(chList))];
        end

        for i=1:2
            if(i==1)
                Xf_left=CSP_Features_Training(trl_T_G,1:2);
                Xf_right=CSP_Features_Training(trl_T_R,1:2);
            else
                Xf_left=CSP_Features_Training(trl_T_G,3:4);
                Xf_right=CSP_Features_Training(trl_T_R,3:4);
            end


            All_A=[Xf_left(:,1) ; Xf_right(:,1)];
            All_B=[Xf_left(:,2) ; Xf_right(:,2)];
            minA=min(All_A);
            minB=min(All_B);
            maxA=max(All_A);
            maxB=max(All_B);

            figure(i)
            scatter(Xf_left(:,1),Xf_left(:,2),10,'b+'); hold on;
            scatter(Xf_right(:,1),Xf_right(:,2),8,'ro'); 
            % Draw Ellipse
            [e1,e2]=f_plot_ellipse(Xf_left,Xf_right);
            hold on;
            plot(e1(1,:), e1(2,:), 'Color','k');
            plot(e2(1,:), e2(2,:), 'Color','k');
            hold on

            GT=[zeros(length(Xf_left),1);ones(length(Xf_right),1)];
            TF=[Xf_left ; Xf_right];
            [class,err,POSTERIOR,logp,coeff] =classify(TF,TF,GT);
            K = coeff(1,2).const;
            L = coeff(1,2).linear;
            f = @(x1,x2) K + L(1)*x1 + L(2)*x2;
            h3 = ezplot(f,[minA maxA minB maxB]);
            set(h3,'Color',[0 0 0]);
            set(h3,'LineWidth',1);
            xlabel('First best feature','FontWeight','bold');
            ylabel('Second best feature','FontWeight','bold');
            title('{\bfTrain data (CSP)}');

        end

        Train_X=CSP_Features_Training;
        Train_Y=Labels_T;

        fold=10;
        clear acc;

        for i=1:fold
            Indices = crossvalind('kfold', size(Train_X,1), fold);
            testset=find(Indices==1);
            trainset=setdiff(1:length(Train_Y),testset);
            TR_MDL.svm_mdls=svmtrain(Train_X(trainset,fi),Train_Y(trainset),'showplot',false,'kktviolationlevel',0.05,'kernel_function','linear');
            Group = svmclassify(TR_MDL.svm_mdls,Train_X(testset,fi));
            acc(i)=length(find(Group==Train_Y(testset)))/length(Train_Y(testset));
            [testset Train_Y(testset) Group];
        end
        meanTrainingCrossValidationAcc=mean(acc);

        TR_MDL.svm_mdls=svmtrain(Train_X(:,fi),Train_Y,'showplot',false,'kktviolationlevel',0.05,'kernel_function','linear');
        Group = svmclassify(TR_MDL.svm_mdls,Train_X(:,fi));
        Genacc=length(find(Group==Train_Y))/length(Train_Y);

        accTimeLine(tw)=Genacc*100;
        
        TR_MDL.W_CSP_Mu=W_CSP_MU;
        TR_MDL.W_CSP_Beta=W_CSP_BETA;
        
        

        %  Compute CSD Parameters
        %  Apply PCA
        NUM=1; % Number of Component required
        lambda=0.1:0.10:1; % Smoothing Constant
        
        L=2.0;   % No of Standard Deviation

        [z_Train_X, COEFF]=f_PCA_Haider_UKRI(Train_X',NUM);
        [lambda,z_last,x_initial,sigma_error_2,LCL_ini, UCL_ini]=f_Shift_Detection_Param(z_Train_X',lambda,L);
        ERD_CSP_Data=cat(2,Data_CSP_MU_erd,Data_CSP_BETA_erd);  
        ERD_Mean=mean(ERD_CSP_Data,3)';

        Train_X=Train_X';
        
        TR_MDL_TimeLine{tw}=TR_MDL;
        z_Train_X_TimeLine{tw}=z_Train_X;
        COEFF_TimeLine{tw}=COEFF;
        lambda_TimeLine{tw}=lambda;
        z_last_TimeLine{tw}=z_last;
        x_initial_TimeLine{tw}=x_initial;
        L_TimeLine{tw}=L;
        sigma_error_2_TimeLine{tw}=sigma_error_2;
        LCL_ini_TimeLine{tw}=LCL_ini;
        UCL_ini_TimeLine{tw}=UCL_ini;
        ERD_Mean_TimeLine{tw}=ERD_Mean;
        Train_X_TimeLine{tw}=Train_X;
        Train_Y_TimeLine{tw}=Train_Y;
        meanTrainingCrossValidationAcc_TimeLine{tw}=meanTrainingCrossValidationAcc;
        Genacc_TimeLine{tw}=Genacc;
        
        
%         close all
    end

high_CutOff_beta=band_b(2);
high_CutOff_u=band_u(2);
low_CutOff_beta=band_b(1);
low_CutOff_u=band_u(1);




% % save([src_path 'TrainingAnalysisReport' num2str(Planning) num2str(Propreoception) SubjectName '.mat'],'chList','TR_MDL_TimeLine','meanTrainingCrossValidationAcc_TimeLine','Genacc_TimeLine',...
% 'Time_Win_List','Smp_Rate','order','high_CutOff_beta','high_CutOff_u','low_CutOff_beta','low_CutOff_u','fi','TR_MDL_TimeLine','z_Train_X_TimeLine','COEFF_TimeLine','lambda_TimeLine',...
%  'z_last_TimeLine','x_initial_TimeLine','L_TimeLine','sigma_error_2_TimeLine','LCL_ini_TimeLine','UCL_ini_TimeLine','ERD_Mean_TimeLine','Train_X_TimeLine','Train_Y_TimeLine');
% figure(10)
% % if(Planning==1)
% plot(accTimeLine,'-ob','MarkerSize',5,'LineWidth',5);