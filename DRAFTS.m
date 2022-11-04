%%         
            % Variable Duration
%             mfccMatrix = melcepst(sampledData(1:length(sampledData),1).', fs, 'M',MFCC_ORDER, fs*FRAME_DURATION);          
%             %Speaker Identification
%             speakerPosition_16 = Euclidean_Distance_Codebook(speakerCodebook16,mfccMatrix);
%             speakerPosition_32 = Euclidean_Distance_Codebook(speakerCodebook32,mfccMatrix);

%             disp(speakerPosition_16);
%             disp(speakerPosition_32);

% audio_path=('src\trainingData');
% folders=dir(audio_path);
% speakers = folders(3:end);
% disp(speakers(speakerPosition_16).name);
% disp(speakers(speakerPosition_32).name);

%%
% clc
% 
% [sampledData,fs] = audioread("F:\DSP PROJECT\Text-Dependent-DRAFT01\src\trainingData\Izaz\3.wav");
% sound(sampledData,fs);
% 
% pause(3);
% 
% disp(size(sampledData));
% 
% sampledData = endpointdetectioncode(sampledData);
% 
% disp(size(sampledData));
% sound(sampledData,fs);


%%
% clc
% 
% txt_path=('src\txtFiles');
% audio_path=('src\trainingData');
% folders=dir(audio_path);
% speakers = folders(3:end);
% i = 1;
%     recordingsPerSpeaker=dir([audio_path,'\',speakers(i).name,'\NAME']);
%     recordingsPerSpeaker = recordingsPerSpeaker(3:end);
% k = 1;
%     [sampledData,fs]=audioread([audio_path ,'\' ,speakers(i).name ,'\NAME','\' recordingsPerSpeaker(k).name]);
% 
% 


%%
% clc;
% 
% txt_path=('src\txtFiles');
% audio_path=('src\trainingData');
% folders=dir(audio_path);
% speakers = folders(3:end);
% MFCC_ORDER = 15;
% FRAME_DURATION = 1/50; %1/50 = 20ms
% 
% % Read Speakers' Codebooks
% for i=1:length(speakers)
%     speakerCodebook16(:,:,i) = dlmread(strcat(txt_path, '\' ,speakers(i,:).name,'_16' ,'.txt'));
%     speakerCodebook32(:,:,i) = dlmread(strcat(txt_path, '\' ,speakers(i,:).name,'_32' ,'.txt'));
% end
% 
% STARTING_SECOND = 1;
% DURATION_STEP = 0.02;
% DURATION_LENGTH = 30;
% duration = STARTING_SECOND+DURATION_STEP : DURATION_STEP : STARTING_SECOND + DURATION_STEP*DURATION_LENGTH;
% disp(duration);
% 
% performance_16 = zeros(1,length(duration));
% performance_32 = zeros(1,length(duration));

%%

% iter = 1;
% confusionMatrix_16=zeros(length(speakers));
% confusionMatrix_32=zeros(length(speakers));
% filesNum = 0;
% i=1;  
%         recordingsPerSpeaker=dir([audio_path,'\',speakers(1).name,'\NAME']);
%         recordingsPerSpeaker = recordingsPerSpeaker(3:end);
%         for j=(length(recordingsPerSpeaker)-2):length(recordingsPerSpeaker)
%             [sampledData,fs]=audioread([audio_path ,'\' ,speakers(1).name ,'\NAME','\' recordingsPerSpeaker(j).name]);
%             sampledData = endpointdetectioncode(sampledData);
%             sampledData =sampledData' ;
%             filesNum = filesNum+1;      
%             % Variable Duration
%             startingSample = ceil(STARTING_SECOND *fs);
%             endingSample = ceil(duration(iter)*fs);
%             mfccMatrix = melcepst(sampledData(1:length(sampledData),1).', fs, 'M',MFCC_ORDER, fs*FRAME_DURATION);          
%             %Speaker Identification
%             speakerPosition_16 = Euclidean_Distance_Codebook(speakerCodebook16,mfccMatrix);
%             speakerPosition_32 = Euclidean_Distance_Codebook(speakerCodebook32,mfccMatrix);   
%             %Updating Confusion Matrix
%             confusionMatrix_16(i, speakerPosition_16)= confusionMatrix_16(i, speakerPosition_16) + 1;
%             confusionMatrix_32(i, speakerPosition_32)= confusionMatrix_32(i, speakerPosition_32) + 1;
%         end
%     
%     % Estimating Overall Performance
% %     performance_16(iter) = (sum(diag(confusionMatrix_16))./filesNum )*100;
% %     performance_32(iter) = (sum(diag(confusionMatrix_32))./filesNum )*100;
%     %Exporting Confusion Matrices
%     dlmwrite(strcat(txt_path, '\_duration',int2str(iter),'_16.txt'), confusionMatrix_16, 'delimiter', ' ','newline', 'pc', 'precision',10);
%     dlmwrite(strcat(txt_path, '\_duration',int2str(iter),'_32.txt'), confusionMatrix_32, 'delimiter', ' ','newline', 'pc', 'precision',10);

%%

% audio_path=('src\trainingData');
% folders=dir(audio_path);
% speakers = folders(3:end);
% IDs = zeros(1,length(speakers));
% 
% for i = 1:length(speakers)
%     IDs(i) = str2double(speakers(i).name);
% end
% 
% ID=input('Enter your student ID (7 digits)==> ','s');
% 
% if ismember(str2double(ID),IDs)
%     disp('yes');
% end


%%
% audio_path=('src\data_collection_highQ');
% folders=dir(audio_path);
% speakers = folders(3:end);
% IDs = zeros(1,length(speakers));
% 
% for i = 1:length(speakers)
%     IDs(i) = str2double(speakers(i).name);
% end
% IDs = IDs';
% freq = zeros(length(IDs),1);
% ID_freq = [IDs freq];
% 
% writematrix(ID_freq,'frequency_test.xlsx','Range','A2:B1000')

%%
% id_freq = readmatrix('frequency_test.xlsx');
% 
% if ismember(id,id_freq(:,1))
%     i = find(id_freq == id);
%     id_freq(i,2) = id_freq(i,2)+1 ;
%     writematrix(id_freq,'frequency_test.xlsx','Range','A2:B1000')
% else
%     disp('Entry is not verified');
% end
% %writematrix(ID,'frequency_test.xlsx','WriteMode','append')


%%

% disp('Start Speaking Name'); % displays the string Start Speaking in command window
%  disp('3');
%  pause(1); disp('2');
%  pause(1); disp('1');
%  disp('NOW!!!');
% sig = audiorecorder(44100,16,1); % Creates an audio object with 44100 sampling rate, 16-bits and 1-audio channel.
% recordblocking(sig,3); % records audio for 3 secs
% disp('Stop Speaking'); % displays the string Stop Speaking in command window
% Name = getaudiodata(sig); % getting data from audio object as a vector
% fsn = 44100;
%%

[Name,fsn] = audioread("F:\DSP PROJECT\FINAL01\src\data_collection_highQ\1806014\NAME\1806014_10.wav");
%sound(Name,fsn);
subplot(411); plot(Name);
Name = awgn(Name,5,'measured');
subplot(412); plot(Name);
[~,Name2] = WienerNoiseReduction(Name,fsn,fsn*0.5);
%subplot(413); plot(Name1);
subplot(414); plot(Name2);

%%

name_conf = confusionmat(name_true,name_pred);
id_conf = confusionmat(id_true,id_pred);

stats_name = statsOfMeasure(name_conf, 1);
stats_id = statsOfMeasure(id_conf, 1);
