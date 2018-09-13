function din = read_digitalBoard(filename)
fileinfo = dir(filename);
num_samples = fileinfo.bytes/2;
fid = fopen(filename,'r');
din= fread(fid, num_samples,'int16');
fclose(fid);
end