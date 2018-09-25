function spikeTime = getSpikeTimes(varargin)
% This function simply thresholds the voltage based on noise levels and detects multi units
% spikeTime = getSpikeTimes(filename, foldername, fs, fLow, fHigh, saveit, MLTPL);
% INPUTS:
% filename = the intan generated .dat file
% foldername = the head foldername where the intan file is located 
% fs = sampling frequency
% fLow = lower cut off for the BP filter
% fHigh= higher cut off for the BP filter  
% saveit = 0 or 1 based on whether u want to save the spikeTime 
% MLTPL = multiples of the noise level used for thresholding .. e.g. 3
% OUTPUTS:
% spikeTime: spikeTimes 
% $KK

p = inputParser;
p.addParameter('filename', 'amp-C-020.dat', @isstr);
p.addParameter('foldername', [], @isstr);
p.addParameter('fs', 20000, @isnumeric);
p.addParameter('fLow', 300, @isnumeric);
p.addParameter('fHigh', 6000, @isnumeric);
p.addParameter('saveit', false, @islogical);
p.addParameter('MLTPL', 3, @isnumeric);
p.parse(varargin{:});

filename = p.Results.filename;
foldername = p.Results.foldername;
fs = p.Results.fs;
fLow = p.Results.fLow;
fHigh = p.Results.fHigh;
saveit = p.Results.saveit;
MLTPL = p.Results.MLTPL;
%% 
    temp= load('config.mat');
    config = temp.config;
    saveDirectory = config.proc.baseaddress;
%%
if(~exist([saveDirectory,foldername,'/spikeTime'],'dir'))
    disp('creating new folder')
    mkdir([saveDirectory,foldername,'/spikeTime']);
end

%%
disp(foldername);
if(~exist([saveDirectory,foldername,'/spikeTime/',filename(1:end-4),'_spk.mat'],'file'))
disp('starting spike detection');
v = getRawData(filename);
%%
nrSegments  = 10;
nrPerSegment = ceil(size(v,1)/nrSegments);
spikeTime = nan;
for i = 1:nrSegments
    disp(i);
    v1 = applyBP(v(i*nrPerSegment - (nrPerSegment-1):i*nrPerSegment),fs,fLow, fHigh);
    cData = v1'-nanmean(v1(:));
    samplingRate = 20000;
    t = 1000*(i*nrPerSegment - nrPerSegment:i*nrPerSegment-1)./samplingRate; % time indices
    noiseLevel =- MLTPL*median(abs(cData))/0.6745;
    outside = (cData) < (noiseLevel); % Spikes in data
    cross   = [outside(1) diff(outside)>0];
    index   = find(cross);
    spikeTime = [spikeTime;t(index)'];    
end
spikeTime(1)=[];

if(saveit)
     save('-v7.3',[saveDirectory,foldername,'/spikeTime/',filename(1:end-4),'_spk.mat'],'spikeTime');
end
end
end
