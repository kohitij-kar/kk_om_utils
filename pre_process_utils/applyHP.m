function filtData = applyHP(data,fs,f)
% This function implements a high pass filter on raw data
% use:
% filtData = applyHP(data,fs,f)
% data = raw data derived from "data = getRawData(filename)"
% fs = sampling frequency in Hz (e.g. 20000)
% f = cutoff for the filter
% $KK
wh = f/(fs/2);
[b,a] = fir1(100,wh,'high');
filtData = filtfilt(b,a,data);