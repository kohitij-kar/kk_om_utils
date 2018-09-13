function psth = getPSTH(filename,foldername,samp_on)
%load(filename)
%%
if(~exist(['/mindhive/dicarlolab/u/kohitij/bin/',foldername,'/psthShort'],'dir'))
 mkdir(['/mindhive/dicarlolab/u/kohitij/bin/',foldername,'/psthShort'])
end
disp([foldername, ': ', filename])
if(~exist(['/mindhive/dicarlolab/u/kohitij/bin/',foldername,'/psthShort/',filename(1:end-4),'_psth.mat'],'file'))
%% Estimate PSTH
    disp('Starting to estimate PSTH');
    load(filename);
    tb = 2;
    timebins = -100:tb:380;
    psth = nan(length(samp_on),length(timebins));
for i = 1:length(samp_on)
 
    for j = 1:length(timebins)
        psth(i,j) = numel(find(spikeTime>=samp_on(i)+timebins(j)&spikeTime<=samp_on(i)+timebins(j)+tb));
    end
end
save(['/mindhive/dicarlolab/u/kohitij/bin/',foldername,'/psthShort/',filename(1:end-4),'_psth.mat'],'psth');
end
end
