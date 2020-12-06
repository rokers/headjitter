% Script that reproduces Figure 4 of Fulvio, Miao, & Rokers - "Head
% jitter enhances 3D motion perception" - Journal of Vision

%% Figure 4a: percentage target interceptions as a function of binned presented direction for the head-tracking on (green), head-tracking off (blue), and lagged head-tracking (red) conditions

load AllSubsBinnedInterceptionData.mat;
% 24 subjects, 3 head-tracking conditions, 21 bins

binsize = 18; % deg
presentedAngleBinCenters = [0:binsize:360];

% some plotting parameters
markerFaceColor = [[0 128 255]; [112 191 65]; [255 38 0]]./255; % off, on, lagged
markerEdgeLineWidth = 2;
lineWidth = 1.5;

figure,
hold on,

% start with all of the line elements in the plot 
plot([180 180],[0 90],'k--','LineWidth',lineWidth)
plot([270 270],[0 90],'k--','LineWidth',lineWidth)

for c=1:3
    errbar(presentedAngleBinCenters,avebinnedInterceptions(c,:),sembinnedInterceptions(c,:),'-','Color',markerFaceColor(c,:),'LineWidth',markerEdgeLineWidth)
    plot(presentedAngleBinCenters,avebinnedInterceptions(c,:),'-','LineWidth',markerEdgeLineWidth,'Color',markerFaceColor(c,:))
end

% add in the circular symbols
for c=1:3
    if c==1
        plot(presentedAngleBinCenters,avebinnedInterceptions(c,:),'o','MarkerSize',10,'MarkerFaceColor','w','MarkerEdgeColor',markerFaceColor(c,:),'LineWidth',markerEdgeLineWidth) % use an open white symbol for fixed
    elseif c==2 || c==3
        plot(presentedAngleBinCenters,avebinnedInterceptions(c,:),'o','MarkerSize',10,'MarkerFaceColor',markerFaceColor(c,:),'MarkerEdgeColor',markerFaceColor(c,:),'LineWidth',markerEdgeLineWidth)
    end
end

grid off;
axis([-15 370 -5 100])
set(gca,'xtick', [0:90:360]);
set(gca,'ytick', [0:30:90]);
set(gca,'FontSize',18);
set(gca,'LineWidth',1.5)
set(gca,'TickDir','out');
xlabel('Presented direction (deg)')
ylabel('Target Interceptions (%)')
set(gcf,'Color','w');


