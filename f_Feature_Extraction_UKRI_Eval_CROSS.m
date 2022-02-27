function [Features]=f_Feature_Extraction_UKRI_Eval_CROSS(EEG_SIG_Tr, EEG_SIG_Ts,Labels_T, Labels_E,Triggers_T, Triggers_E, band, order, Subject_No, Smp_Rate,time_point,TR_MDL)
% features for each ban
i=0;

for j=1:length(band)
                  
        % function for EEG Band-Pass filtering for Training Data

        [Signal_out_Tr]=f_Bandpass_HR_CSD(EEG_SIG_Tr, order, band(j,:), Smp_Rate); 

              % function for EEG Band-Pass filtering for Testing Data
        [Signal_out_Ts]=f_Bandpass_HR_CSD(EEG_SIG_Ts, order, band(j,:), Smp_Rate); 

        Signal_out=vertcat(Signal_out_Tr,Signal_out_Ts);
        Labels=vertcat(Labels_T,Labels_E);

        % Function to Convert the test data in Epochs and Channels Wise
        [Tr_left, Tr_right]=f_Convert_Into_Epochs_UKRI(Signal_out, Triggers_E, Labels, time_point);
        

        %%
        %==========================================================================
        %#################### Feature Extraction for Training #####################
        disp('### Reshaping Data to apply the CSP ###')

        % Function to Convert the test data in Epochs and Channels Wise
        [CSP_LHH, CSP_RHH]=f_Reshape_Data_for_CSP_UKRI(Tr_left, Tr_right);

        % Calculate CSP Projection Matrix
%         [PTranspose] = f_CSP(CSP_LHH',CSP_RHH');

        % CSP according to BIOSIG
%         [PTranspose]=f_csp_biosig(CSP_LHH',CSP_RHH');
           if(j==1)
            PTranspose=TR_MDL.W_CSP_Mu;
           else
            PTranspose=TR_MDL.W_CSP_Beta;
           end

        % Combine Left hand and Right Data
        classtrain= horzcat(CSP_LHH',CSP_RHH');

        % Select the Best Components
        No_of_Components=2;
        train = f_spatFilt(classtrain, PTranspose, No_of_Components);

          % Select the specific window of data from each trail and compute the log
         % varince feature for each trial.
        [Samp_Pts,Chan, No_Trials]=size(Tr_left.CP3);
        Total_Trials=No_Trials*2;
      
        [Xf_left, Xf_right]=f_Extract_Features(train, time_point, Samp_Pts, No_Trials, Total_Trials, No_of_Components);

        % Combine the left and right hand features
        Xf=[Xf_left ; Xf_right];

        % Plot the Features after CSP

        % Get the line 
        All_A=[Xf_left(:,1) ; Xf_right(:,1)];
        All_B=[Xf_left(:,2) ; Xf_right(:,2)];
        minA=min(All_A);
        minB=min(All_B);
        maxA=max(All_A);
        maxB=max(All_B);

        i=i+1;
       
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
        title('{\bfTrain data (CSP)}')

           
    lf=Xf(1:length(Xf)/2,:);
    rh=Xf(length(Xf)/2+1:length(Xf),:);
    Train_X=horzcat(lf',rh'); % Training Data
    Train_Y=[zeros(1,length(lf)), ones(1,length(lf))]; % Training Label    

Features{j}.Sub_Code=Subject_No;
Features{j}.band=band(j,:);
Features{j}.Train_X=Train_X;
Features{j}.Train_Y=Train_Y;
% Features{j}.W_CSP=PTranspose;

end
    
