function [BP_Signal]=bpf(EEG_SIG, order, band, Smp_Rate)



    
    [B,A]=butter(order,band/Smp_Rate*2);      
    
    Signal_in=EEG_SIG;
    
    Signal_mean=mean(Signal_in,1);


       
    Signal_in=Signal_in-Signal_mean; % Make EEG Data to Zero mean for each channel
    Signal_out = filter(B,A,Signal_in);  %% Filtering       
       
    BP_Signal=Signal_out;
      
    
end
