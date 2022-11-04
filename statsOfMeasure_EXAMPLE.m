clearvars
clc

%% Load a random Matlab example: iris dataset
load fisheriris

% Randomize the measurements and groups in the data.
rng(0,'twister'); % For reproducibility
numObs = length(species);
p = randperm(numObs);
meas = meas(p,:);
species = species(p);

% Train a discriminant analysis classifier by using measurements in the first half of the data.
half = floor(numObs/16); % I decreased the number of training samples to have more wrong classified examples
% half = floor(numObs/2);
training = meas(1:half,:);
trainingSpecies = species(1:half);
Mdl = fitcdiscr(training,trainingSpecies);

% Predict labels for the measurements in the second half of the data by using the trained classifier.
sample = meas(half+1:end,:);
grouphat = predict(Mdl,sample);

% Specify the group order and display the confusion matrix for the resulting classification.
group = species(half+1:end);
[C,order] = confusionmat(group,grouphat,'Order',{'setosa','versicolor','virginica'});

% I added this line to verify if it works for 2 classes only
% C = C(2:3, 2:3);

% Plot the confusion matrix C
% figure
% confusionchart(C)

%% Use the function you've just downloaded
% stats = statsOfMeasure(C, 1);
% 
% % To access the "false_positive" of the 2nd class
% stats.classes(2,2)

%%

% The input 'confusion' is the the output of the Matlab function
% 'confusionmat'
% if 'verbatim' = 1; output the generated table in the command window
confusion = C;
verbatim = 1;

% confusion: 3x3 confusion matrix
tp = [];
fp = [];
fn = [];
tn = [];
len = size(confusion, 1);
for k = 1:len                  %  predict
    % True positives           % | x o o |
    tp_value = confusion(k,k); % | o o o | true
    tp = [tp, tp_value];       % | o o o |
                                               %  predict
    % False positives                          % | o o o |
    fp_value = sum(confusion(:,k)) - tp_value; % | x o o | true
    fp = [fp, fp_value];                       % | x o o |
                                               %  predict
    % False negatives                          % | o x x |
    fn_value = sum(confusion(k,:)) - tp_value; % | o o o | true
    fn = [fn, fn_value];                       % | o o o |
                                                                       %  predict
    % True negatives (all the rest)                                    % | o o o |
    tn_value = sum(sum(confusion)) - (tp_value + fp_value + fn_value); % | o x x | true
    tn = [tn, tn_value];                                               % | o x x |
end

% Statistics of interest for confusion matrix
prec = tp ./ (tp + fp); % precision
sens = tp ./ (tp + fn); % sensitivity, recall
spec = tn ./ (tn + fp); % specificity
acc = sum(tp) ./ sum(sum(confusion));
f1 = (2 .* prec .* sens) ./ (prec + sens);

% For micro-average
microprec = sum(tp) ./ (sum(tp) + sum(fp)); % precision
microsens = sum(tp) ./ (sum(tp) + sum(fn)); % sensitivity, recall
microspec = sum(tn) ./ (sum(tn) + sum(fp)); % specificity
microacc = acc;
microf1 = (2 .* microprec .* microsens) ./ (microprec + microsens);

% Names of the rows
name = ["true_positive"; "false_positive"; "false_negative"; "true_negative"; ...
    "precision"; "sensitivity"; "specificity"; "accuracy"; "F-measure"];

% Names of the columns
varNames = ["name"; "classes"; "macroAVG"; "microAVG"];

% Values of the columns for each class
values = [tp; fp; fn; tn; prec; sens; spec; repmat(acc, 1, len); f1];

% Macro-average
macroAVG = mean(values, 2);

% Micro-average
microAVG = [macroAVG(1:4); microprec; microsens; microspec; microacc; microf1];

% OUTPUT: final table
stats = table(name, values, macroAVG, microAVG, 'VariableNames',varNames);
if verbatim
    stats;
end