
function filtData = applyBP(data,fs,fLow, fHigh)
% This function implements a bandpass filter
% filtData = applyBP(data,fs, fLow, fHigh);
% INPUT:
% data = rawData that has been created by "data = getRawData(filename);"
% fs = sampling frequency; 20000 Hz for current set up
% fLow = lower bound of the filter
% fHigh = higher bound of the filter
% OUTPUT:
% filtData = filtered data
% $KK 



wl = fLow/(fs/2);
wh = fHigh/(fs/2);
wn = [wl wh];
% [b,a] = fir1(54,wn,'bandpass');
[b,a] = ellip(2,0.1,40,wn);

filtData = filtfilt(b,a,data);
