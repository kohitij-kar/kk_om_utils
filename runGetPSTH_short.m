function runGetPSTH(num)
addpath(genpath('/home/kohitij/matlab/fileseries'));
addpath(genpath('/home/kohitij/matlab/Ephys_tools'));
disp(num);
disp(class(num));
x = str2double(num);
disp(x);
disp(class(x));
cd('/mindhive/dicarlolab/u/kohitij/bin/')
rdelete('._*')
directories = rdir('ko*','dironly');
for i = 1:length(directories)
cd(directories{i});
rdelete('._*')
f = rdir('*_trialTimes.mat','fileonly');
samp_on = nan;
load(f{1});
%din = read_digitalBoard('board-DIN-01.dat');
%samp_on = (strfind(din',[0 1]))*1000/20000;
cd('spikeTime');
rdelete('._*')
F = rdir('amp*.mat','fileonly');
if(length(F)==256 || length(F)==32 && x<length(F))
getPSTH_short(F{x+1},directories{i},samp_on);
cd ../..
else
disp('Not enough files');
cd ../..
end
end
