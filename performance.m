function[name_true,name_pred,id_true,id_pred,name_conf,id_conf,name_stat,id_stat] = performance(txt_path_name,txt_path_id,audio_path,noise)

folders=dir(audio_path);
speakers = folders(3:end);
MFCC_ORDER = 15;
FRAME_DURATION = 1/50; %1/50 = 20ms
DURATION_LENGTH = 10;

% Read Speakers' Name Codebooks
for i=1:length(speakers)
    speakerCodebook32_name(:,:,i) = readmatrix(strcat(txt_path_name, '\' ,speakers(i,:).name,'_32' ,'.txt'));
end

for i=1:length(speakers)
    speakerCodebook32_id(:,:,i) = readmatrix(strcat(txt_path_id, '\' ,speakers(i,:).name,'_32' ,'.txt'));
end

c = 0;
m = 0;
for i=1:length(speakers)
    test_path=[audio_path,'\',speakers(i).name];
    test_name = dir([test_path,'\','Name']);
    test_id = dir([test_path,'\','ID']);
    test_name = test_name(3:end);
    test_id = test_id(3:end);
    acc = 0;
    L = length((length(test_name)-2):(length(test_name)));
    c = c+1;
    m = m+1;
    for k=(length(test_name)-2):(length(test_name))
        
        [Name,fsn]=audioread([test_path,'\NAME','\' test_name(k).name]);
        Name = awgn(Name,noise,'measured');
        [Id,fsd] = audioread([test_path,'\ID','\' test_id(k).name]);
        Id = awgn(Id,noise,'measured');
        Name = endpointdetectioncode(Name);
        Name = Name';
        mn = floor((length(Name)-1)/DURATION_LENGTH);
        Id = endpointdetectioncode(Id);
        Id = Id';
        md = floor((length(Id)-1)/DURATION_LENGTH);

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

        if length(sp32n)>1
%             disp([test_path,'\NAME','\' test_name(k).name]);
%             disp(speakers(sp32n(1)).name);
%             disp(speakers(sp32n(2)).name);
            sp32n = min(sp32n);

        end
        name_pred(c) = str2double(speakers(sp32n).name);
        name_true(c) = str2double(speakers(i).name);
        c = c+1;

        confusionMatrix_32_id=zeros(1,length(speakers));
        for iter = 1:DURATION_LENGTH
            % Variable Duration
            startingSample = 1;
            endingSample = md*iter;
            mfccMatrix = melcepst(Id(startingSample:endingSample,1).', fsd, 'M',MFCC_ORDER, fsd*FRAME_DURATION);
            [temp, ~, ~] =  kmeanlbg(mfccMatrix, 32);
            speakerPosition_32 = Euclidean_Distance_Codebook(speakerCodebook32_id,temp);   
            confusionMatrix_32_id(1, speakerPosition_32)= confusionMatrix_32_id(1, speakerPosition_32) + 1;
        end
        
        sp32d = find(confusionMatrix_32_id == max(confusionMatrix_32_id));
        if length(sp32d)>1
%             disp([test_path,'\ID','\' test_id(k).name]);
%             disp(speakers(sp32d(1)).name);
%             disp(speakers(sp32d(2)).name);
            sp32d = min(sp32d);

        end
        id_pred(m) = str2double(speakers(sp32d).name);
        id_true(m) = str2double(speakers(i).name);
        m = m+1;
        if sp32d==sp32n && sp32d==i && sp32n==i
            acc = acc+1; 
          
        end
   
    end

end
name_true =  name_true(find(name_true~=0));
name_pred = name_pred(find(name_pred~=0));

id_true = id_true(find(id_true~=0));
id_pred = id_pred(find(id_pred~=0));

name_conf = confusionmat(name_true,name_pred);
id_conf = confusionmat(id_true,id_pred);

name_stat = statsOfMeasure(name_conf, 0);
id_stat = statsOfMeasure(id_conf,0);

end
