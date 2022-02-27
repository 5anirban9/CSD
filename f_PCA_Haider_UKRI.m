function [z_pc_Train, COEFF]=f_PCA_Haider_UKRI(Train_X,NUM)


[COEFF,SCORE,latent,tsquare] = princomp(Train_X'); % PCA function
z_pc_Train=COEFF*Train_X; % Indepened Components =COEFF * Original Data
z_pc_Train=z_pc_Train(1:NUM,:); % Select the required components

end