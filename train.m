clc; clear; close;

audio_path=('src\data_collection_highQ');
folders=dir(audio_path);
speakers = folders(3:end);
IDs = zeros(1,length(speakers));

for i = 1:length(speakers)
    IDs(i) = str2double(speakers(i).name);
end

ID=input('Enter your student ID (7 digits)==> ','s');

if ismember(str2double(ID),IDs)==0
    mkdir (['src','/','data_collection_highQ','/',ID]);
    mkdir(['src','/','data_collection_highQ','/',ID,'/', 'NAME']);
    mkdir(['src','/','data_collection_highQ','/',ID,'/', 'ID']);
end

recordingsPerSpeaker=dir([audio_path,'\',ID,'\NAME']);
p=length(recordingsPerSpeaker)-2;
N=input(' How many train dataset you want to create? ==>');
for i=1:N
    f=[ID '_' int2str(p+i) '.wav'];
    filename=['src/data_collection_highQ/',ID,'/','NAME/',f];
    Entry=train_name(filename);
end
for i=1:N
    f=[ID '_' int2str(p+i) '.wav'];
    filename=['src/data_collection_highQ/',ID,'/','ID/',f];
    Entry=train_id(filename);
end

MFCC_ORDER = 15;
FRAME_DURATION = 1/50;

%%  name_Train();
txt_path=('src\txtFiles_name');
audio_path=('src\data_collection_highQ');
speakerMatrix=[];
recordingsPerSpeaker=dir([audio_path,'\',ID,'\NAME']);
recordingsPerSpeaker = recordingsPerSpeaker(3:end);
for k=1:(length(recordingsPerSpeaker)-3)
[sampledData,fs]=audioread([audio_path ,'\' ,ID ,'\NAME','\' recordingsPerSpeaker(k).name]);
sampledData = endpointdetectioncode(sampledData);
sampledData =sampledData' ;
frameLength=floor(fs *  FRAME_DURATION);
mfccMatrix = melcepst(sampledData(:,1).', fs, 'M', MFCC_ORDER, frameLength);
speakerMatrix = [speakerMatrix ; mfccMatrix];
end
[temp, ~, ~] =  kmeanlbg(speakerMatrix, 32);
dlmwrite(strcat(txt_path, '\' ,ID,'_32.txt'), temp, 'delimiter', ' ','newline', 'pc', 'precision',10);

%% id_train()
txt_path=('src\txtFiles_id');
audio_path=('src\data_collection_highQ');
speakerMatrix=[];
recordingsPerSpeaker=dir([audio_path,'\',ID,'\ID']);
recordingsPerSpeaker = recordingsPerSpeaker(3:end);
for k=1:(length(recordingsPerSpeaker)-3)
    [sampledData,fs]=audioread([audio_path ,'\' ,ID ,'\ID','\' recordingsPerSpeaker(k).name]);
    sampledData = endpointdetectioncode(sampledData);
    sampledData =sampledData' ;
    frameLength=floor(fs *  FRAME_DURATION);
    mfccMatrix = melcepst(sampledData(:,1).', fs, 'M', MFCC_ORDER, frameLength);
    speakerMatrix = [speakerMatrix ; mfccMatrix];
end

[temp, ~, ~] =  kmeanlbg(speakerMatrix, 32);
writematrix(strcat(txt_path, '\' ,ID,'_32.txt'), temp, 'delimiter', ' ','newline', 'pc', 'precision',10);

%% NEW ENTRY FOR FREQUENCY TRACKING


if ismember(str2double(ID),IDs)==0
    entry = [str2double(ID) 0];
    writematrix(entry,'frequency_test.xlsx','WriteMode','append');
    disp('New Entry has been taken successfully');
 else
    disp('New Samples have been taken successfully');
end

