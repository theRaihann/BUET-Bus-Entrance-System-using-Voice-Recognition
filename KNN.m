%%
clc; clear all; close all;

txt_path_name=('src\txtFiles_name');
txt_path_id=('src\txtFiles_id');
%audio_path=('src\trainingData'); 
audio_path=('src\data_collection_highQ');
folders=dir(audio_path);
speakers = folders(3:end);
MFCC_ORDER = 15;
FRAME_DURATION = 1/50; %1/50 = 20ms
DURATION_LENGTH = 30;
%% Loading Files

mfcc_mat = zeros(length(speakers),(32*15 + 1));
for i=1:length(speakers)
    speakerMatrix=[];
    recordingsPerSpeaker=dir([audio_path,'\',speakers(i).name,'\NAME']);
    recordingsPerSpeaker = recordingsPerSpeaker(3:end);
    for k=(length(recordingsPerSpeaker)-1):length(recordingsPerSpeaker)
        [sampledData,fs]=audioread([audio_path ,'\' ,speakers(i).name ,'\NAME','\' recordingsPerSpeaker(k).name]);
        sampledData = endpointdetectioncode(sampledData);
        sampledData =sampledData' ;
        frameLength=floor(fs *  FRAME_DURATION);
        mfccMatrix = melcepst(sampledData(:,1).', fs, 'M', MFCC_ORDER, frameLength);
%         mfccMatrix = mfccMatrix / max(mfccMatrix);
        speakerMatrix = [speakerMatrix ; mfccMatrix];
    end
%     [temp, ~, ~] =  kmeanlbg(speakerMatrix, 16);
%     disp(size( kmeanlbg(speakerMatrix, 16)));
%     dlmwrite(strcat(txt_path, '\' , speakers(i).name,'_16.txt'), temp, 'delimiter', ' ','newline', 'pc', 'precision',10);
    
    [temp, ~, ~] =  kmeanlbg(speakerMatrix, 32);
    %disp(size( kmeanlbg(speakerMatrix, 32)));
    %dlmwrite(strcat(txt_path, '\' ,speakers(i).name,'_32.txt'), temp, 'delimiter', ' ','newline', 'pc', 'precision',10);
    temp2 = temp';
    temp2 = temp2(:)';
    mfcc_mat(i,:)=[str2double(speakers(i).name) temp2];
end
test_name = mfcc_mat;


%%

mfcc_mat = zeros(length(speakers),(32*15 + 1));
for i=1:length(speakers)
    speakerMatrix=[];
    recordingsPerSpeaker=dir([audio_path,'\',speakers(i).name,'\ID']);
    recordingsPerSpeaker = recordingsPerSpeaker(3:end);
    for k=(length(recordingsPerSpeaker)-1):length(recordingsPerSpeaker)
        [sampledData,fs]=audioread([audio_path ,'\' ,speakers(i).name ,'\ID','\' recordingsPerSpeaker(k).name]);
        sampledData = endpointdetectioncode(sampledData);
        sampledData =sampledData' ;
        frameLength=floor(fs *  FRAME_DURATION);
        mfccMatrix = melcepst(sampledData(:,1).', fs, 'M', MFCC_ORDER, frameLength);
%         mfccMatrix = mfccMatrix / max(mfccMatrix);
        speakerMatrix = [speakerMatrix ; mfccMatrix];
    end
%     disp(size(speakerMatrix));
%     [temp, ~, ~] =  kmeanlbg(speakerMatrix, 16);
%     disp(size( kmeanlbg(speakerMatrix, 16)));
%     dlmwrite(strcat(txt_path, '\' , speakers(i).name,'_16.txt'), temp, 'delimiter', ' ','newline', 'pc', 'precision',10);
    
    [temp, ~, ~] =  kmeanlbg(speakerMatrix, 32);
    %disp(size( kmeanlbg(speakerMatrix, 32)));
    %dlmwrite(strcat(txt_path, '\' ,speakers(i).name,'_32.txt'), temp, 'delimiter', ' ','newline', 'pc', 'precision',10);
    temp2 = temp';
    temp2 = temp2(:)';
    mfcc_mat(i,:)=[str2double(speakers(i).name) temp2];
    
end

test_id = mfcc_mat;



%%
Name_mat  = readmatrix("F:\DSP PROJECT\Text-Dependent-DRAFT02\NAME_MFCC.xlsx");
Id_mat = readmatrix("F:\DSP PROJECT\Text-Dependent-DRAFT02\ID_MFCC.xlsx");

%%
train_name_x = Name_mat(:,2:481);
train_name_y = Name_mat(:,1);

test_name_x = test_name(:,2:481);
test_name_y = test_name(:,1);

train_id_x = Id_mat(:,2:481);
train_id_y = Id_mat(:,1);

test_id_x = test_id(:,2:481);
test_id_y = test_id(:,1);
%%
modeNC=fitcknn(train_name_x,train_name_y,'NumNeighbors',10,'Standardize',true,'Distance','cosine');
modeIC=fitcknn(train_id_x,train_id_y,'NumNeighbors',10,'Standardize',true,'Distance','cosine');

%%
predict_name = predict(modeNC,test_name_x);
predict_id = predict(modeIC,test_id_x);


