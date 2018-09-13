function filtData = applyHP(data,fs,f)
wh = f/(fs/2);
[b,a] = fir1(100,wh,'high');
filtData = filtfilt(b,a,data);