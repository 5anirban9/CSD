function [Features_2B]=f_Feature_Extraction_2B_UKRI(EEG_SIG_S3, Label_S3,band, order, Subject_No, Smp_Rate, Triggers_S3)
% features for each ban
i=0;

for j=1:length(band)
        time_point=750:1500;
        % function for EEG Band-Pass filtering for Session 1 Data
        [Signal_out_S3]=f_Bandpass_Haider_2B(EEG_SIG_S3, order, band(j,:), Smp_Rate); 
        % Function to Convert the training data in Epochs and Channels Wise
        [Tr_left_S3, Tr_right_S3]=f_Convert_Into_Epochs_2B(Signal_out_S3, Triggers_S3, Label_S3, time_point); 
        
        %%
        %==========================================================================
        %#################### Feature Extraction for Training #####################
        
        %========== Session 3 (Training)    ==========================
        disp('### Reshaping Data to apply the CSP ###')
        % Function to Convert the test data in Epochs and Channels Wise
        [CSP_LHH, CSP_RHH]=f_Reshape_Data_for_CSP_2B(Tr_left_S3, Tr_right_S3);
        % Calculate CSP Projection Matrix
        [PTranspose] = f_CSP(CSP_LHH',CSP_RHH');
        % Combine Left hand and Right Data
        classtrain= horzcat(CSP_LHH',CSP_RHH');
        % Select the Best Components
        No_of_Components=2;
        train = f_spatFilt(classtrain, PTranspose, No_of_Components);
          % Select the specific window of data from each trail and compute the log
         % varince feature for each trial.
        [Samp_Pts,Chan, No_Trials]=size(Tr_left_S3.C3);
        Total_Trials1=No_Trials*2;
        time_point=751:1500;
        [Xf_left_S3, Xf_right_S3]=f_Extract_Features(train, time_point, Samp_Pts, No_Trials, Total_Trials1, No_of_Components);              
        Train_X_S3=horzcat(Xf_left_S3',Xf_right_S3'); % Training Data
        Train_Y_S3=[zeros(1,length(Xf_left_S3)), ones(1,length(Xf_right_S3))]; % Training Label

        % Plot the Features after CSP
        % Get the line 
        All_A=[Xf_left_S3(:,1) ; Xf_right_S3(:,1)];
        All_B=[Xf_left_S3(:,2) ; Xf_right_S3(:,2)];
        minA=min(All_A);
        minB=min(All_B);
        maxA=max(All_A);
        maxB=max(All_B);

        i=i+1;       
        figure(i)
        scatter(Xf_left_S3(:,1),Xf_left_S3(:,2),'ro'); hold on;
        scatter(Xf_right_S3(:,1),Xf_right_S3(:,2),'bd'); 
        xlabel('Component 1');
        ylabel('Component 2');
        title('Feature After Common Spatial Patterns (CSP)')

        hold on
        GT=[ zeros(length(Xf_left_S3),1) ; ones(length(Xf_right_S3),1) ];
        [class,err,POSTERIOR,logp,coeff] = classify([Xf_left_S3 ; Xf_right_S3],[Xf_left_S3 ; Xf_right_S3],GT);
        K = coeff(1,2).const;
        L = coeff(1,2).linear;
        f = @(x1,x2) K + L(1)*x1 + L(2)*x2;
        h3 = ezplot(f,[minA maxA minB maxB]);
        h3.Color = 'g';
        h3.LineWidth = 2;
        title('{\bf Linear Classification with On CSP Training Features}')          
        
        
        
Features_2B{j}.Sub_Code=Subject_No;
Features_2B{j}.band=band(j,:);
Features_2B{j}.Train_X_S3=Train_X_S3;
Features_2B{j}.Train_Y_S3=Train_Y_S3;
Features_2B{j}.W_CSP=PTranspose;

end
    
