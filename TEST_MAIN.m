%%
clc; clear; close all;

txt_path_name=('src\txtFiles_name');
txt_path_id=('src\txtFiles_id');
audio_path=('src\data_collection_highQ');
folders=dir(audio_path);
speakers = folders(3:end);
MFCC_ORDER = 15;
FRAME_DURATION = 1/50; %1/50 = 20ms
DURATION_LENGTH = 10;

%%

% Read Speakers' Name Codebooks
for i=1:length(speakers)
    speakerCodebook32_name(:,:,i) = readmatrix(strcat(txt_path_name, '\' ,speakers(i,:).name,'_32' ,'.txt'));
end

for i=1:length(speakers)
    speakerCodebook32_id(:,:,i) = readmatrix(strcat(txt_path_id, '\' ,speakers(i,:).name,'_32' ,'.txt'));
end

%%

%[Name,fsn] = audioread("F:\DSP PROJECT\FINAL01\src\data_collection_highQ\1806014\NAME\1806014_10.wav");

disp('Start Speaking Name'); % displays the string Start Speaking in command window
 disp('3');
 pause(1); disp('2');
 pause(1); disp('1');
 disp('NOW!!!');
sig = audiorecorder(44100,16,1); % Creates an audio object with 44100 sampling rate, 16-bits and 1-audio channel.
recordblocking(sig,3); % records audio for 3 secs
disp('Stop Speaking'); % displays the string Stop Speaking in command window
Name = getaudiodata(sig); % getting data from audio object as a vector
fsn = 44100;
pause(3);

Name = endpointdetectioncode(Name);
Name = Name';
mn = floor((length(Name)-1)/DURATION_LENGTH);


%%

%[ID,fsd] = audioread("F:\DSP PROJECT\FINAL01\src\data_collection_highQ\1806014\ID\1806014_9.wav");

disp('Start Speaking ID'); % displays the string Start Speaking in command window
 disp('3');
 pause(1); disp('2');
 pause(1); disp('1');
 disp('NOW!!!');
sig = audiorecorder(44100,16,1); % Creates an audio object with 44100 sampling rate, 16-bits and 1-audio channel.
recordblocking(sig,3); % records audio for 3 secs
disp('Stop Speaking'); % displays the string Stop Speaking in command window
ID = getaudiodata(sig); % getting data from audio object as a vector
fsd = 44100;

ID = endpointdetectioncode(ID);
ID = ID';
md = floor((length(ID)-1)/DURATION_LENGTH);


%% NAME CHECK

confusionMatrix_32_name=zeros(1,length(speakers));
for iter = 1:DURATION_LENGTH
            % Variable Duration
            startingSample = 1;
            endingSample = mn*iter;
            mfccMatrix = melcepst(Name(startingSample:endingSample,1).', fsn, 'M',MFCC_ORDER, fsn*FRAME_DURATION); 
            [temp, ~, ~] =  kmeanlbg(mfccMatrix, 32);
            speakerPosition_32 = Euclidean_Distance_Codebook(speakerCodebook32_name,temp);   
            confusionMatrix_32_name(1, speakerPosition_32)= confusionMatrix_32_name(1, speakerPosition_32) + 1;
   
end


sp32n = find(confusionMatrix_32_name == max(confusionMatrix_32_name));

audio_path=('src\data_collection_highQ');
folders=dir(audio_path);
speakers = folders(3:end);
disp(speakers(sp32n).name);


%% ID CHECK

confusionMatrix_32_id=zeros(1,length(speakers));
for iter = 1:DURATION_LENGTH
            % Variable Duration
            startingSample = 1;
            endingSample = md*iter;
            mfccMatrix = melcepst(ID(startingSample:endingSample,1).', fsd, 'M',MFCC_ORDER, fsd*FRAME_DURATION);
            [temp, ~, ~] =  kmeanlbg(mfccMatrix, 32);
            speakerPosition_32 = Euclidean_Distance_Codebook(speakerCodebook32_id,temp);   
            confusionMatrix_32_id(1, speakerPosition_32)= confusionMatrix_32_id(1, speakerPosition_32) + 1;
end

sp32d = find(confusionMatrix_32_id == max(confusionMatrix_32_id));

audio_path=('src\data_collection_highQ');
folders=dir(audio_path);
speakers = folders(3:end);
disp(speakers(sp32d).name);




%% Access

id_freq = readmatrix('frequency_test.xlsx');
id = str2double(speakers(sp32d).name);
if speakers(sp32d).name == speakers(sp32n).name
        i = find(id_freq == id);
        id_freq(i,2) = id_freq(i,2)+1 ;
        writematrix(id_freq,'frequency_test.xlsx','Range','A2:B1000')
        disp('Welcome to the bus service')
else
    disp('Access denied');
end











