% Script that reproduces statistical analyses not associated with figures from Fulvio, Miao, & Rokers - "Head
% jitter enhances 3D motion perception" - Journal of Vision

%% Experiment 1 Behavioral analysis - comparison of target interceptions across conditions

load GrandBehavioralDataTable.mat

offinds = find(dataTable.TrackingCondition==1);
oninds = find(dataTable.TrackingCondition==2);
laggedinds = find(dataTable.TrackingCondition==3);

offinterceptionrate = [mean(dataTable.Interceptions(offinds))*100 std(dataTable.Interceptions(offinds))*100]
oninterceptionrate = [mean(dataTable.Interceptions(oninds))*100 std(dataTable.Interceptions(oninds))*100]
laggedinterceptionrate = [mean(dataTable.Interceptions(laggedinds))*100 std(dataTable.Interceptions(laggedinds))*100]

[h,p,ci,stats] = ttest(dataTable.Interceptions(offinds),dataTable.Interceptions(oninds),'tail','left')
[h,p,ci,stats] = ttest(dataTable.Interceptions(laggedinds),dataTable.Interceptions(oninds),'tail','left')
[h,p,ci,stats] = ttest(dataTable.Interceptions(laggedinds),dataTable.Interceptions(offinds))

%% Experiment 1 Behavioral analysis - comparison of target interceptions as a function of the target's z-motion

load AllSubsTargetZMotionSplitData.mat

intmodel = fitlme(dataTableTargetZMotionSplit, 'Interceptions ~ HeadTrackingC*ZMotionSplitC + (1|Subject)'); 
disp(intmodel)
stats = anova(intmodel) % no interaction between target z-displacement and head-tracking condition, main effect of head-tracking condition

offinds = find(dataTableTargetZMotionSplit.HeadTrackingCondition==1);
oninds = find(dataTableTargetZMotionSplit.HeadTrackingCondition==2);
sminds = find(dataTableTargetZMotionSplit.ZMotionSplit==1);
lginds = find(dataTableTargetZMotionSplit.ZMotionSplit==2);

[h,p,ci,stats] = ttest(dataTableTargetZMotionSplit.Interceptions(intersect(offinds,sminds)),dataTableTargetZMotionSplit.Interceptions(intersect(oninds,sminds))) % small target z-motions; difference in performance with head-tracking off compared to on
[h,p,ci,stats] = ttest(dataTableTargetZMotionSplit.Interceptions(intersect(offinds,lginds)),dataTableTargetZMotionSplit.Interceptions(intersect(oninds,lginds))) % large target z-motions; difference in performance with head-tracking off compared to on


%% Experiment 1 Behavioral analysis - comparison of target depth direction misreports across conditions

load GrandBehavioralDataTable.mat

offinds = find(dataTable.TrackingCondition==1);
oninds = find(dataTable.TrackingCondition==2);
laggedinds = find(dataTable.TrackingCondition==3);

offmisreportrate = [mean(dataTable.Misreports(offinds))*100 std(dataTable.Misreports(offinds))*100]
onmisreportrate = [mean(dataTable.Misreports(oninds))*100 std(dataTable.Misreports(oninds))*100]
laggedimisreportrate = [mean(dataTable.Misreports(laggedinds))*100 std(dataTable.Misreports(laggedinds))*100]

[h,p,ci,stats] = ttest(dataTable.Misreports(offinds),dataTable.Misreports(oninds),'tail','right')


%% Experiment 1 Head jitter statistics

% Translation
load AllSubsHeadJitter.mat

% Average median 3D translations - data for lagged are included and could
% be analyzed as well
AveMed3DTransOff = mean(OffTranslationMedians)
AveMed3DTransOn = mean(OnTranslationMedians)

% Average median translations along the three axes for head-tracking on
% condition as reported in text - data for the head-tracking off and lagged conditions are included and could
% be analyzed as well
AveMedXTransOn = mean(OnTranslationAxisMedians(:,1))
AveMedYTransOn = mean(OnTranslationAxisMedians(:,2))
AveMedZTransOn = mean(OnTranslationAxisMedians(:,3))

% Average median 3D rotations - data for lagged are included and could
% be analyzed as well
AveMed3DRotOff = mean(OffRotationMedians)
AveMed3DRotOn = mean(OnRotationMedians)

% Average median rotations along the three axes for head-tracking on
% condition as reported in text - data for the head-tracking off and lagged conditions are included and could
% be analyzed as well
AveMedPitchRotOn = mean(OnRotationAxisMedians(:,1))
AveMedYawRotOn = mean(OnRotationAxisMedians(:,2))
AveMedRollRotOn = mean(OnRotationAxisMedians(:,3))

%% Experiment 1 Head jitter analysis - probability of head motion opposing the target when head-tracking on

load AllSubsHeadJitterTargetDirectionData.mat
% data also included for head-tracking off and lagged conditions
% -1 corresponds to leftward target/head motion; 1 corresponds to
% rightward target/head motion

for s=1:size(OnStimMotion,1) % subjects
    counts = [0 0]; % same, opposite
    for t=1:size(OnStimMotion,2) % trials
        if OnStimMotion(s,t)==OnHeadJitter(s,t) % head moved in same direction as target motion
            counts(1) = counts(1) + 1;
        elseif OnStimMotion(s,t)~=OnHeadJitter(s,t) % head moved in the opposite direction as target motion
            counts(2) = counts(2) + 1;
        end
    end
    propsame(s) = counts(1) / sum(counts);
    propopposite(s) = counts(2) / sum(counts);
end

[h,p,ci,stats] = ttest(propsame,propopposite), % is head motion more likely to oppose the target's direction?
   
  
%% Experiment 1 Head jitter analysis - performance as a function of small versus large head jitter trials in the lagged condition

load GrandLaggedJitterSizeTable.mat
% JitterCondType codes: 1 = small jitter lagged trials; 2 = head-tracking
% on trials; 3 = head-tracking fixed trials; 4 = large jitter lagged trials
% (like head-tracking on)

sminds = find(dataTable.JitterCondType==1);
lginds = find(dataTable.JitterCondType==4);
oninds = find(dataTable.JitterCondType==2);

[h,p,ci,stats] = ttest(dataTable.Interceptions(sminds),dataTable.Interceptions(lginds)) % was there a difference in performance when head jitter was small versus large on lagged trials?
[h,p,ci,stats] = ttest(dataTable.Interceptions(oninds),dataTable.Interceptions(lginds)) % was there a difference in performance when head jitter was large on lagged trials at magnitudes like that of head-tracking on trials compared to performance on head-tracking on trials?

% were the lags (in frames) different on small and large jitter lagged trials?
[h,p,ci,stats] = ttest(meanlagtimesSmall,meanlagtimesLarge)

%% Experiment 1 Head jitter step-wise glm analysis to determine how translations and rotations factor into behavioral performance

load AllSubsRawInterceptionData.mat

% head-tracking on condition
X = [ontranslationaljitter onrotationaljitter];
y = oninterceptions;
onstepmdl = stepwiseglm(X,y,'linear','upper','linear','Distribution','binomial','Link','logit')

% head-tracking off condition
X = [offtranslationaljitter offrotationaljitter];
y = offinterceptions;
offstepmdl = stepwiseglm(X,y,'linear','upper','linear','Distribution','binomial','Link','logit')

       






