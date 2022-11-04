%%
clc; clear; close all;

noise = 10:5:80;

for n = 1:length(noise)
    
txt_path_name=('src\txtFiles_name');
txt_path_id=('src\txtFiles_id');
audio_path=('src\TEST');

[name_true,name_pred,id_true,id_pred,name_conf,id_conf,name_stat,id_stat] = performanceNSal1(txt_path_name,txt_path_id,audio_path,noise(n));

prec_name(n) = name_stat{5,4};
sens_name(n) = name_stat{6,4};
spec_name(n) = name_stat{7,4};
acc_name(n) = name_stat{8,4};
F_scroe_name(n) = name_stat{9,4};

prec_id(n) = id_stat{5,4};
sens_id(n) = id_stat{6,4};
spec_id(n) = id_stat{7,4};
acc_id(n) = id_stat{8,4};
F_scroe_id(n) = id_stat{9,4};

disp(n);
end
%%

performance_table = zeros(10,15);

performance_table(1,:) = prec_name;
performance_table(2,:) = sens_name;
performance_table(3,:) = spec_name;
performance_table(4,:) = acc_name;
performance_table(5,:) = F_scroe_name;


performance_table(6,:) = prec_id;
performance_table(7,:) = sens_id;
performance_table(8,:) = spec_id;
performance_table(9,:) = acc_id;
performance_table(10,:) = F_scroe_id;

writematrix(performance_table,"F:\DSP PROJECT\FINAL01\performance_table.xlsx");


%%

varnames = ["SNR(dB)"; "Precision"; "Sensitivity"; "Specificity"; "Accuracy"; "F-measure"];
rows = 10:5:80;
rows = rows';
performance_name = table(rows,prec_name',sens_name',spec_name',acc_name',F_scroe_name','VariableNames',varnames)
performance_id = table(rows,prec_id',sens_id',spec_id',acc_id',F_scroe_id','VariableNames',varnames)


%%

% Name_performance Graph

figure;
plot(noise,acc_name);
hold on;
plot(noise,acc_id);
hold off;
legend("Name Accuracy", "ID Accuracy");
xlabel("SNR(dB)");
ylabel("Accuracy");
