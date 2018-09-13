function runGetLFP(varargin)

p = inputParser;
p.addParameter('num',[],@isstr);
p.addParameter('date',[],@isstr);

p.parse(varargin{:});

num = p.Results.num;
date= p.Results.date;

addpath(genpath('/home/kohitij/matlab/fileseries'));
addpath(genpath('/home/kohitij/matlab/Ephys_tools'));

x = str2double(num);

if(x<256)
cd('/braintree/data2/active/users/kohitij/raw_data/open_ephys/box1/')

directories = rdir('ko*date*','dironly');

for i = 1:length(directories)
cd(['/braintree/data2/active/users/kohitij/raw_data/open_ephys/box1/',directories{i}])
F = rdir('amp*.dat','fileonly');
disp(directories{i})
getLFP('filename',F{x+1},'foldername',directories{i});
cd ..
end
else
cd /braintree/data2/active/users/kohitij/raw_data/open_ephys/box2/
directories = rdir('ko*date*','dironly');
for i = 1:length(directories)
cd(['braintree/data2/active/users/kohitij/raw_data/open_ephys/box2/',directories{i}])
F = rdir('amp*.dat','fileonly');
getLFP('filename',F{x+1-256},'foldername',directories{i});
cd ..
end



end

end
