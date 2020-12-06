% Script that reproduces Figure 5 of Fulvio, Miao, & Rokers - "Head
% jitter enhances 3D motion perception" - Journal of Vision

%% Figure 5a: percentage target interceptions as a function of binned presented direction for the four levels of lag used in Experiment 2

load AllSubsBinnedInterceptionDataExp2.mat;
% 20 subjects, 4 levels of lag, 21 bins

binsize = 18; % deg
presentedAngleBinCenters = [0:binsize:360];

% some plotting parameters
markerFaceColor = [[112 191 65];[0 128 255];[255 38 0]; [101 67 33]]./255; % lag condition: 0 added lag (14 ms), 1 frame added (27 ms), 2 frames added (40 ms), random
markerEdgeLineWidth = 2;
lineWidth = 1.5;

figure,
hold on,

% start with all of the line elements in the plot 
plot([180 180],[0 90],'k--','LineWidth',lineWidth)
plot([270 270],[0 90],'k--','LineWidth',lineWidth)

for c=1:4
    errbar(presentedAngleBinCenters,avebinnedInterceptions(c,:),sembinnedInterceptions(c,:),'-','Color',markerFaceColor(c,:),'LineWidth',markerEdgeLineWidth)
    plot(presentedAngleBinCenters,avebinnedInterceptions(c,:),'-','LineWidth',markerEdgeLineWidth,'Color',markerFaceColor(c,:))
end

% add in the circular symbols
for c=1:4
    if c==2 || c==4
        plot(presentedAngleBinCenters,avebinnedInterceptions(c,:),'o','MarkerSize',10,'MarkerFaceColor','w','MarkerEdgeColor',markerFaceColor(c,:),'LineWidth',markerEdgeLineWidth) % use an open white symbol for fixed
    elseif c==1 || c==3
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

% Statistical analysis of behavior
load GrandBehavioralDataTableExp2.mat

model = fitlme(dataTable, 'Interceptions ~ LagCondC + (BlockOrderC|Subject)'); 
disp(model) % displays estimated weights and t-stats and p-values associated with comparisons of 1 frame, 2 frame, and mixed lag conditions relative to 0 added lag condition - additional comparisons can be made by changing the reference lag
stats = anova(model) % provides summary F-statistics

