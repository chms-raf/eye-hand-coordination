function plotReach(reachNum)

global EyeHandNoFeedback

temp1 = EyeHandNoFeedback.ReachNumber == reachNum - 1;
temp2 = EyeHandNoFeedback.ReachNumber == reachNum;

time1 = EyeHandNoFeedback.Time(temp1);
time2 = EyeHandNoFeedback.Time(temp2);
time = [time1(end-150:end); time2(1:end-50)];

TargetX1 = EyeHandNoFeedback.TargetX(temp1);
TargetX2 = EyeHandNoFeedback.TargetX(temp2);
TargetX = [TargetX1(end-150:end); TargetX2(1:end-50)];

EyeX1 = EyeHandNoFeedback.EyeX_F_NBT_bias(temp1);
EyeX2 = EyeHandNoFeedback.EyeX_F_NBT_bias(temp2);
EyeX = [EyeX1(end-150:end); EyeX2(1:end-50)];

HandX1 = EyeHandNoFeedback.HandX_NBT_bias(temp1);
HandX2 = EyeHandNoFeedback.HandX_NBT_bias(temp2);
HandX = [HandX1(end-150:end); HandX2(1:end-50)];

% save('grantVars.mat','time','TargetX','EyeX','HandX')

figure
plot(time,TargetX)
hold on
plot(time,EyeX)
plot(time,HandX)
xlabel('Time (s)')
ylabel('X-direction')
legend('Target', 'Eye', 'Hand')

end