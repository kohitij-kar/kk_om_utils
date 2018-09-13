% Demonstrating spike detection, clustering, and sorting with Principal Components Analysis.
%
% BK March 2011

% load pcaData
%%
t = 1000*(1:length(cData))./samplingRate;

SHOWTIME = 2000;
MLTPL    = 2;
%% First show the continuous voltage data
figure(1);
clf;
stay = t<SHOWTIME;
plot(t(stay),cData(stay)); % Plot data between zero and showtime
xlabel 'Time (ms)'
ylabel 'Voltage'

%% Let's define the "noise" level as MLTPL*stdev
% Anything below this, we'll consider to be a spike
noiseLevel = -MLTPL*std(cData);
hold on
plot(get(gca,'XLim'),[noiseLevel noiseLevel],'r');


%% Find the spikes (threshold crossings)
outside = cData < noiseLevel; % Spikes in data
cross   = [outside(1) diff(outside)>0];
index   = find(cross);
spikeTime = t(index)';
showSpikes = spikeTime(spikeTime<SHOWTIME);
plot(showSpikes,noiseLevel,'g*');


%% Exercise
% What if you want to select spikes that cross the noise level 
% either above OR below the mean?  Write a function using the code above 
% such that it can select any noise crossing. 
% The function takes two arguments: 
%  the cData, and a multiple of the standard deviation (e.g. 3 above) 
% The function retuns the indices for the spikes that cross the positive noiseLevel
% and the spikes that cross the negative noiseLevel. (i.e. it has two output arguments).
% You should be able to call your function as:
[ixAbove,ixBelow]= detectSpikes(cData,3);
% Once you have your function, use it to plot the detections on top of 
% the raw data. (similar to the asterisks above).
spikeTimeAbove = t(ixAbove)';
spikeTimeBelow = t(ixBelow)';
showSpikesAbove = spikeTimeAbove(spikeTimeAbove<SHOWTIME);
showSpikesBelow = spikeTimeBelow(spikeTimeBelow<SHOWTIME);
plot(showSpikesAbove,-noiseLevel,'g*',showSpikesBelow,noiseLevel,'c*');
% Extra: avoid detecting the same spike twice by returning only those 
% indices that are more than minSamples samples apart.
%

%% Extract the spikes 
% Extract the spike waveforms (7 samples before and 32 samples after the
% detection). 

