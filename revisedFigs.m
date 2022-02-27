load('controlLimits');
range=1:300;
fig1 = figure(1);clf%Figure Handle
set(fig1,'units','centimeters','PaperUnits', 'centimeters','PaperSize', [28 14]);%Figure Dimensions
set(gcf,'units','points','position',[100,100,700,350])
plot(UCLstore(range),'--r','LineWidth',2);hold on;
plot(LCLstore(range),'--g','LineWidth',2);hold on;
plot(xxStore(range),'-b','LineWidth',2);
set(gca,'fontsize', 15);hold on;

xlim([1 length(range)]);
xlabel('trials','FontSize',15,'FontWeight','light','Color','k');
legend('UCL','LCL','x','Location','northwest');



orient TALL  %%Orientions
filename=['controlLimit'];               %%%Figure Name
print(fig1,'-dpdf',[filename '.pdf']); %%PDF file
saveas(fig1,[filename '.fig'],'fig'); %%%matlab fig file
print(fig1,'-djpeg100','-r300',[filename '.jpg']); % jpg file with dpi
print(fig1,'-depsc2',[filename '.eps']); %%eps file

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
load('AdaptiveBCI_paper2AccTable');%%%%%LoadData%%%%%%
str = {'EEG-CSAC(H)'; 'EEG-NAC(H)'; 'EEG-CSAC(P)'; 'EEG-NAC(P)'};%%%XTickLabels
fig3 = figure(3);clf%Figure Handle
set(fig3,'units','centimeters','PaperUnits', 'centimeters','PaperSize', [20 14]);%Figure Dimensions
set(gcf,'units','points','position',[100,100,500,350]);

h3=boxplot([AdaptiveBCI_paper2AccTable],'width', 0.4);%%%Width of the boxes
set(h3,{'linew'},{2});
set(gca,'box','off');%%%Border style
% xlabel('method-subject group','FontSize',15,'FontWeight','light','Color','k');%%format of xlabels
ylabel('CA(%)','FontSize',15,'FontWeight','light','Color','k');%%format of ylabels
set(gca, 'XTickLabel',str, 'XTick',1:4,'fontsize', 15);%%Format of x ticks



orient TALL  %%Orientions
filename=['AccComparisonAll'];               %%%Figure Name
print(fig3,'-dpdf',[filename '.pdf']); %%PDF file
saveas(fig3,[filename '.fig'],'fig'); %%%matlab fig file
print(fig3,'-djpeg100','-r300',[filename '.jpg']); % jpg file with dpi
print(fig3,'-depsc2',[filename '.eps']); %%eps file

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fig4 = figure(4);clf%Figure Handle
set(fig4,'units','centimeters','PaperUnits', 'centimeters','PaperSize', [20 14]);%Figure Dimensions
set(gcf,'units','points','position',[100,100,500,350]);

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

orient TALL  %%Orientions
filename=['CSV_vs_AccImprv_mod'];               %%%Figure Name
print(fig4,'-dpdf',[filename '.pdf']); %%PDF file
saveas(fig4,[filename '.fig'],'fig'); %%%matlab fig file
print(fig4,'-djpeg100','-r300',[filename '.jpg']); % jpg file with dpi
print(fig4,'-depsc2',[filename '.eps']); %%eps file
