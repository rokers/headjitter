% Script that reproduces Figure 2 of Fulvio, Miao, & Rokers - "Head
% jitter enhances 3D motion perception" - Journal of Vision

%% Figure 2a: percentage target interceptions as a function of binned presented direction for the head-tracking on (green) and head-tracking off (blue) conditions

load AllSubsBinnedInterceptionData.mat;
% 24 subjects, 3 head-tracking conditions (two of which are plotted here, used again to plot Figure 4 with all three conditions),
% 21 bins

binsize = 18; % deg
presentedAngleBinCenters = [0:binsize:360];

% some plotting parameters
markerFaceColor = [[0 128 255]; [112 191 65]]./255; % off; on
markerEdgeLineWidth = 2;
lineWidth = 1.5;

figure,
hold on,

% start with all of the line elements in the plot 
plot([180 180],[0 90],'k--','LineWidth',lineWidth)
plot([270 270],[0 90],'k--','LineWidth',lineWidth)

for c=1:2
    errbar(presentedAngleBinCenters,avebinnedInterceptions(c,:),sembinnedInterceptions(c,:),'-','Color',markerFaceColor(c,:),'LineWidth',markerEdgeLineWidth)
    plot(presentedAngleBinCenters,avebinnedInterceptions(c,:),'-','LineWidth',markerEdgeLineWidth,'Color',markerFaceColor(c,:))
end

% add in the circular symbols
for c=1:2
    if c==1
        plot(presentedAngleBinCenters,avebinnedInterceptions(c,:),'o','MarkerSize',10,'MarkerFaceColor','w','MarkerEdgeColor',markerFaceColor(c,:),'LineWidth',markerEdgeLineWidth) % use an open white symbol for fixed
    elseif c==2
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


%% Figure 2b: raw data plots - reported target direction plotted as a function of presented target direction for all trials of all subjects (n = 24)

load AllSubsRawInterceptionData.mat;
% columns: head-tracking off, on, lagged
% rows: individual subject and trial
% NOTE: the raw data for the lagged condition are not plotted in the paper,
% but are plotted with the code below

markerFaceColor = [[0 128 255]; [112 191 65]; [255 38 0]]./255; % off, on, lagged
markerEdgeColor = 'w';
markerEdgeLineWidth = 0.75;

for c=1:3 % plot 3 separate figures
    
    figure,
    hold on,
    
    plot([0 360],[0 360],'k--', 'LineWidth',2) % Positive diagonal reference line
    plot(presentedPaddleAll(:,c),reportedPaddleAll(:,c),'o','MarkerSize',4,'MarkerFaceColor',markerFaceColor(c,:),'MarkerEdgeColor',markerFaceColor(c,:),'LineWidth',markerEdgeLineWidth)
    
    if c==1
        title('Off')
    elseif c==2
        title('On')
    elseif c==3
        title('Lagged')
    end
    
    % Format figure
    axis equal
    axis([-20 380 -20 380])
    
    set(gca,'xtick', [0:90:360]);
    set(gca,'ytick', [0:90:360]);
    set(gca,'FontSize',18);
    set(gca,'LineWidth',1.5)
    set(gca, 'TickDir','out')
    xlabel('Presented direction (deg)')
    ylabel('Reported direction (deg)')
    grid off;
    set(gcf,'Color','w');
    
end



%% Figure 2c: sensitivity (d') and bias (c) plots for the off and on conditions (lagged will be plotted in Figure 4)

% left plot: sensitivity (d')
load AllSubsdPrime.mat;

markerFaceColor = [[0 128 255]; [112 191 65]; [255 38 0]]./255;
markerEdgeLineWidth = 2;
binsize = 15; % deg
presentedAngleBinCenters = [7.5:binsize:360];

% fdr correction comparing head-tracking on to head-tracking off - NOTE: uses fdr_bh.m acquired from the Mathworks file exchange here: https://www.mathworks.com/matlabcentral/fileexchange/27418-fdr_bh
for b=1:size(dprime_fortests,3)
    [h,p,ci,stats] = ttest(squeeze(dprime_fortests(2,:,b)),squeeze(dprime_fortests(1,:,b)),'tail','right');  % is sensitivity (d') larger in the on vs off condition as hypothesized?
    binpvals(b) = p;
end

[h, crit_p, adj_ci_cvrg, adj_p]=fdr_bh(binpvals); % default: alpha = 0.05 level
binhs = h;

[h, crit_p, adj_ci_cvrg, adj_p]=fdr_bh(binpvals,.1); % also check 0.1 level for trending
binhspt1 = h;


% plotting
figure,
hold on,

% start with all the line-based details on the plot
for cc=1:2
    errbar(presentedAngleBinCenters(1:size(dprime_fortests,3)),avedprime(cc,:),semdprime(cc,:),'-','Color',markerFaceColor(cc,:),'LineWidth',markerEdgeLineWidth)
    plot(presentedAngleBinCenters(1:size(dprime_fortests,3)),avedprime(cc,:),'-','LineWidth',2,'Color',markerFaceColor(cc,:))
end

% add in the circular symbols
for cc=1:2
    if cc==1
        plot(presentedAngleBinCenters(1:size(dprime_fortests,3)),avedprime(cc,:),'o','MarkerSize',10,'MarkerFaceColor','w','MarkerEdgeColor',markerFaceColor(cc,:),'LineWidth',markerEdgeLineWidth)
    elseif cc==2 
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

% fdr correction comparing head-tracking on to head-tracking off
for b=1:size(bias_fortests,3)
    [h,p,ci,stats] = ttest(squeeze(bias_fortests(2,:,b)),squeeze(bias_fortests(1,:,b)),'tail','left');  % is bias smaller in the on vs off condition as hypothesized?
    binpvals(b) = p;
end

[h, crit_p, adj_ci_cvrg, adj_p]=fdr_bh(binpvals); % default: alpha = 0.05 level
binhs = h;

[h, crit_p, adj_ci_cvrg, adj_p]=fdr_bh(binpvals,.1); % also check 0.1 level for trending
binhspt1 = h;

% plotting
figure,
hold on,

% start with all the line-based details on the plot
for cc=1:2
    errbar(presentedAngleBinCenters(1:size(bias_fortests,3)),avebias(cc,:),sembias(cc,:),'-','Color',markerFaceColor(cc,:),'LineWidth',markerEdgeLineWidth)
    plot(presentedAngleBinCenters(1:size(bias_fortests,3)),avebias(cc,:),'-','LineWidth',2,'Color',markerFaceColor(cc,:))
end

% add in the circular symbols
for cc=1:2
    if cc==1
        plot(presentedAngleBinCenters(1:size(bias_fortests,3)),avebias(cc,:),'o','MarkerSize',10,'MarkerFaceColor','w','MarkerEdgeColor',markerFaceColor(cc,:),'LineWidth',markerEdgeLineWidth)
    elseif cc==2 
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