%% Figure 4b: sensitivity (d') and bias (c) plots for the off, on, and lagged conditions 

% left plot: sensitivity (d')
load AllSubsdPrime.mat;

markerFaceColor = [[0 128 255]; [112 191 65]; [255 38 0]]./255;
markerEdgeLineWidth = 2;
binsize = 15; % deg
presentedAngleBinCenters = [7.5:binsize:360];

% fdr correction comparing head-tracking on to head-tracking lagged
for b=1:size(dprime_fortests,3)
    [h,p,ci,stats] = ttest(squeeze(dprime_fortests(2,:,b)),squeeze(dprime_fortests(3,:,b)),'tail','right');  % is sensitivity (d') larger in the on vs lagged condition as hypothesized?
    binpvals(b) = p;
end

[h, crit_p, adj_ci_cvrg, adj_p]=fdr_bh(binpvals); % default: alpha = 0.05 level
binhs = h;

[h, crit_p, adj_ci_cvrg, adj_p]=fdr_bh(binpvals,.1); % also check 0.1 level for trending when FDR-corrected
binhspt1 = h;


% plotting
figure,
hold on,

% start with all the line-based details on the plot
for cc=1:3
    errbar(presentedAngleBinCenters(1:size(dprime_fortests,3)),avedprime(cc,:),semdprime(cc,:),'-','Color',markerFaceColor(cc,:),'LineWidth',markerEdgeLineWidth)
    plot(presentedAngleBinCenters(1:size(dprime_fortests,3)),avedprime(cc,:),'-','LineWidth',2,'Color',markerFaceColor(cc,:))
end

% add in the circular symbols
for cc=1:3
    if cc==1
        plot(presentedAngleBinCenters(1:size(dprime_fortests,3)),avedprime(cc,:),'o','MarkerSize',10,'MarkerFaceColor','w','MarkerEdgeColor',markerFaceColor(cc,:),'LineWidth',markerEdgeLineWidth)
    elseif cc==2 || c==3
        plot(presentedAngleBinCenters(1:size(dprime_fortests,3)),avedprime(cc,:),'o','MarkerSize',10,'MarkerFaceColor',markerFaceColor(cc,:),'MarkerEdgeColor',markerFaceColor(cc,:),'LineWidth',markerEdgeLineWidth)
    end
end

% add fdr-corrected significance symbols
for b=1:size(dprime_fortests,3)
    if binhs(b)==1 % filled symbols for < .05 level
        plot(presentedAngleBinCenters(b),3,'ks','MarkerFaceColor','k','MarkerSize',8,'LineWidth',1.5)
    elseif binhspt1(b)==1 % open symbols for < .1 level
        plot(presentedAngleBinCenters(b),3,'ks','MarkerFaceColor','w','MarkerSize',8,'LineWidth',1.5)
    end
end

grid off;
axis([-5 90 -.25 3.25])

set(gca,'xtick', [0:45:90]);
set(gca,'ytick', [0:3]);
set(gca,'FontSize',18);
set(gca,'LineWidth',1.5)
set(gcf,'Color','w');
set(gca,'TickDir','out');
xlabel('Presented direction (deg)', 'FontSize', 18)
ylabel('Sensitivity (d-prime)', 'FontSize', 18)
axis square



% right plot: bias (c)
load AllSubsBias.mat;

% fdr correction comparing head-tracking on to head-tracking lagged
for b=1:size(bias_fortests,3)
    [h,p,ci,stats] = ttest(squeeze(bias_fortests(2,:,b)),squeeze(bias_fortests(3,:,b)),'tail','left');  % is bias smaller in the on vs lagged condition as hypothesized?
    binpvals(b) = p;
end

[h, crit_p, adj_ci_cvrg, adj_p]=fdr_bh(binpvals); % default: alpha = 0.05 level
binhs = h;

[h, crit_p, adj_ci_cvrg, adj_p]=fdr_bh(binpvals,.1); % also check 0.1 level for trending when FDR-corrected
binhspt1 = h;

% plotting
figure,
hold on,

% start with all the line-based details on the plot
for cc=1:3
    errbar(presentedAngleBinCenters(1:size(bias_fortests,3)),avebias(cc,:),sembias(cc,:),'-','Color',markerFaceColor(cc,:),'LineWidth',markerEdgeLineWidth)
    plot(presentedAngleBinCenters(1:size(bias_fortests,3)),avebias(cc,:),'-','LineWidth',2,'Color',markerFaceColor(cc,:))
end

% add in the circular symbols
for cc=1:3
    if cc==1
        plot(presentedAngleBinCenters(1:size(bias_fortests,3)),avebias(cc,:),'o','MarkerSize',10,'MarkerFaceColor','w','MarkerEdgeColor',markerFaceColor(cc,:),'LineWidth',markerEdgeLineWidth)
    elseif cc==2 || c==3
        plot(presentedAngleBinCenters(1:size(bias_fortests,3)),avebias(cc,:),'o','MarkerSize',10,'MarkerFaceColor',markerFaceColor(cc,:),'MarkerEdgeColor',markerFaceColor(cc,:),'LineWidth',markerEdgeLineWidth)
    end
end

% add fdr-corrected significance symbols
for b=1:size(bias_fortests,3)
    if binhs(b)==1 % filled symbols for < .05 level
        plot(presentedAngleBinCenters(b),.65,'ks','MarkerFaceColor','k','MarkerSize',8,'LineWidth',1.5)
    elseif binhspt1(b)==1 % open symbols for < .1 level
        plot(presentedAngleBinCenters(b),.65,'ks','MarkerFaceColor','w','MarkerSize',8,'LineWidth',1.5)
    end
end

grid off;
axis([-5 90 -.05 .7])

set(gca,'xtick', [0:45:90]);
set(gca,'ytick', [-.2:.2:.6]);
set(gca,'FontSize',18);
set(gca,'LineWidth',1.5)
set(gcf,'Color','w');
set(gca,'TickDir','out');
xlabel('Presented direction (deg)', 'FontSize', 18)
ylabel('Bias (c)', 'FontSize', 18)
axis square


% statistical tests of overall difference in sensitivity and bias across
% the three head-tracking conditions

% sensitivity
[h,p,ci,stats] = ttest(subdprime(1,:), subdprime(2,:),'alpha', 0.05/3,'tail','left') % is sensitivity greater with head-tracking on than off?
[h,p,ci,stats] = ttest(subdprime(3,:), subdprime(2,:),'alpha', 0.05/3,'tail','left') % is sensitivity greater with head-tracking on than lagged?
[h,p,ci,stats] = ttest(subdprime(3,:), subdprime(1,:),'alpha', 0.05/3) % is sensitivity different with head-tracking off versus lagged?

% bias
[h,p,ci,stats] = ttest(subbias(1,:), subbias(2,:),'alpha', 0.05/3,'tail','right') % is bias smaller with head-tracking on than off?
[h,p,ci,stats] = ttest(subbias(3,:), subbias(2,:),'alpha', 0.05/3,'tail','right') % is bias smaller with head-tracking on than lagged?
[h,p,ci,stats] = ttest(subbias(3,:), subbias(1,:),'alpha', 0.05/3) % is bias different with head-tracking off versus lagged?



%% Figure 4c: head jitter as a function of the three head-tracking conditions

load AllSubsHeadJitter.mat;
% for plotting purposes, we load head jitter for 21 subjects (data from 3 had to be omitted due to excessive tracking
% errors) x 3 head-tracking conditions (off, on, lagged)
% for statistical purposes, we load the larger data table containing the
% head jitter for each trial on which it could be reliably measured for each subject for each condition with block
% order information included

% left plot: Average median 3D translational head jitter
% plotting parameters
barColor = [[0 128 255];[112 191 65];[255 38 0]]./255;
lineWidth = 1.5;
barWidth = 0.1;
fontSize = 18;

nSubs = size(Med_Trans_AllSubs,1);

figure,
hold on,

bar(.4,mean(Med_Trans_AllSubs(:,1)), barWidth, 'FaceColor',barColor(1,:),'LineWidth',lineWidth) % off
errbar(.4,mean(Med_Trans_AllSubs(:,1)),std(Med_Trans_AllSubs(:,1))/sqrt(nSubs),'k-','LineWidth',lineWidth)
bar(.6,mean(Med_Trans_AllSubs(:,2)), barWidth, 'FaceColor',barColor(2,:),'LineWidth',lineWidth) % on
errbar(.6,mean(Med_Trans_AllSubs(:,2)),std(Med_Trans_AllSubs(:,2))/sqrt(nSubs),'k-','LineWidth',lineWidth)
bar(.8,mean(Med_Trans_AllSubs(:,3)), barWidth, 'FaceColor',barColor(3,:),'LineWidth',lineWidth) % lagged
errbar(.8,mean(Med_Trans_AllSubs(:,3)),std(Med_Trans_AllSubs(:,3))/sqrt(nSubs),'k-','LineWidth',lineWidth)

axis([0.2 1.2 0 20]) 

grid off;
axis square;

set(gca,'FontSize',fontSize);
set(gca,'LineWidth',1.5)
set(gca,'ytick', [0:5:20])
set(gca,'xtick',[.4 .6 .8])
set(gca,'xticklabel',{'off','on','lagged'});
set(gca,'TickDir','out');
ylabel('Translational jitter (mm)')
xlabel('Viewing Condition')
set(gcf,'Color','w');


% statistical analysis - linear mixed effects model that includes block
% order by subject as a random variable
model = fitlme(dataTableTranslationJitter, 'TranslationJitter ~ HeadtrackingC + (BlockOrderC|Subject)'); 
disp(model) % displays estimated weights and t-stats and p-values associated with comparisons of head-tracking off and lagged relative to head-tracking on - additional comparisons can be made by changing the reference lag
stats = anova(model) % provides summary F-statistics


% right plot: Average median 3D rotational head jitter
% plotting parameters
barColor = [[0 128 255];[112 191 65];[255 38 0]]./255;
lineWidth = 1.5;
barWidth = 0.1;
fontSize = 18;

nSubs = size(Med_Rot_AllSubs,1);

figure,
hold on,

bar(.4,mean(Med_Rot_AllSubs(:,1)), barWidth, 'FaceColor',barColor(1,:),'LineWidth',lineWidth) % off
errbar(.4,mean(Med_Rot_AllSubs(:,1)),std(Med_Rot_AllSubs(:,1))/sqrt(nSubs),'k-','LineWidth',lineWidth)
bar(.6,mean(Med_Rot_AllSubs(:,2)), barWidth, 'FaceColor',barColor(2,:),'LineWidth',lineWidth) % on
errbar(.6,mean(Med_Rot_AllSubs(:,2)),std(Med_Rot_AllSubs(:,2))/sqrt(nSubs),'k-','LineWidth',lineWidth)
bar(.8,mean(Med_Rot_AllSubs(:,3)), barWidth, 'FaceColor',barColor(3,:),'LineWidth',lineWidth) % lagged
errbar(.8,mean(Med_Rot_AllSubs(:,3)),std(Med_Rot_AllSubs(:,3))/sqrt(nSubs),'k-','LineWidth',lineWidth)

axis([0.2 1.2 0 200]) 

grid off;
axis square;

set(gca,'FontSize',fontSize);
set(gca,'LineWidth',1.5)
set(gca,'ytick', [0:50:200])
set(gca,'xtick',[.4 .6 .8])
set(gca,'xticklabel',{'off','on','lagged'});
set(gca,'TickDir','out');
ylabel('Rotational jitter (arcmin)')
xlabel('Viewing Condition')
set(gcf,'Color','w');


% statistical analysis - linear mixed effects model that includes block
% order by subject as a random variable
model = fitlme(dataTableRotationJitter, 'RotationJitter ~ HeadtrackingC + (BlockOrderC|Subject)'); 
disp(model) % displays estimated weights and t-stats and p-values associated with comparisons of head-tracking off and lagged relative to head-tracking on - additional comparisons can be made by changing the reference lag
stats = anova(model) % provides summary F-statistics