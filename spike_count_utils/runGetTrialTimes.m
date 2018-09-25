function runGetTrialTimes(varargin)

%%
p = inputParser;
p.addParameter('num', 0, @ischar);
p.addParameter('rawdataDirectory', [],@ischar);
p.addParameter('samplingFrequency',20000,@isnumeric);
p.addParameter('saveDirectory',[],@ischar);
p.addParameter('date',[],@isstr); % date if specified, then the code only looks at folder from that date
p.parse(varargin{:});

%%
num = p.Results.num;
rawdataDirectory = p.Results.rawdataDirectory;
fs = p.Results.samplingFrequency;
saveDirectory = p.Results.saveDirectory;
date = p.Results.date;
%%
if(isempty(rawdataDirectory))
    temp= load('config.mat');
    config = temp.config;
    rawdataDirectory = config.raw.baseaddress;
end

if(isempty(saveDirectory))
    temp= load('config.mat');
    config = temp.config;
    saveDirectory = config.proc.baseaddress;
end
%%

x = str2double(num);

cd(rawdataDirectory)
rdelete('._*')
directories = rdir('*date*','dironly');
disp(length(directories));
for i = 1:length(directories)
disp([rawdataDirectory,directories{i}]);
if(~exist([saveDirectory, directories{i},'/',directories{i},'_trialTimes.mat'],'file'))
    cd([rawdataDirectory,directories{i}]);
    din1 = read_digitalBoard('board-DIGITAL-IN-02.dat');
end 


samp_on = (strfind(din1',[0 1]))*1000/fs; % multiplied by 1000 to convert to ms
if(~exist([saveDirectory,directories{i}],'dir'))
           mkdir([saveDirectory,directories{i}]);
end
save([saveDirectory, directories{i},'/',directories{i},'_trialTimes.mat'],'samp_on');
end
cd ..
end
