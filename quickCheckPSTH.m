function quickCheckPSTH(filename,samp_on)

%% Acquire the raw data from the .dat files
v = getRawData(filename);
v = v(1:10^7);  % i will do the checking only on a small part of the data
disp('Done loading raw data')
v1 = applyBP(v,20000,300,6000);
disp('Done filtering raw data')
cData = v1';
samplingRate = 20000;
t = 1000*(1:length(cData))./samplingRate; % time indices
SHOWTIME = 4000; % show only the first 4000 ms of the data
MLTPL    = 3; 
%% First show the continuous voltage data
figure;
subplot(121);
stay = t<SHOWTIME;
plot(t(stay),cData(stay)); % Plot data between zero and showtime
xlabel 'Time (ms)'
ylabel 'Voltage (uV)'
ylim([-100 100])
%% Let's define the "noise" level as MLTPL*stdev
% Anything below this, we'll consider to be a spike
% noiseLevel = -MLTPL*std(cData);
noiseLevel = MLTPL*median(abs(cData))/0.6745;
hold on
plot(get(gca,'XLim'),[noiseLevel noiseLevel],'r');
journalFigure(0);
title('Sample data');
%% Find the spikes (threshold crossings)
outside = abs(cData) > abs(noiseLevel); % Spikes in data
cross   = [outside(1) diff(outside)>0];
index   = cross;
spikeTime = t(index)';
diffSpkTime = [2;diff(spikeTime)];
delLoc = (diffSpkTime<1.5);
spikeTime(delLoc)=[];
showSpikes = spikeTime(spikeTime<SHOWTIME);
plot(showSpikes,noiseLevel,'g.');

%%

%% Estimate PSTH 
disp('Starting to estimate PSTH');
tb = 10;
timebins = -200:tb:500;
x = nan(64,length(timebins));
for i = 1:length(samp_on)
    cntr = 1;
    for j = timebins
    x(i,cntr) = numel(find(spikeTime>samp_on(i)+j&spikeTime<samp_on(i)+j+30));
    cntr = cntr+1;
    end
end
%%
subplot(122);
plot(timebins,mean(x));
journalFigure(0);
xlabel('Time relative to sample onset (ms)');
ylabel('Firing Rate (a.u)')
title('Sample PSTH');

suptitle(filename);
% saveas(gcf,[filename,'.tiff'],'tiff');
% close all;