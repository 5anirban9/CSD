
load('OutputResult\FeedBackAnalysisReportNonAdaptive');
load('OutputResult\FeedBackAnalysisReportAdaptive');
NA_acc=cell2mat(CSDResultsNonAdaptive(2:end,4));
A_acc=cell2mat(CSDResultsAdaptive(2:end,4));
pI=find(A_acc>NA_acc & A_acc>0.7 & NA_acc>0.64);

% fResults=[fIndex naFinal aFinal];
% naFinal=NA_acc(pI);aFinal=A_acc(pI);fIndex=pI;

CSDResults=[CSDResultsNonAdaptive(pI+1,1:4) CSDResultsAdaptive(pI+1,4:6)];
CSDResultsAll={'SubName' 'Run' 'tw' 'tmSt' 'tmEnd' 'Lambda' 'L' 'Tr_10CV' 'Tr_Genacc' 'NADPacc' 'ADPacc'  'sWarn' 'shiftVal'};
for i=1:size(CSDResults,1)
    subName=CSDResults{i,1};
    load(['OutputResult\TrainingAnalysisReport10' subName]);
    tw=cell2mat(CSDResults(i,3));
    CSDResultsAll=[CSDResultsAll;[CSDResults(i,1:3) {Time_Win_List(tw,1)} {Time_Win_List(tw,2)} lambda_TimeLine{tw} L_TimeLine{tw} meanTrainingCrossValidationAcc_TimeLine{tw} Genacc_TimeLine{tw} CSDResults(i,4:7)]];
end
%%
figure;
load('AdaptiveBCI_paper2AccTable');
boxplot(AdaptiveBCI_paper2AccTable(:,1:2),'Notch','on');
title('Healthy Group','FontWeight','bold','FontSize',12);ylabel('Classification Accuracy(%)','FontWeight','bold','FontSize',12);xlabel('Classifiers','FontWeight','bold','FontSize',12);
set(gca,'XTickLabel',{'EEG-CSAC','EEG-NAC'}, 'XTick',1:2,'FontWeight','bold');

figure;
load('AdaptiveBCI_paper2AccTable');
boxplot(AdaptiveBCI_paper2AccTable(:,3:4),'Notch','on');
title('Patient Group','FontWeight','bold','FontSize',12);ylabel('Classification Accuracy(%)','FontWeight','bold','FontSize',12);xlabel('Classifiers','FontWeight','bold','FontSize',12);
set(gca,'XTickLabel',{'EEG-CSAC','EEG-NAC'}, 'XTick',1:2,'FontWeight','bold');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure;
load('CSVandAccImprv');
scatter(CSVandAccImprv(:,1),CSVandAccImprv(:,2),'o','MarkerFaceColor','r','MarkerEdgeColor','r');
mdlParam=polyfit(CSVandAccImprv(:,1),CSVandAccImprv(:,2),1);
xval=5:16;
yval=polyval(mdlParam,xval);
hold on;plot(xval,yval,'-k','LineWidth',2);
% title('CSV vs EEG-NAC to EEG-CSAC acc change','FontWeight','bold','FontSize',12);
ylabel('EEG-NAC to EEG-CSAC Acc Change(%)','FontWeight','bold','FontSize',12);xlabel('CSV(%)','FontWeight','bold','FontSize',12);
set(gca,'FontWeight','bold');
xlim([0 20]);








