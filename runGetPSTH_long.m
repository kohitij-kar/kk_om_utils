function runGetPSTH_long(num)
addpath(genpath('/home/kohitij/matlab/fileseries'));
addpath(genpath('/home/kohitij/matlab/Ephys_tools'));
disp(num);
disp(class(num));
x = str2double(num);
disp(x);
disp(class(x));
cd('/braintree/data2/active/users/kohitij/raw_data/pre_proc/')
rdelete('._*')
directories = rdir('ko*elay*','dironly');
for i = 1:length(directories)
cd(directories{i});
rdelete('._*')
f = rdir('*_trialTimes.mat','fileonly');
samp_on = nan;
load(f{1});
cd('spikeTime');
rdelete('._*')
F = rdir('amp*.mat','fileonly');
if(length(F)==256 || length(F)==32 && x<length(F))
getPSTH_long(F{x+1},directories{i},samp_on);
cd ../..
else
disp('Not enough files');
cd ../..
end
end
