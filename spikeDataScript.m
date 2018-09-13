%%
load('s:/till/matlabclass/spikeData.mat');
%spikeData has the output of sib.getspikes in it...
whos %
%% 
spikeTimes(1:10)

plot(spikeTimes)

min(spikeTimes)
max(spikeTimes)

%%
hist(spikeTimes)
%%
hist(spikeTimes,20)
%%
hist(spikeTimes,50)
%% plotting times against trials
plot(spikeTimes,spikeTrials,'.')
% ylim([0 12])
title('Spike Raster')
%% going from to vectors (in trial time and trial) to a matrix
nrTrials = max(spikeTrials);
maxSpikeTime = max(spikeTimes);
spikeMatrix = zeros(nrTrials,maxSpikeTime);
spikeMatrix(sub2ind([max(spikeTrials) max(spikeTimes)],spikeTrials,spikeTimes)) = 1;
sumSpike = sum(spikeMatrix);
plot(sumSpike)

%% changing to rate:
spikeRate = sumSpike./nrTrials;
plot(spikeRate);
spikeRate = spikeRate*1000; %to convert it to Herz
plot(spikeRate);
%% pause
plot(smooth(spikeRate))
help smooth
plot(smooth(spikeRate,21))
plot(smooth(spikeRate,51))

%% EXERCISE 1: can you do the same for average trialRate (please add labels and a title)?
sumTrial = sum(spikeMatrix,2);
trialRate = (sumTrial./maxSpikeTime)*1000;
plot(trialRate);
plot(smooth(trialRate))



%% sparse
nrEntries = length(spikeTimes);
matrixSize = numel(spikeMatrix);

imagesc(spikeMatrix)
whos spikeMatrix

spikeMatrixSparse = sparse(spikeMatrix);
whos spikeMatrixSparse

%% EXERCISE: what is faster, find for sparse or full?
tic
[i1,j1] = find(spikeMatrix,10,'first');
t1 = toc;
tic
[i2,j2] = find(spikeMatrixSparse,10,'first');
t2 = toc;
['find took ' num2str(t1) 's on a full matrix, ' num2str(t2) 's on a sparse matrix.']
t1 = t1*1000*1000;
t2 = t2*1000*1000;
['find took ' num2str(t1) ' micro sec on a full matrix, ' num2str(t2) ' micro sec on a sparse matrix.']



%% diff
plot(spikeTimesAbs)
ISI = diff(spikeTimesAbs);
plot(ISI)

hist(ISI,0:2:12000)
ISI(ISI>maxSpikeTime) = [];

subplot(2,1,1)
hist(ISI,0:2:maxSpikeTime)
xlim([0 300])
meanISI = mean(ISI);
r = poissrnd(meanISI,1,length(ISI));
subplot(2,1,2)
hist(r,0:2:maxSpikeTime)
xlim([0 300])
%% auto correlation
clf
maxTime = max(spikeTimesAbs);
spikes = zeros(1,maxTime);
spikes(spikeTimesAbs) = 1;
maximumLag = 3000;
autoCorr = xcorr(spikes,maximumLag);
time = -maximumLag:maximumLag;
plot(time,autoCorr)
autoCorr(time==0) = 0; %remove the correlation with itself without a shift.
plot(time,autoCorr)
plot(time,smooth(autoCorr,201))
xlim([-300 300])
%% EXERCISE fitting (home work)
% time scale 1
clf
maximumLag = 300;
autoCorr = xcorr(spikes,maximumLag);
x = (-maximumLag:maximumLag);
autoCorr(x==0) = 0;
smoothAC = smooth(autoCorr,201);

y = smoothAC';
p=polyfit(x,y,2);
yFit = polyval(p,x);

plot(x,smoothAC)
hold on
plot(x,yFit,'r')

%%
%time scale 2
clf
maximumLag = 140;
autoCorr = xcorr(spikes,maximumLag);
x = (-maximumLag:maximumLag);
autoCorr(x==0) = 0;
smoothAC = smooth(autoCorr,101);

y = smoothAC';
y = smoothAC';
p=polyfit(x,y,2);
yFit = polyval(p,x);
% 
p4=polyfit(x,y,4);
yFit4 = polyval(p4,x);
plot(x,smoothAC)
hold on
plot(x,yFit,'r')
plot(x,yFit4,'g')


%% EXERCISE Onset (home work)
rate = smooth(spikeRate,11);
plot(rate)
stdRate = std(rate);
latency = find(rate > stdRate*2.5,1,'first');




