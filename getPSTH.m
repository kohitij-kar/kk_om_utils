function psth = getPSTH(varargin)
% psth = getPSTH(varargin)
% This function estimates the peristimulus time histograms
% you can specify the following
% 'filename'
% 'foldername'
% 'samp_on'
% 'binSize'
% 'startTime'
% 'stopTime'
% 'savePrefix'
% $KK
%%
p = inputParser;
p.addParameter('filename',[],@ischar);
p.addParameter('foldername',[],@ischar);
p.addParameter('samp_on',[],@isnumeric);
p.addParameter('binSize',10,@isnumeric);
p.addParameter('startTime', -100, @isnumeric);
p.addParameter('stopTime', 500,@isnumeric);
p.addParameter('savePrefix','',@isstr);
p.parse(varargin{:});
%%

filename   = p.Results.filename;	
foldername = p.Results.foldername;
samp_on    = p.Results.samp_on;
tb         = p.Results.binSize; 
startTime  = p.Results.startTime;
stopTime   = p.Results.stopTime;
prefix        = p.Results.savePrefix;
%%
if(~exist(['/braintree/data2/active/users/kohitij/raw_data/pre_proc/',foldername,'/psth'],'dir'))
 mkdir(['/braintree/data2/active/users/kohitij/raw_data/pre_proc/',foldername,'/psth'])
end

disp([foldername, ': ', filename])

if(~exist(['/braintree/data2/active/users/kohitij/raw_data/pre_proc/',foldername,'/psth/',filename(1:end-4),prefix,'_psth.mat'],'file'))
%% Estimate PSTH
    disp('Starting to estimate PSTH');
    load(filename);
    timebins = startTime:tb:stopTime;
    psth = nan(length(samp_on),length(timebins));
  for i = 1:length(samp_on)
    for j = 1:length(timebins)
        psth(i,j) = numel(find(spikeTime>=samp_on(i)+timebins(j)&spikeTime<=samp_on(i)+timebins(j)+tb));
    end
  end
meta.startTime = startTime;
meta.stopTime = stopTime;
meta.timebin = tb;
save(['/braintree/data2/active/users/kohitij/raw_data/pre_proc/',foldername,'/psth/',filename(1:end-4),prefix,'_psth.mat'],'psth', 'meta');
end

end
