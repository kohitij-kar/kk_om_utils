function [muae,muaeTime] = getMUAE(filename,saveit,fs)

rawData = getRawData(filename);
ds_rawData = downsample(rawData,(fs/1000));
hp_data = applyHP(ds_rawData,1000,300);
muae = applyLP(abs(hp_data),1000,5);
if(saveit==1)
    save(['muae_',filename(1:end-4)],'muae');
end
muaeTime = (0:(size(muae,1)-1))';
end

%%
% x = nan(25,601);
% for i = 1:25
%     x(i,1:sum((muaeTime>=samp_on(i)-200)&(muaeTime<=samp_on(i)+400))) = muae((muaeTime>=samp_on(i)-200)&(muaeTime<=samp_on(i)+400));
% end