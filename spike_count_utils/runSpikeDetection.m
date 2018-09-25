function runSpikeDetection(varargin)
% This function runs the spikeDetection function on the folders
% that have the .dat files
% usage:
% runSpikeDetection('num',0,'baseDirectory',/braintree/data2/bla/bla');
% The function produces a separate folder in another directory and dumps
% all the _spk.mat files there. These files have the spike times per 
% channel.
% $KK

%%
p = inputParser;
p.addParameter('num',[],@isstr); % channel number through slurm
p.addParameter('baseDirectory',[],@isstr); % directory where raw data folders are stored
p.addParameter('date',[],@isstr); % date if specified, then the code only looks at folder from that date
p.parse(varargin{:});

%%

num = p.Results.num;
baseDirectory = p.Results.baseDirectory;
date = p.Results.date;

%% 

if(isempty(baseDirectory))
    temp= load('config.mat');
    config = temp.config;
    baseDirectory = config.raw.baseaddress;
end
%% 
x = str2double(num);


	cd(baseDirectory);
	rdelete('._*'); % delete garbage files
	directories = rdir(['*',date,'*'],'dironly');
	for i = 1:length(directories)
		cd(directories{i})
		rdelete('._*');
		files = dir('amp*');
		names = @(s) s.name;
		F = arrayfun(names,files,'UniformOutput',false);
		disp(length(F));
		disp(directories{i});
			if((x+1)<=length(F))
				getSpikeTimes('filename',F{x+1},'foldername',directories{i},'fs',20000,'fLow',300,'fHigh',6000,'saveit',true,'MLTPL',3);
			else
        			disp('not enough files'); 
			end
		cd ..
	end



end


