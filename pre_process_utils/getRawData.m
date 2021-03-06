function v = getRawData(filename)
% This function has been created from the intan manual
% v = getRawData(filename);
% filename = raw .dat file from the intan software [I use one file per
% channel format]
% v = bit values converted into microvolts (per sampled time)
% $KK


fileinfo = dir(filename);
num_samples = fileinfo.bytes/2; % int16 = 2 bytes
fid = fopen(filename, 'r');
v = fread(fid, num_samples, 'int16');
fclose(fid);
v = v * 0.195; % convert to microvolts
