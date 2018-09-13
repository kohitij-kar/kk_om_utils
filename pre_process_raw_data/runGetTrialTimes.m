function runGetTrialTimes(varargin)
%%
addpath(genpath('/home/kohitij/matlab/fileseries'));
addpath(genpath('/home/kohitij/matlab/Ephys_tools'));

%%
p = inputParser;
p.addParameter('num', 0, @ischar);
p.addParameter('rawdataDirectory', '/om/data/public/kohitij',@ischar);
p.addParameter('box','box1',@ischar);
p.addParameter('samplingFrequency',20000,@isnumeric);
p.addParameter('saveDirectory','/braintree/data2/active/users/kohitij/raw_data/pre_proc/',@ischar);
p.parse(varargin{:});

%%
num = p.Results.num;
rawdataDirectory = p.Results.rawdataDirectory;
box = p.Results.box;
fs = p.Results.samplingFrequency;
saveDirectory = p.Results.saveDirectory;

%%

x = str2double(num);

cd([rawdataDirectory,'/open_ephys/',box,'/'])
rdelete('._*')
directories = rdir('*180912*','dironly');
disp(length(directories));
for i = 1:length(directories)
disp([rawdataDirectory, '/open_ephys/',box,'/',directories{i}]);
if(~exist([saveDirectory, directories{i},'/',directories{i},'_trialTimes.mat'],'file'))
cd([rawdataDirectory, '/open_ephys/',box,'/',directories{i}]);
files = rdir('*.dat','fileonly');
digicheck = sum(contains(files,'DIN-'))>0;
switch(box)
   case 'box1'

	if(digicheck)
		din1 = read_digitalBoard('board-DIN-01.dat');
	else
		din1 = read_digitalBoard('board-DIGITAL-IN-02.dat');
	end

   case 'box2'

        if(digicheck)
                din1 = read_digitalBoard('board-DIN-01.dat');
       	else
                din1 = read_digitalBoard('board-DIGITAL-IN-02.dat');
       	end

end 


samp_on = (strfind(din1',[0 1]))*1000/fs; % multiplied by 1000 to convert to ms
%test_on = (strfind(din2',[0 1]))*1000/fs; % multiplied by 1000 to convert to ms
save([saveDirectory, directories{i},'/',directories{i},'_trialTimes.mat'],'samp_on');
end
cd ..
end
