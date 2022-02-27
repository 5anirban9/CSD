clear all;
close all;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
load('uBoundOrg');

All_A=[Xf_left(:,1) ; Xf_right(:,1)];
All_B=[Xf_left(:,2) ; Xf_right(:,2)];
minA=min(All_A);
minB=min(All_B);
maxA=max(All_A);
maxB=max(All_B);

uDBShift=figure(1);
set(uDBShift,'units','centimeters','PaperUnits', 'centimeters','PaperSize', [20 14]);%Figure Dimensions
set(gcf,'units','points','position',[100,100,500,350]);
          
[e1,e2]=f_plot_ellipse(Xf_left,Xf_right);
p1=plot(e1(1,:), e1(2,:), '--k','linewidth',4);hold on;
p2=plot(e2(1,:), e2(2,:), '--k','linewidth',4);hold on;


GT=[zeros(length(Xf_left),1);ones(length(Xf_right),1)];
TF=[Xf_left ; Xf_right];
[class,err,POSTERIOR,logp,coeff] =classify(TF,TF,GT);
K = coeff(1,2).const;
L = coeff(1,2).linear;
f = @(x1,x2) K + L(1)*x1 + L(2)*x2;
p3 = ezplot(f,[minA maxA minB maxB]);
set(p3,'Color',[0 0 0]);
set(p3,'LineWidth',4);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
load('uBoundFinal');
% figure(1)
            p7=scatter(Xf_left(:,1),Xf_left(:,2),100,'b+','linewidth',1.5); hold on;
            p8=scatter(Xf_right(:,1),Xf_right(:,2),100,'bo','linewidth',1.5);
All_A=[Xf_left(:,1) ; Xf_right(:,1)];
            All_B=[Xf_left(:,2) ; Xf_right(:,2)];
            minA=min(All_A);
            minB=min(All_B);
            maxA=max(All_A);
            maxB=max(All_B);
% figure(1);
[e1,e2]=f_plot_ellipse(Xf_left,Xf_right);
p4=plot(e1(1,:), e1(2,:), '--b','linewidth',4);hold on;
p5=plot(e2(1,:), e2(2,:), '--b','linewidth',4);hold on;

GT=[zeros(length(Xf_left),1);ones(length(Xf_right),1)];
TF=[Xf_left ; Xf_right];
[class,err,POSTERIOR,logp,coeff] =classify(TF,TF,GT);
K = coeff(1,2).const;
L = coeff(1,2).linear;
f = @(x1,x2) K + L(1)*x1 + L(2)*x2; 
p6 = ezplot(f,[minA maxA minB maxB]);
set(p6,'Color',[0 0 1]);
set(p6,'LineWidth',4);
set(gca,'FontSize',20);
xlabel('First best feature','FontWeight','light','FontSize',20);
ylabel('Second best feature','FontWeight','light','FontSize',20);
 title('{Shift in Decision Boundary}','FontSize',20);
legend([p3 p4 p7 p8],'T_{DB}','F_{DB}','F_{Lt}','F_{Rt}','FontSize',20);

% orient TALL  %%Orientions
filename=['uDBShift'];               %%%Figure Name
print(uDBShift,'-dpdf',[filename '.pdf']); %%PDF file
saveas(uDBShift,[filename '.fig'],'fig'); %%%matlab fig file
print(uDBShift,'-djpeg100','-r300',[filename '.jpg']); % jpg file with dpi
print(uDBShift,'-depsc2',[filename '.eps']); %%eps file
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
load('bBoundOrg');

All_A=[Xf_left(:,1) ; Xf_right(:,1)];
All_B=[Xf_left(:,2) ; Xf_right(:,2)];
minA=min(All_A);
minB=min(All_B);
maxA=max(All_A);
maxB=max(All_B);

bDBShift=figure(2);
set(bDBShift,'units','centimeters','PaperUnits', 'centimeters','PaperSize', [20 14]);%Figure Dimensions
set(gcf,'units','points','position',[100,100,500,350]);
          
[e1,e2]=f_plot_ellipse(Xf_left,Xf_right);
p1=plot(e1(1,:), e1(2,:), '--b','linewidth',4);hold on;
p2=plot(e2(1,:), e2(2,:), '--b','linewidth',4);hold on;
hold on;

GT=[zeros(length(Xf_left),1);ones(length(Xf_right),1)];
TF=[Xf_left ; Xf_right];
[class,err,POSTERIOR,logp,coeff] =classify(TF,TF,GT);
K = coeff(1,2).const;
L = coeff(1,2).linear;
f = @(x1,x2) K + L(1)*x1 + L(2)*x2;
p3 = ezplot(f,[minA maxA minB maxB]);
set(p3,'Color',[0 0 0]);
set(p3,'LineWidth',4);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
load('bBoundFinal');
% figure(1)
            p7=scatter(Xf_left(:,1),Xf_left(:,2),100,'b+','linewidth',1.5); hold on;
            p8=scatter(Xf_right(:,1),Xf_right(:,2),100,'bo','linewidth',1.5);
All_A=[Xf_left(:,1) ; Xf_right(:,1)];
            All_B=[Xf_left(:,2) ; Xf_right(:,2)];
            minA=min(All_A);
            minB=min(All_B);
            maxA=max(All_A);
            maxB=max(All_B);
% figure(1);
[e1,e2]=f_plot_ellipse(Xf_left,Xf_right);
p4=plot(e1(1,:), e1(2,:), '--k','linewidth',4);hold on;
p5=plot(e2(1,:), e2(2,:), '--k','linewidth',4);hold on;

GT=[zeros(length(Xf_left),1);ones(length(Xf_right),1)];
TF=[Xf_left ; Xf_right];
[class,err,POSTERIOR,logp,coeff] =classify(TF,TF,GT);
K = coeff(1,2).const;
L = coeff(1,2).linear;
f = @(x1,x2) K + L(1)*x1 + L(2)*x2; 
p6 = ezplot(f,[minA maxA minB maxB]);
set(p6,'Color',[0 0 1]);
set(p6,'LineWidth',4);
set(gca,'FontSize',20);
xlabel('First best feature','FontWeight','light','FontSize',20);
ylabel('Second best feature','FontWeight','light','FontSize',20);
 title('{Shift in Decision Boundary}','FontSize',15);
legend([p3 p6 p7 p8],'T_{DB}','F_{DB}','F_{Lt}','F_{Rt}','FontSize',20);

% orient TALL  %%Orientions
filename=['bDBShift'];               %%%Figure Name
print(bDBShift,'-dpdf',[filename '.pdf']); %%PDF file
saveas(bDBShift,[filename '.fig'],'fig'); %%%matlab fig file
print(bDBShift,'-djpeg100','-r300',[filename '.jpg']); % jpg file with dpi
print(bDBShift,'-depsc2',[filename '.eps']); %%eps file