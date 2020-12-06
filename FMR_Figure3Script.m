% Script that reproduces Figure 3 of Fulvio, Miao, & Rokers - "Head
% jitter enhances 3D motion perception" - Journal of Vision

%% Figure 3a: example horizontal and depth translational head jitter

load AllSubsTranslationTraces.mat; % Figure 3a plots the translational jitter of 10 traces from the head-tracking on condition for subject #22 (who is indexed as #20 because the real #3, #21, and #24 were dropped due to excessive tracking errors as indicated in the Methods section)
% additional traces for subject #22 or other subjects can be plotted

figure,
hold on,

rtraces = [92 88 36 109 48 100 80 49 63 115]; % the initially random trace numbers to be plotted were saved and coded for reproducibility
for t = 1:length(rtraces)
    trace = translation_trace_on_sub{rtraces(t),20}; % change index of 20 here to plot other subjects
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

% compute between-subjects 95th percentile ellipse across all subjects and
% traces
Xdir = [];
Zdir = [];
for s=1:size(translation_trace_on_sub,2)
    for t = 1:size(translation_trace_on_sub,1)
        motionmat = translation_trace_on_sub{t,s};
        if ~isempty(motionmat) && size(motionmat,2) > 2
            n = length(motionmat);
            first = motionmat(:,1:(n-1));
            last = motionmat(:,2:n);
            dist = abs(last - first);
            dist_total = sqrt(sum((dist.^2)));
            Xdir = [Xdir (dist(1, dist_total < 0.002))*1000];
            Zdir = [Zdir (dist(3, dist_total < 0.002))*1000];
        end
    end
end

a=prctile(Xdir,95); % horizontal radius (median x translation in mm)
b=prctile(Zdir,95); % vertical radius (median z translation in mm)
x0=0; % x0,y0 ellipse center coordinates
y0=0;
t=-pi:0.01:pi;
x=x0+a*cos(t);
y=y0+b*sin(t);
plot(x,y,'-','LineWidth',2,'Color','k');

axis([-10 10 -10 10]);
grid off;
axis square;
set(gca,'FontSize',18);
set(gca,'LineWidth',1.5)
set(gca,'ytick', [-10:5:10])
set(gca,'xtick',[-10:5:10])
set(gca,'TickDir','out');
xlabel('Horizontal jitter (mm)');
ylabel('Depth jitter (mm)');
set(gcf,'Color','w');


%% Figure 3b: example rotational head jitter (3 axes)

load AllSubsRotationTraces.mat; % Figure 3b plots the rotational jitter of the same 10 traces from the head-tracking on condition for subject #22 (who is indexed as #20 because the real #3, #21, and #24 were dropped due to excessive tracking errors as indicated in the Methods section)
% additional traces for subject #22 or other subjects can be plotted

figure,
hold on,

for a=1:3 % 3 axes of rotation - pitch (x), yaw (y), roll (z)
    
    subplot(3,1,a),
    hold on,
    
    % plotting rotations for the same traces plotted for the translations
    % above
    for t = 1:length(rtraces)
        trace = rotation_trace_on_sub{20,rtraces(t)};
        traceplot = trace(a,:);
        lengths_tp(t) = length(traceplot);
        
        if (length(traceplot) ~= 0)
            plot(traceplot,'-','Color',trace_colors(t,:),'LineWidth',1.5);
        end
    end
    
    rot = [];
    
    % plot the 95th percentile box
    for s=1:size(rotation_trace_on_sub,1)
        for t = 1 : size(rotation_trace_on_sub,2)
            motionmat = rotation_trace_on_sub{s,t};
            if ~isempty(motionmat) && size(motionmat,2) > 2
                n = length(motionmat);
                first = motionmat(:,1:(n-1));
                last = motionmat(:,2:n);
                dist = abs(last - first);
                rot = [rot (dist(a, :))];
            end
        end
    end
    
    rt=prctile(rot,95);
    maxlength = max(lengths_tp);
    
    x = [maxlength-(maxlength-1) maxlength maxlength maxlength-(maxlength-1)];
    y = [rt rt -rt -rt];
    plot([maxlength-(maxlength-1) maxlength],[rt rt], 'k-', 'LineWidth', 1.5); % for combined plot
    plot([maxlength-(maxlength-1) maxlength],[-rt -rt], 'k-', 'LineWidth', 1.5); % for combined plot
    plot([maxlength-(maxlength-1) maxlength-(maxlength-1)], [-rt rt], 'k-', 'LineWidth', 1.5); % for combined plot 
    plot([maxlength maxlength], [-rt rt], 'k-', 'LineWidth', 1.5); % for combined plot 

    axis([-1.5 maxlength+2 -25 20]);
    
    grid off;
    set(gca,'FontSize',8);
    set(gca,'LineWidth',1.5)
    set(gca,'ytick', [-20:20:20])
    set(gca,'xtick',[0:maxlength/4:maxlength])
    set(gca,'xticklabel',{})
    set(gca,'TickDir','out');
    xlabel('time');  
    ylabel('Rotational jitter (arcmin)');
    
end

set(gcf,'Color','w');




