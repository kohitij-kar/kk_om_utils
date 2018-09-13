function psth = getPSTH_long(filename,foldername,samp_on)
disp(foldername)

if(~exist(['/braintree/data2/active/users/kohitij/raw_data/pre_proc/',foldername],'dir'))
 	mkdir(['/braintree/data2/active/users/kohitij/raw_data/pre_proc/',foldername])
end
	if(~exist(['/braintree/data2/active/users/kohitij/raw_data/pre_proc/',foldername,'/psthLong'],'dir'))
		mkdir(['/braintree/data2/active/users/kohitij/raw_data/pre_proc/',foldername,'/psthLong'])
	end

disp([foldername, ': ', filename])

if(~exist(['/braintree/data2/active/users/kohitij/raw_data/pre_proc/',foldername,'/psthLong/',filename(1:end-4),'_psth.mat'],'file'))

%% Estimate PSTH
    disp('Starting to estimate PSTH');
    load(filename);
    tb = 10;
    timebins = -100:tb:1500;
    psth = nan(length(samp_on),length(timebins));
for i = 1:length(samp_on)
 
    for j = 1:length(timebins)
        psth(i,j) = numel(find(spikeTime>=samp_on(i)+timebins(j)&spikeTime<=samp_on(i)+timebins(j)+tb));
    end
end

save(['/braintree/data2/active/users/kohitij/raw_data/pre_proc/',foldername,'/psthLong/',filename(1:end-4),'_psth.mat'],'psth');

end

end
