function samp_on= find_sampON(din)
% Thus function finds the time points at which the stimulus came on
    samp_on = strfind(din',[0 1]);
end