%% Figure 5b: sensitivity (d') and bias (c) plots for the off, on, and lagged conditions 

% left plot: sensitivity (d')
load AllSubsdPrimeExp2.mat;

markerFaceColor = [[112 191 65];[0 128 255];[255 38 0]; [101 67 33]]./255; % lag condition: 0 added lag (14 ms), 1 frame added (27 ms), 2 frames added (40 ms), random
markerEdgeLineWidth = 2;
binsize = 15; % deg
presentedAngleBinCenters = [7.5:binsize:360];

% fdr correction comparing the zero added lag condition to the two added
% lags - no comparisons are significant, so the additional possible tests are not
% included here, but could be run using the same approach
for b=1:size(dprime_fortests,3)
    [h,p,ci,stats] = ttest(squeeze(dprime_fortests(1,:,b)),squeeze(dprime_fortests(2,:,b)),'tail','right');  % is sensitivity (d') larger in the zero added lag vs 1 frame added condition as hypothesized?
    binpvals(b) = p;
    
    [h,p,ci,stats] = ttest(squeeze(dprime_fortests(1,:,b)),squeeze(dprime_fortests(3,:,b)),'tail','right');  % is sensitivity (d') larger in the zero added lag vs 2 frames added condition as hypothesized?
    bintwopvals(b) = p;
end

[h, crit_p, adj_ci_cvrg, adj_p]=fdr_bh(binpvals); % default: alpha = 0.05 level
binhs = h;

[h, crit_p, adj_ci_cvrg, adj_p]=fdr_bh(binpvals,.1); % also check 0.1 level for trending when FDR-corrected
binhspt1 = h;

[h, crit_p, adj_ci_cvrg, adj_p]=fdr_bh(bintwopvals); % default: alpha = 0.05 level
bintwohs = h;

[h, crit_p, adj_ci_cvrg, adj_p]=fdr_bh(bintwopvals,.1); % also check 0.1 level for trending when FDR-corrected
bintwohspt1 = h;


% plotting
figure,
hold on,

% start with all the line-based details on the plot
for cc=1:4
    errbar(presentedAngleBinCenters(1:size(dprime_fortests,3)),avedprime(cc,:),semdprime(cc,:),'-','Color',markerFaceColor(cc,:),'LineWidth',markerEdgeLineWidth)
    plot(presentedAngleBinCenters(1:size(dprime_fortests,3)),avedprime(cc,:),'-','LineWidth',2,'Color',markerFaceColor(cc,:))
end

% add in the circular symbols
for cc=1:4
    if cc==2 || cc==4
        plot(presentedAngleBinCenters(1:size(dprime_fortests,3)),avedprime(cc,:),'o','MarkerSize',10,'MarkerFaceColor','w','MarkerEdgeColor',markerFaceColor(cc,:),'LineWidth',markerEdgeLineWidth)
    elseif cc==1 || cc==3
        plot(presentedAngleBinCenters(1:size(dprime_fortests,3)),avedprime(cc,:),'o','MarkerSize',10,'MarkerFaceColor',markerFaceColor(cc,:),'MarkerEdgeColor',markerFaceColor(cc,:),'LineWidth',markerEdgeLineWidth)
    end
end

% because there are no significant comparisons, there are no fdr-corrected
% significance symbols to add

grid off;
axis([-5 90 -.25 2.5])

set(gca,'xtick', [0:45:90]);
set(gca,'ytick', [0:.5:2.5]);
set(gca,'FontSize',18);
set(gca,'LineWidth',1.5)
set(gcf,'Color','w');
set(gca,'TickDir','out');
xlabel('Presented direction (deg)', 'FontSize', 18)
ylabel('Sensitivity (d-prime)', 'FontSize', 18)
axis square



% right plot: bias (c)
load AllSubsBiasExp2.mat;

% fdr correction comparing the zero added lag condition to the two added
% lags - only one comparison is trending, which we do not make much of, so the additional possible tests are not
% included here, but could be run using the same approach
for b=1:size(bias_fortests,3)
    [h,p,ci,stats] = ttest(squeeze(bias_fortests(1,:,b)),squeeze(bias_fortests(2,:,b)),'tail','left');  % is bias (c) smaller in the zero added lag vs 1 frame added condition as hypothesized?
    binpvals(b) = p;
    
    [h,p,ci,stats] = ttest(squeeze(bias_fortests(1,:,b)),squeeze(bias_fortests(3,:,b)),'tail','left');  % is bias (c) smaller in the zero added lag vs 2 frames added condition as hypothesized?
    bintwopvals(b) = p;    
end

[h, crit_p, adj_ci_cvrg, adj_p]=fdr_bh(binpvals); % default: alpha = 0.05 level
binhs = h;

[h, crit_p, adj_ci_cvrg, adj_p]=fdr_bh(binpvals,.1); % also check 0.1 level for trending when FDR-corrected
binhspt1 = h;

[h, crit_p, adj_ci_cvrg, adj_p]=fdr_bh(bintwopvals); % default: alpha = 0.05 level
bintwohs = h;

[h, crit_p, adj_ci_cvrg, adj_p]=fdr_bh(bintwopvals,.1); % also check 0.1 level for trending when FDR-corrected
bintwohspt1 = h;


% plotting
figure,
hold on,

% start with all the line-based details on the plot
for cc=1:4
    errbar(presentedAngleBinCenters(1:size(bias_fortests,3)),avebias(cc,:),sembias(cc,:),'-','Color',markerFaceColor(cc,:),'LineWidth',markerEdgeLineWidth)
    plot(presentedAngleBinCenters(1:size(bias_fortests,3)),avebias(cc,:),'-','LineWidth',2,'Color',markerFaceColor(cc,:))
end

% add in the circular symbols
for cc=1:4
    if cc==2 || cc==4
        plot(presentedAngleBinCenters(1:size(bias_fortests,3)),avebias(cc,:),'o','MarkerSize',10,'MarkerFaceColor','w','MarkerEdgeColor',markerFaceColor(cc,:),'LineWidth',markerEdgeLineWidth)
    elseif cc==1 || cc==3
        plot(presentedAngleBinCenters(1:size(bias_fortests,3)),avebias(cc,:),'o','MarkerSize',10,'MarkerFaceColor',markerFaceColor(cc,:),'MarkerEdgeColor',markerFaceColor(cc,:),'LineWidth',markerEdgeLineWidth)
    end
end

% add fdr-corrected significance symbols - 1 comparison out trending for
% one bin in the zero lag vs. 1 frame added test
for b=1:size(bias_fortests,3)
    if binhs(b)==1 % filled symbols for < .05 level
        plot(presentedAngleBinCenters(b),.65,'ks','MarkerFaceColor','k','MarkerSize',8,'LineWidth',1.5)
    elseif binhspt1(b)==1 % open symbols for < .1 level
        plot(presentedAngleBinCenters(b),.65,'ks','MarkerFaceColor','w','MarkerSize',8,'LineWidth',1.5)
    end
end

grid off;
axis([-5 90 -.1 .7])

set(gca,'xtick', [0:45:90]);
set(gca,'ytick', [-.2:.2:.6]);
set(gca,'FontSize',18);
set(gca,'LineWidth',1.5)
set(gcf,'Color','w');
set(gca,'TickDir','out');
xlabel('Presented direction (deg)', 'FontSize', 18)
ylabel('Bias (c)', 'FontSize', 18)
axis square




%% Figure 5c: head jitter as a function of the three head-tracking conditions

load AllSubsHeadJitterExp2.mat;
% for plotting purposes, we load median head jitter for 17 subjects (data from 3 had to be omitted due to excessive tracking
% errors) x 4 lag conditions
% for statistical purposes, we load the larger data table containing the
% head jitter for each trial on which it could be reliably measured for each subject for each condition with block
% order information included

% left plot: Average median 3D translational head jitter
% plotting parameters
barColor =  [[112 191 65];[0 128 255];[255 38 0]; [101 67 33]]./255; 
lineWidth = 1.5;
barWidth = 0.1;
fontSize = 18;

nSubs = size(Med_Trans_AllSubs,1);

figure,
hold on,

bar(.4,mean(Med_Trans_AllSubs(:,1)), barWidth, 'FaceColor',barColor(1,:),'LineWidth',lineWidth) % zeros frames added (14 ms)
errbar(.4,mean(Med_Trans_AllSubs(:,1)),std(Med_Trans_AllSubs(:,1))/sqrt(nSubs),'k-','LineWidth',lineWidth)
bar(.6,mean(Med_Trans_AllSubs(:,2)), barWidth, 'FaceColor',barColor(2,:),'LineWidth',lineWidth) % 1 frame added (27 ms)
errbar(.6,mean(Med_Trans_AllSubs(:,2)),std(Med_Trans_AllSubs(:,2))/sqrt(nSubs),'k-','LineWidth',lineWidth)
bar(.8,mean(Med_Trans_AllSubs(:,3)), barWidth, 'FaceColor',barColor(3,:),'LineWidth',lineWidth) % 2 frames added (40 ms)
errbar(.8,mean(Med_Trans_AllSubs(:,3)),std(Med_Trans_AllSubs(:,3))/sqrt(nSubs),'k-','LineWidth',lineWidth)
bar(1,mean(Med_Trans_AllSubs(:,4)), barWidth, 'FaceColor',barColor(4,:),'LineWidth',lineWidth) % random/mixed lag condition
errbar(1,mean(Med_Trans_AllSubs(:,4)),std(Med_Trans_AllSubs(:,4))/sqrt(nSubs),'k-','LineWidth',lineWidth)

axis([0.2 1.2 0 8]) 

grid off;
axis square;

set(gca,'FontSize',fontSize);
set(gca,'LineWidth',1.5)
set(gca,'ytick', [0:2:6])
set(gca,'xtick',[.4 .6 .8 1])
set(gca,'xticklabel',{'14','27','40','mixed'});
set(gca,'TickDir','out');
ylabel('Translational jitter (mm)')
xlabel('Lag Condition')
set(gcf,'Color','w');

% statistical analysis - linear mixed effects model that includes block
% order by subject as a random variable
model = fitlme(dataTableTranslationJitterExp2, 'TranslationJitter ~ LagCondC + (BlockOrderC|Subject)'); 
disp(model) % displays estimated weights and t-stats and p-values associated with comparisons of 1 frame, 2 frame, and mixed lag conditions relative to 0 added lag condition - additional comparisons can be made by changing the reference lag
stats = anova(model) % provides summary F-statistics


% right plot: Average median 3D rotational head jitter
% plotting parameters
barColor = [[112 191 65];[0 128 255];[255 38 0]; [101 67 33]]./255; 
lineWidth = 1.5;
barWidth = 0.1;
fontSize = 18;

nSubs = size(Med_Rot_AllSubs,1);

figure,
hold on,

bar(.4,mean(Med_Rot_AllSubs(:,1)), barWidth, 'FaceColor',barColor(1,:),'LineWidth',lineWidth) % zeros frames added (14 ms)
errbar(.4,mean(Med_Rot_AllSubs(:,1)),std(Med_Rot_AllSubs(:,1))/sqrt(nSubs),'k-','LineWidth',lineWidth)
bar(.6,mean(Med_Rot_AllSubs(:,2)), barWidth, 'FaceColor',barColor(2,:),'LineWidth',lineWidth) % 1 frame added (27 ms)
errbar(.6,mean(Med_Rot_AllSubs(:,2)),std(Med_Rot_AllSubs(:,2))/sqrt(nSubs),'k-','LineWidth',lineWidth)
bar(.8,mean(Med_Rot_AllSubs(:,3)), barWidth, 'FaceColor',barColor(3,:),'LineWidth',lineWidth) % 2 frames added (40 ms)
errbar(.8,mean(Med_Rot_AllSubs(:,3)),std(Med_Rot_AllSubs(:,3))/sqrt(nSubs),'k-','LineWidth',lineWidth)
bar(1,mean(Med_Rot_AllSubs(:,4)), barWidth, 'FaceColor',barColor(4,:),'LineWidth',lineWidth) % random/mixed lag condition
errbar(1,mean(Med_Rot_AllSubs(:,4)),std(Med_Rot_AllSubs(:,4))/sqrt(nSubs),'k-','LineWidth',lineWidth)

axis([0.2 1.2 0 125]) 

grid off;
axis square;

set(gca,'FontSize',fontSize);
set(gca,'LineWidth',1.5)
set(gca,'ytick', [0:25:100])
set(gca,'xtick',[.4 .6 .8 1])
set(gca,'xticklabel',{'14','27','40','mixed'});
set(gca,'TickDir','out');
ylabel('Rotational jitter (arcmin)')
xlabel('Viewing Condition')
set(gcf,'Color','w');

% statistical analysis - linear mixed effects model that includes block
% order by subject as a random variable
model = fitlme(dataTableRotationJitterExp2, 'RotationJitter ~ LagCondC + (BlockOrderC|Subject)'); 
disp(model) % displays estimated weights and t-stats and p-values associated with comparisons of 1 frame, 2 frame, and mixed lag conditions relative to 0 added lag condition - additional comparisons can be made by changing the reference lag
stats = anova(model) % provides summary F-statistics
