function filtData = applyLP(data,fs,f)
% This function implements a low pass filter on raw data
% use:
% filtData = applyLP(data,fs,f)
% data = raw data derived from "data = getRawData(filename)"
% fs = sampling frequency in Hz (e.g. 20000)
% f = cutoff for the filter
% $KK
wh = f/(fs/2);
[b,a] = fir1(60,wh,'low');
filtData = filtfilt(b,a,data);