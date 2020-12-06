% Script that reproduces Supplementary Figure 1 of Fulvio, Miao, & Rokers and associated statistics - "Head
% jitter enhances 3D motion perception" - Journal of Vision

%% Supplementary Figure 1a: example horizontal and depth translational head jitter from tracking error test

load TrackingTestOnTranslationTraces.mat; % Supplementary Figure 1a plots the translational jitter of 10 traces from the head-tracking on condition for the tracking error test
% additional traces can be plotted

figure,
hold on,

rtraces = [92 88 36 109 48 100 80 49 63 115]; % the initially random trace numbers to be plotted were saved and coded for reproducibility
for t = 1:length(rtraces)
    trace = translation_trace_on_test{rtraces(t)}; 
    trace = trace * 1000; % convert from m to mm
    if (length(trace) ~= 0)
        first_X = trace(1,1);
        first_Z = trace(3,1);
        X = trace(1,:) - first_X; % normalize to (0,0) start point
        Z = trace(3,:) - first_Z;
        trace_colors(t,:) = rand(1,3); % NOTE: the colors will vary from the actual figure in the paper
        plot(X,Z,'-','Color',trace_colors(t,:), 'LineWidth', 1.5);
    end
end

% compute 95th percentile ellipse across all traces and reproduce median
% and IQR values listed in the text

% per time sampled time point
Xdir = [];
Ydir = [];
Zdir = [];
% per 1s target interval
sumXdir = [];
sumYdir = [];
sumZdir = [];
    
for t = 1:size(translation_trace_on_test,1)
    motionmat = translation_trace_on_test{t};
    if ~isempty(motionmat) && size(motionmat,2) > 2
        n = length(motionmat);
        first = motionmat(:,1:(n-1));
        last = motionmat(:,2:n);
        dist = abs(last - first);
        dist_total = sqrt(sum((dist.^2)));
        Xdir = [Xdir (dist(1, dist_total < 0.002))*1000]; % convert m to mm
        Ydir = [Ydir (dist(2, dist_total < 0.002))*1000];
        Zdir = [Zdir (dist(3, dist_total < 0.002))*1000];
        sumXdir = [sumXdir sum(dist(1, dist_total < 0.002))*1000];
        sumYdir = [sumYdir sum(dist(2, dist_total < 0.002))*1000];
        sumZdir = [sumZdir sum(dist(3, dist_total < 0.002))*1000];
    end
end

% medians and IQRs - per time point: over all, hor, vert, depth; over the
% course of the 1 s target interval
med_tran_errs = [median([Xdir Ydir Zdir]) median([Xdir]) median([Ydir]) median([Zdir]) median([sumXdir sumYdir sumZdir])]
iqr_tran_errs = [iqr([Xdir Ydir Zdir]) iqr([Xdir]) iqr([Ydir]) iqr([Zdir]) iqr([sumXdir sumYdir sumZdir])]

a=prctile(Xdir,95); % horizontal radius (median x translation in mm)
b=prctile(Zdir,95); % vertical radius (median z translation in mm)
x0=0; % x0,y0 ellipse center coordinates
y0=0;
t=-pi:0.01:pi;
x=x0+a*cos(t);
y=y0+b*sin(t);
plot(x,y,'--','LineWidth',2,'Color','k');

axis([-.843 .843 -.693 .693]);
grid off;
axis square;
set(gca,'FontSize',18);
set(gca,'LineWidth',1.5)
set(gca,'ytick', [-.69:.69:.69])
set(gca,'xtick',[-.84:.84:.84])
set(gca,'TickDir','out');
xlabel('Horizontal jitter (mm)');
ylabel('Depth jitter (mm)');
set(gcf,'Color','w');


%% Supplementary Figure 1b: example rotational head jitter (3 axes) from tracking error test

load TrackingTestOnRotationTraces.mat; % Supplementary Figure 1b plots the rotational jitter of the same 10 traces from the head-tracking on condition for the tracking error test
% additional traces can be plotted

figure,
hold on,

for a=1:3 % 3 axes of rotation - pitch (x), yaw (y), roll (z)
    
    subplot(3,1,a),
    hold on,
    
    % plotting rotations for the same traces plotted for the translations
    % above
    for t = 1:length(rtraces)
        trace = rotation_trace_on_test{rtraces(t)};
        traceplot = trace(a,:);
        lengths_tp(t) = length(traceplot);
        
        if (length(traceplot) ~= 0)
            plot(traceplot,'-','Color',trace_colors(t,:),'LineWidth',1.5);
        end
    end
    
    rot = [];
    total_rot = [];
    
    % plot the 95th percentile box
    for t = 1 : size(rotation_trace_on_test,2)
        motionmat = rotation_trace_on_test{t};
        if ~isempty(motionmat) && size(motionmat,2) > 2
            n = length(motionmat);
            first = motionmat(:,1:(n-1));
            last = motionmat(:,2:n);
            dist = abs(last - first);
            rot = [rot (dist(a, :))];
            total_rot = [total_rot sum(abs(dist(a,:)))];
        end
    end
    
    if a==1
        rotpitch = rot; 
        totalrotpitch = total_rot; 
    elseif a==2
        rotyaw = rot;
        totalrotyaw = total_rot; 
    elseif a==3
        rotroll = rot;
        totalrotroll = total_rot; 
    end
    
    rt=prctile(rot,95);
    maxlength = max(lengths_tp);
    
    x = [maxlength-(maxlength-1) maxlength maxlength maxlength-(maxlength-1)];
    y = [rt rt -rt -rt];
    plot([maxlength-(maxlength-1) maxlength],[rt rt], 'k--', 'LineWidth', 1.5); % for combined plot
    plot([maxlength-(maxlength-1) maxlength],[-rt -rt], 'k--', 'LineWidth', 1.5); % for combined plot
    plot([maxlength-(maxlength-1) maxlength-(maxlength-1)], [-rt rt], 'k--', 'LineWidth', 1.5); % for combined plot 
    plot([maxlength maxlength], [-rt rt], 'k--', 'LineWidth', 1.5); % for combined plot 

    axisvals = [4 2.36 2.57];
    axis([-1.5 length(traceplot) -axisvals(a) axisvals(a)]);

    grid off;
    set(gca,'FontSize',8);
    set(gca,'LineWidth',1.5)
    set(gca,'ytick', [-axisvals(a):axisvals(a):axisvals(a)])
    set(gca,'xtick',[0:maxlength/4:maxlength])
    set(gca,'xticklabel',{})
    set(gca,'TickDir','out');
    xlabel('time');
    ylabel('Rotational jitter (arcmin)');
    
    
end

set(gcf,'Color','w');

% medians and IQRs - per time point: over all, pitch, yaw, roll; over the
% 1s target interval
med_rot_errs = [median([rotpitch rotyaw rotroll]) median([rotpitch]) median([rotyaw]) median([rotroll]) median([totalrotpitch totalrotyaw totalrotroll])]
iqr_rot_errs = [iqr([rotpitch rotyaw rotroll]) iqr([rotpitch]) iqr([rotyaw]) iqr([rotroll]) iqr([totalrotpitch totalrotyaw totalrotroll])]





