function psth = getPSTH_1ms(filename,foldername,samp_on)
%load(filename)
%%
if(~exist(['/mindhive/dicarlolab/u/kohitij/bin/',foldername,'/spikeRaster'],'dir'))
 mkdir(['/mindhive/dicarlolab/u/kohitij/bin/',foldername,'/spikeRaster'])
end
disp([foldername, ': ', filename])
if(~exist(['/mindhive/dicarlolab/u/kohitij/bin/',foldername,'/spikeRaster/',filename(1:end-4),'_spikeRaster.mat'],'file'))
%% Estimate PSTH
    disp('Starting to estimate PSTH');
    load(filename);
    tb = 1;
    timebins = -100:tb:380;
    psth = nan(length(samp_on),length(timebins));
for i = 1:length(samp_on)
 
    for j = 1:length(timebins)
        psth(i,j) = numel(find(spikeTime>=samp_on(i)+timebins(j)&spikeTime<=samp_on(i)+timebins(j)+tb));
    end
end
spikeRaster = sparse(psth);
save(['/mindhive/dicarlolab/u/kohitij/bin/',foldername,'/spikeRaster/',filename(1:end-4),'_spikeRaster.mat'],'spikeRaster');
end
end
