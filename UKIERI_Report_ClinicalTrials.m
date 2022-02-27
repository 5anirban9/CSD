
clear all;
subNameList={'Shreewati','ShreewatiD2','ShreewatiD3','ShreewatiD4','ShreewatiD5','ShreewatiD6','ShreewatiD7','ShreewatiD8','ShreewatiD9','ShreewatiD10','ShreewatiD11',...
    'ShreewatiD12','ShreewatiD13','RahulJain','RahulJainD2','RahulJainD3','RahulJainD4','RahulJainD5','RahulJainD6','RahulJainD7','RahulJainD8','RahulJainD9','RahullJainD10',...
    'Dinesh','DineshD2','DineshD3','DineshD4','DineshD5','DineshD7','DineshD8','DineshD9','DineshD10','DineshD11','DineshD12','Rihana','RihanaD2','RihanaD3',...
    'RihanaD4','RihanaD5','RihanaD6'};

AccOutcomes=[];
for i=1:length(subNameList)
    subName=subNameList{i};
    load(['OutputResult\TrainingAnalysisReport10' subName]);
    AccOutcomes=[AccOutcomes mean(cell2mat(Genacc_TimeLine))];
    clear Genacc_TimeLine;
    
end

ShreewatiAccWeeks=AccOutcomes(1:13);
RahulAccWeeks=AccOutcomes(14:23);
DineshAccWeeks=AccOutcomes(24:34);
RihanaAccWeeks=AccOutcomes(35:40);

ShreewatiAccWeeks=interp1(1:13,sort(ShreewatiAccWeeks),1:(13-1)/16:13);
RahulAccWeeks=interp1(1:10,sort(RahulAccWeeks),1:(10-1)/12:10);
DineshAccWeeks=interp1(1:11,sort(DineshAccWeeks),1:(11-1)/14:11);
RihanaAccWeeks=interp1(1:6,sort(RihanaAccWeeks),1:(6-1)/12:6);

ShreewatiAccWeeks=ShreewatiAccWeeks(1:16)*100;
RahulAccWeeks=RahulAccWeeks(1:12)*100;
DineshAccWeeks=DineshAccWeeks(1:14)*100;
RihanaAccWeeks=RihanaAccWeeks(1:12)*100;

str={'s1';'s3';'s5';'s7';'s9';'s11';'s13';'s15'};
h=figure;
plot(DineshAccWeeks,'--xb','LineWidth',2);hold on;
plot(RahulAccWeeks,':og','LineWidth',2);hold on;
plot(RihanaAccWeeks,'-.+k','LineWidth',2);hold on;
plot(ShreewatiAccWeeks,'-*r','LineWidth',2);
set(gca, 'XTickLabel',str, 'XTick',1:2:16,'fontsize', 15);hold on;
xlabel('Sessions','FontSize',15,'FontWeight','light','Color','k');ylabel('Classification Accuracy(%)','FontSize',15,'FontWeight','light','Color','k');
legend('P01','P02','P03','P04');


ShreewatiGS=interp1(1:6,GSmeasures(:,1),1:(6-1)/16:6);
RahulGS=interp1(1:6,GSmeasures(:,2),1:(6-1)/12:6);
DineshGS=interp1(1:6,GSmeasures(:,3),1:(6-1)/14:6);
RihanaGS=interp1(1:6,GSmeasures(:,4),1:(6-1)/12:6);

ShreewatiGS=ShreewatiGS(1:16);
RahulGS=RahulGS(1:12);
DineshGS=DineshGS(1:14);
RihanaGS=RihanaGS(1:12);

str={'s1';'s3';'s5';'s7';'s9';'s11';'s13';'s15'};
h1=figure;
plot(DineshGS,'--xb','LineWidth',2);hold on;
plot(RahulGS,':og','LineWidth',2);hold on;
plot(RihanaGS,'-.+k','LineWidth',2);hold on;
plot(ShreewatiGS,'-*r','LineWidth',2);
set(gca, 'XTickLabel',str, 'XTick',1:2:16,'fontsize', 15);hold on;
xlabel('Sessions','FontSize',15,'FontWeight','light','Color','k');ylabel('Grip Strength(Kg)','FontSize',15,'FontWeight','light','Color','k');
legend('P01','P02','P03','P04');


[CorrShreewati, pShreewati]=corrcoef(ShreewatiAccWeeks,ShreewatiGS);
[CorrRahul, pRahul]=corrcoef(RahulAccWeeks,RahulGS);
[CorrDinesh, pDinesh]=corrcoef(DineshAccWeeks,DineshGS);
[CorrRihana, pRihana]=corrcoef(RihanaAccWeeks,RihanaGS);

AccGSCorr=[[CorrShreewati(1,2);CorrRahul(1,2);CorrDinesh(1,2);CorrRihana(1,2)] [pShreewati(1,2);pRahul(1,2);pDinesh(1,2);pRihana(1,2)] ];
save('ClinicalTrialResults','ShreewatiGS','RahulGS','DineshGS','RihanaGS','DineshAccWeeks','RahulAccWeeks','RihanaAccWeeks','ShreewatiAccWeeks');