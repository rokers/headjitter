% Script that reproduces Supplementary Figure 2 of Fulvio, Miao, & Rokers - "Head
% jitter enhances 3D motion perception" - Journal of Vision

%% Supplementary Figure 2: example periodograms of the head jitter traces for three subjects

load AllTracesForFFT.mat; % Supplementary Figure 2 plots the periodograms for subjects 2, 10, and 22 in the head-tracking on condition
% additional traces can be plotted for other subjects or head-tracking conditions - NOTE: these figures are very large and
% may bog things down

subNumbers = [1 2 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 22 23]; % all subjects for which we have reliable head motion traces
figureSubs = [2 10 22]; % three subjects plotted in the supplementary figure

plotColors = [[255 140 0]; [30 144 255]; [220 20 60]]./255; % orange = x, blue = y, red = z

for s=1:length(figureSubs)
    
    snind = find(subNumbers==figureSubs(s));
    
    figure,
    hold on,
    
    for ax = 1:3 % hor, vert, depth
        Y = on_trace_sub{snind}(ax,:)';
        Fs = 75;
        N = length(Y);
        xdft = fft(Y);
        
        totalpower(ax) = sum(xdft.*conj(xdft));
        
        xdft = xdft(1:N/2+1);
        psdx = (1/(Fs*N)) * abs(xdft).^2;
        psdx(2:end-1) = 2*psdx(2:end-1);
        freq = 0:Fs/length(Y):Fs/2;
        reducedrangeinds = 48:19097;% just for plotting .05 Hz - 20 Hz
        
        plot(log10(freq(reducedrangeinds)),10*log10(psdx(reducedrangeinds)),'Color',plotColors(ax,:))
        
    end
    legend('lateral','vertical','depth')
    xlabel('Frequency (Hz)')
    ylabel('Power/Frequency (dB/Hz)')
    axis([log10(.05) log10(25.6) -125 0])
    axis square
    xticks(log10([.05 .1 .2 .4 .8 1.6 3.2 6.4 12.8 25.6]))
    xticklabels({'.05' '.1' '.2' '.4' '.8' '1.6' '3.2' '6.4' '12.8' '25.6'})
    set(gcf,'Color','w')
    set(gca,'TickDir','out')
    set(gca,'LineWidth',1.5)
    title(['S' num2str(figureSubs(s))])
end




