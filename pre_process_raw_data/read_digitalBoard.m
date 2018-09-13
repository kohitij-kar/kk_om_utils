function din = read_digitalBoard(filename)
% Intan software saves the digital input lines in seprate files
% This function reads the digital file that has info. related to when the
% sample was turned on
% use:
% din = read_digitalBoard(filename)
% $KK
fileinfo = dir(filename);
num_samples = fileinfo.bytes/2;
fid = fopen(filename,'r');
din= fread(fid, num_samples,'int16');
fclose(fid);
end