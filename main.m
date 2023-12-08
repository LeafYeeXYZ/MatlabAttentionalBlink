%% 注意瞬脱 / Attentional Blink, AB
%% 指导语：你将会看到一系列快速变换的数字，其中会夹杂两个字母，你需要在看完这些数字和字母后，尽量准确地报告你看到的字母是什么
%% 实验刺激：T1：第一个字母；T2：第二个字母；数字刺激为20个
%% 自变量：T2LagPosition：T2相对T1的位置，1-8，8个水平
%% 无关变量：T1Position：T1出现的位置，5个水平
%% 实验次数：每个T2LagPosition X T1Position进行4次，共8*5*4=160次，分为4个block进行，每个block之间被试有自由休息时间
%% 因变量：T1正确率，T2正确率
%% 刺激物序列
StimulusList = {
    ['A', 'C', 'D', 'E', 'F', 'G', 'H', 'J', 'K', 'L', 'M', 'N', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y'];...
    ['3', '4', '5', '6', '7', '9']};

% 定义实验设计矩阵
dataOri = struct(TrialNumber, [], T1Position, [], T2LagPosition, [],...
    T1Target, [], T2Target, [], T1Response, [], T2Response, [], T1Correct, [], T2Correct, []);
dataCal = struct(Gender, [], Age, [], Time, [],...
    T1Accuracy, [], T2Accuracy, []);

