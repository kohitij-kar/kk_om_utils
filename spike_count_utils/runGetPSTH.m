function runGetPSTH(varargin)

p = inputParser;
p.addParameter('num',[],@isstr);
p.addParameter('date',[],@isstr);

p.parse(varargin{:});

num = p.Results.num;
date= p.Results.date;

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
    getPSTH('filename',F{x+1},'foldername',directories{i},'samp_on',samp_on,'binSize',10, 'startTime', -100, 'stopTime',380);
    cd ../..
       %%
end

end
