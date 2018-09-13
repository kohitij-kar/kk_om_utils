function runGetPSTH(varargin)

p = inputParser;
p.addParameter('num',[],@isstr);
p.addParameter('date',[],@isstr);

p.parse(varargin{:});

num = p.Results.num;
date= p.Results.date;

addpath(genpath('/home/kohitij/matlab/fileseries'));
addpath(genpath('/home/kohitij/matlab/Ephys_tools'));

x = str2double(num);

cd('/braintree/data2/active/users/kohitij/raw_data/pre_proc/')

rdelete('._*')
directories = rdir(['ko*',date,'*'],'dironly');

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
%	if((length(F)==256 || length(F)==32) && x+1<=length(F))
        if((mod(length(F),32)==0&& x+1<=length(F))||(length(F)==1&&x<0))
		getPSTH('filename',F{x+1},'foldername',directories{i},'samp_on',samp_on,'binSize',10, 'startTime', -100, 'stopTime',380);
		cd ../..
	else
		disp('Not enough files');
		cd ../..	
	end
       %%
end

end
