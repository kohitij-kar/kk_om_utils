function filtData = applyLP(data,fs,f)

wh = f/(fs/2);
[b,a] = fir1(60,wh,'low');
filtData = filtfilt(b,a,data);