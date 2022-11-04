%%
clc; clear; close;

id_freq =  readmatrix('frequency_test.xlsx');
id = input('Enter your roll:');


if ismember(id,id_freq(:,1))
    i = find(id_freq == id);
    tk = id_freq(i,2)*2;
    disp('Your bill is(tk):');
    disp(tk);
else
    disp('Entry is not verified');
end