samples = -7:32;
nrSpikes = length(spikeTime);
IX = repmat(index',[1 length(samples)]) + repmat(samples,[nrSpikes 1]);
IX (IX<1) = 1;
IX (IX>length(cData)) = length(cData);
spikes = cData(IX)';

figure(2);
clf
plot(samples,spikes)
xlabel 'Samples since Threshold Crossing'
ylabel 'Voltage'
hold on

%% Spike sorting by trough size 
% Find the trough (negative peak amplitude in voltage) for each spike
feature = min(spikes);
figure(3);
clf
subplot(2,1,1);
hist(feature,50);
xlabel 'Feature'
ylabel '#Spikes'

%% Try to separate on the basis of size.
cutoff = -4000; % The dip.(read from the hist)
classA = spikes(:,feature<cutoff);
classB = spikes(:,feature>=cutoff);
meanA  = mean(classA,2);
meanB  = mean(classB,2);
stdA   = std(classA,1,2);
stdB   = std(classB,1,2);

figure(3);
subplot(2,1,2);
hold on

h1 = plot(samples,meanA,'r');
plot(samples,meanA+stdA,'r:');
plot(samples,meanA-stdA,'r:');
h2 = plot(samples,meanB,'g');
plot(samples,meanB+stdB,'g:');
plot(samples,meanB-stdB,'g:');
xlabel 'Sample since threshold crossing'
ylabel 'Voltage'
legend([h1 h2],'Unit A','Unit B')


%% Exercise. Follow the same steps for other features that may help to separate spikes into classes:
% a. The Peak value.
featureMax = max(spikes);
figure(5);
clf
subplot(2,1,1);
hist(featureMax,50);
xlabel 'Feature'
ylabel '#Spikes'

% b. The difference in voltage between peak and trough
featureDiff = max(spikes)-min(spikes);
figure(6);
clf
subplot(2,1,1)
hist(featureDiff,50);
set(gca,'XTick',0:1000:25000);
xlabel 'Feature'
ylabel '#Spikes'

cutoff1 = 7000; % The dip.(read from the hist)
cutoff2 = 13000;
classA = spikes(:,featureDiff<cutoff1);
classB = spikes(:,cutoff1<=featureDiff<cutoff2);
classC = spikes(:,featureDiff>=cutoff2);
meanA  = mean(classA,2);
meanB  = mean(classB,2);
meanC  = mean(classC,2);
stdA   = std(classA,1,2);
stdB   = std(classB,1,2);
stdC   = std(classC,1,2);

figure(6);
subplot(2,1,2);
hold on

h1 = plot(samples,meanA,'r');
plot(samples,meanA+stdA,'r:');
plot(samples,meanA-stdA,'r:');
h2 = plot(samples,meanB,'g');
plot(samples,meanB+stdB,'g:');
plot(samples,meanB-stdB,'g:');
h3 = plot(samples,meanC,'b');
plot(samples,meanC+stdC,'b:');
plot(samples,meanC-stdC,'b:');
xlabel 'Sample since threshold crossing'
ylabel 'Voltage'
legend([h1 h2],'Unit A','Unit B','Unit C')

%%  PCA.
% peak,trough and other features are ad-hoc (although they could be based
% on biophysics in this case). Use PCA to let the data decide on
% "interesting" features.
%
[components,projections,variance] = princomp(spikes');

figure(4);
clf
subplot(2,2,1)
% Show the first three principal components
hold on
plot(samples,components(:,1),'r')
plot(samples,components(:,2),'g')
plot(samples,components(:,3),'b')
xlabel 'Sample'
ylabel 'Value'
legend('#1','#2','#3');

subplot(2,2,2);
%Show the cumulative explained variance for each component.
variance = 100*variance./sum(variance);
plot(cumsum(variance));
set(gca,'YLim',[0 100])
xlabel 'Component'
ylabel 'Explained Variance (%)'

subplot(2,2,3)
% Show each spike as a projection on the first two PCs
plot(projections(:,1),projections(:,2),'.')
xlabel 'Projection onto Component #1'
ylabel 'Projection onto Component #2'
hold on

%% Manually Select clusters and plot mean
color = 'rgm';
for i=1:3
    subplot(2,2,3);
    [x,y] =ginput; % Draw a polygon by clicking its vertices until you press Enter   
    IN = inpolygon(projections(:,1),projections(:,2),x,y); % Determine which points are inside the polygon
    % Cross-out the spikes that were inside the polygon
    plot(projections(IN,1),projections(IN,2),[color(i) 'x']);
    
    
    % Determine the mean waveform for this class/unit    
    subplot(2,2,4);
    hold on
    m   = mean(spikes(:,IN),2);
    sd = std(spikes(:,IN),1,2);
    plot(samples,m,color(i));
    plot(samples,m+sd,[color(i) ':']);
    plot(samples,m-sd,[color(i) ':']);
    
end
xlabel 'Sample'
ylabel 'Average Waveform'

%%
% Use a non manual method. 
% If we know the number of clusters, K-Means is a simple but effective
% technique:
nrClusters= 3;
dimensions = 1:2;
[unit,c] =kmeans(projections(:,dimensions),nrClusters,'Replicates',10);
figure(4);
subplot(2,2,4);cla;
xlabel 'Sample'
ylabel 'Average Waveform'

subplot(2,2,3);cla;
plot(projections(:,1),projections(:,2),'.')
hold on

for i=1:3
    IN = unit==i;
    subplot(2,2,3);
    plot(projections(IN,1),projections(IN,2),[color(i) 'x']);
     
    m   = mean(spikes(:,IN),2);
    sd = std(spikes(:,IN),1,2);
    
    subplot(2,2,4);
    hold on
    plot(samples,m,color(i));
    plot(samples,m+sd,[color(i) ':']);
    plot(samples,m-sd,[color(i) ':']);
end


subplot(2,2,3);
h = plot(c(:,1),c(:,2),'ko');
set(h,'MarkerSize',10,'LineWidth',4);
