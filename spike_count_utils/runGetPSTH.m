function runGetPSTH(varargin)
% This function runs the getPSTH.m file that is used to compute the psth
% for the given channel
% use:runGetPSTH(varargin)
% inputs are:
% 'num' : channel number, should be a string . like '1'
% 'date'
% 'binsize'
% 'startTime'
% 'stopTime'
%$KK
p = inputParser;
p.addParameter('num',[],@isstr);
p.addParameter('date',[],@isstr);
p.addParameter('binsize',10, @isnumeric);
p.addParameter('startTime',-100,@isnumeric);
p.addParameter('stopTime',380,@isnumeric);
p.parse(varargin{:});
%%
num = p.Results.num;
date= p.Results.date;
binsize =p.Results.binsize;
start = p.Results.start;
stop = p.Results.stop;
x = str2double(num);
%%
    temp= load('config.mat');
    config = temp.config;
    saveDirectory = config.proc.baseaddress;
%%
cd(saveDirectory)

rdelete('._*')
directories = rdir(['*',date,'*'],'dironly');

for i = 1:length(directories)
	cd(directories{i});
	rdelete('._*')
	disp(directories{i});
        %% get trial time data
	f = rdir('*_trialTimes.mat','fileonly');
	samp_on = nan;
	load(f{1});
        %% 
	cd('spikeTime');
	rdelete('._*')
	F = rdir('amp*.mat','fileonly');
    getPSTH('filename',F{x+1},'foldername',directories{i},'samp_on',samp_on,'binSize',binsize, 'startTime', start, 'stopTime',stop);
    cd ../..
       %%
end

end
