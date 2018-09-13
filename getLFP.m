function [lfp,lfpTime] = getLFP(varargin)

p = inputParser;
p.addParameter('filename',[],@ischar);
p.addParameter('foldername',[],@ischar);
p.addParameter('fs',20000,@isnumeric);
p.addParameter('savePrefix','',@isstr);
p.addParameter('saveit',1,@isnumeric);
p.parse(varargin{:});
%%

filename   = p.Results.filename;
foldername = p.Results.foldername;
fs         = p.Results.fs;
prefix     = p.Results.savePrefix;
saveit     = p.Results.saveit;

if(~exist(['/braintree/data2/active/users/kohitij/raw_data/pre_proc/',foldername,'/lfp'],'dir'))
 mkdir(['/braintree/data2/active/users/kohitij/raw_data/pre_proc/',foldername,'/lfp'])
end

if(~exist(['/braintree/data2/active/users/kohitij/raw_data/pre_proc/',foldername,'/lfp/',filename(1:end-4),prefix,'_lfp.mat'],'file'))

rawData = getRawData(filename);

ds_rawData = downsample(rawData,(fs/1000)); % downsample to 1 kHz
lfp = applyLP(ds_rawData,1000,300);         % low pass below 300 Hz
lfpTime = (0:(size(lfp,1)-1))';
meta.lpass = 300;
meta.fs = 1000;
if(saveit==1)
	save(['/braintree/data2/active/users/kohitij/raw_data/pre_proc/',foldername,'/lfp/',filename(1:end-4),prefix,'_lfp.mat'],'lfp', 'meta');
end

end
end
