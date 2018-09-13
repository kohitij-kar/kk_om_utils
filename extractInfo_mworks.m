function data = extractInfo_mworks(codecs,filename)
% make sure of three things,
% 1. addpath('/Library/Application Support/MWorks/Scripting/Matlab');
% 2. you should have the .mwk file location as the filename 
% 3. codecs = getCodecs(filename);
% 
events = @(filename,tag) {getEvents(filename,codec_tag2code(codecs.codec,tag))};
%%
sid = events(filename,'sample_image_index'); 
trial_count = events(filename,'trial_count'); 
sample_cat = events(filename,'sample_category_index');
test_cat = events(filename,'test_category_index');
time_at_on = events(filename,'time_at_sample_on');
failure_count =  events(filename,'failure_count');
sucess_count = events(filename,'success_count');
present_time = events(filename,'present_sample_image_duration_ms');
test_on_now = events(filename,'test_on_now');
%% 

samp_id = cat(2,sid{1,1}.data)';
samp_obj = cat(2,sample_cat{1,1}.data)';
dist_obj   = (cat(2,test_cat{1,1}.data))';
prt_val = cat(2,present_time{1,1}.data)';
test_on_time = cat(2,test_on_now{1,1}.time_us);
samp_img_time = cat(2,sid{1,1}.time_us);
samp_obj_time = cat(2,sample_cat{1,1}.time_us);
dist_obj_time = cat(2,test_cat{1,1}.time_us);
prt_time = cat(2,present_time{1,1}.time_us);

%% get the valid trial times

tr_val = cat(2,trial_count{1,1}.data);
tr_time = cat(2,trial_count{1,1}.time_us);
[tr,tr_ind] = unique(tr_val,'first'); 
tr_time = tr_time(tr_ind);tr_time = sort(tr_time)';
tr_time(tr==0)=[];

%% get the trial outcomes

succ_count = cat(2,sucess_count{1,1}.data);
succ_time_us = cat(2,sucess_count{1,1}.time_us);
[sc,ia] = unique(succ_count,'first');
st = succ_time_us(ia); st(sc==0)=[]; sc(sc==0)=[];
success = [st',sc',ones(length(sc),1)];
fail_count = cat(2,failure_count{1,1}.data);
fail_time_us = cat(2,failure_count{1,1}.time_us);
[fc,ia] = unique(fail_count,'first');
ft = fail_time_us(ia); ft(fc==0)=[]; fc(fc==0)=[];
fail = [ft',fc',zeros(length(fc),1)];
trial_outcome = [success;fail];
[~,l]=sort(trial_outcome(:,1));
trial_outcome = trial_outcome(l,:);

%%

sample_img_shown = nan(size(tr_time,1),1);
sample_obj_shown = nan(size(tr_time,1),1);
distractor_obj_shown = nan(size(tr_time,1),1);
samp_validImg= nan(size(tr_time,1),1);
pres_time= nan(size(tr_time,1),1);
test_time = nan(size(tr_time,1),1);
delLoc = cat(2,time_at_on{1,1}.data)==0;
samp_id(delLoc')=[];
samp_img_time(delLoc')=[];
prt_val(delLoc')=[];
prt_time(delLoc')=[];
for i = 1:size(tr_time,1), 
    samp_validImg(i) = find(double(samp_img_time)<double(tr_time(i)),1,'last');
    sample_img_shown(i) = samp_id(samp_validImg(i) );
    distractor_obj_shown(i) = dist_obj(find(double(dist_obj_time)<double(tr_time(i)),1,'last'));
    sample_obj_shown(i) = samp_obj(find(double(samp_obj_time)<double(tr_time(i)),1,'last'));
    pres_time(i) = prt_val(find(double(prt_time)<double(tr_time(i)),1,'last'));
    test_time(i) = test_on_time(find(double(test_on_time)<double(tr_time(i)),1,'last'));
end
rt = (double(trial_outcome(:,1))-test_time)/1000; % in ms

%% data 

data_fulltrials = [sample_img_shown, sample_obj_shown, distractor_obj_shown, trial_outcome(:,3),pres_time,rt];
data_samp_on_only = samp_id; 
data.fullTrial = data_fulltrials;
data.samp_only = [data_samp_on_only,ismember(1:length(data_samp_on_only),samp_validImg)',prt_val];
%%
