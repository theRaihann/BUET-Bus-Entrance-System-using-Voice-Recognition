
clear;
clc;
%% ------------------------------ Training: Inputs ------------------------------------
txt_path=('src\txtFiles_id');
audio_path=('src\data_collection_highQ');
folders=dir(audio_path);
speakers = folders(3:end);
MFCC_ORDER = 15;
FRAME_DURATION = 1/50; %1/50 = 20ms frame length
%% --------------------------   Training: MFCC  ------------------------------------
mfcc_mat = zeros(length(speakers),(32*15 + 1));
for i=1:length(speakers)
    speakerMatrix=[];
    recordingsPerSpeaker=dir([audio_path,'\',speakers(i).name,'\ID']);
    recordingsPerSpeaker = recordingsPerSpeaker(3:end);
    for k=1:(length(recordingsPerSpeaker)-3)
        [sampledData,fs]=audioread([audio_path ,'\' ,speakers(i).name ,'\ID','\' recordingsPerSpeaker(k).name]);
        sampledData = endpointdetectioncode(sampledData);
        sampledData =sampledData' ;
        frameLength=floor(fs *  FRAME_DURATION);
        mfccMatrix = melcepst(sampledData(:,1).', fs, 'M', MFCC_ORDER, frameLength);
        speakerMatrix = [speakerMatrix ; mfccMatrix];
    end
    
    [temp, ~, ~] =  kmeanlbg(speakerMatrix, 32);
    dlmwrite(strcat(txt_path, '\' ,speakers(i).name,'_32.txt'), temp, 'delimiter', ' ','newline', 'pc', 'precision',10);
    temp2 = temp';
    temp2 = temp2(:)';
    mfcc_mat(i,:)=[str2double(speakers(i).name) temp2];
    
end

writematrix(mfcc_mat,'ID_MFCC.xlsx');
