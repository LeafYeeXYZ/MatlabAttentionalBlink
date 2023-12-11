% 注意瞬脱实验程序
% 作者：Bing
% 日期：2023年12月11日
% 说明：这是一个简单的注意瞬脱实验程序，使用Psychtoolbox-3来呈现刺激和收集反应。
%       请根据你的需要和偏好修改参数和设置。

% 清除工作空间和命令窗口
clear;
clc;

% 设置随机数种子
rng('shuffle');

% 设置实验参数
nLetters = 2; % 字母的数量
nNumbers = 20; % 数字的数量
nStimuli = nLetters + nNumbers; % 刺激的总数量
letterPosRange = [5, 9]; % 第一个字母的位置范围
letterDistRange = [1, 8]; % 第二个字母与第一个字母的相对距离范围
nTrialsPerCond = 4; % 每个条件的试次数量
nBlocks = 4; % block的数量
nTrialsPerBlock = nTrialsPerCond * prod(letterPosRange) * prod(letterDistRange); % 每个block的试次数量
nTrials = nTrialsPerBlock * nBlocks; % 实验的总试次数量
stimulusDuration = 0.1; % 刺激呈现的持续时间（秒）
isi = 0.05; % 刺激之间的间隔时间（秒）
iti = 1; % 试次之间的间隔时间（秒）
blockBreak = 10; % block之间的休息时间（秒）
screenNumber = max(Screen('Screens')); % 使用的屏幕编号
screenColor = [128, 128, 128]; % 屏幕的背景颜色（RGB值）
textColor = [0, 0, 0]; % 文本的颜色（RGB值）
textFont = 'Arial'; % 文本的字体
textSize = 32; % 文本的大小（像素）
textWrap = 60; % 文本的换行长度（字符数）
stimulusSize = 64; % 刺激的大小（像素）
stimulusColor = [255, 255, 255]; % 刺激的颜色（RGB值）
stimulusFont = 'Courier New'; % 刺激的字体
stimulusX = 0; % 刺激的水平位置（相对于屏幕中心，像素）
stimulusY = 0; % 刺激的垂直位置（相对于屏幕中心，像素）
responseKeys = {'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', ...
    'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', ...
    'U', 'V', 'W', 'X', 'Y', 'Z'}; % 可用的反应键
responseTimeout = 5; % 反应的超时时间（秒）
feedbackDuration = 0.5; % 反馈的持续时间（秒）
feedbackColor = [0, 255, 0; 255, 0, 0]; % 反馈的颜色（RGB值），第一行为正确，第二行为错误
dataFile = 'data.mat'; % 保存数据的文件名（.mat格式）
csvFile = 'data.csv'; % 保存数据的文件名（.csv格式）

% 生成刺激
letters = 'A':'Z'; % 可用的字母
numbers = '0':'9'; % 可用的数字
stimuli = cell(nTrials, nStimuli); % 刺激的矩阵，每行为一个试次，每列为一个刺激
letterPos = zeros(nTrials, nLetters); % 字母的位置，每行为一个试次，每列为一个字母
letterDist = zeros(nTrials, nLetters - 1); % 字母之间的距离，每行为一个试次，每列为一个距离
for i = 1:nTrials
    % 随机选择第一个字母的位置
    letterPos(i, 1) = randi(letterPosRange);
    % 随机选择第二个字母与第一个字母的相对距离
    letterDist(i, 1) = randi(letterDistRange);
    % 计算第二个字母的位置
    letterPos(i, 2) = letterPos(i, 1) + letterDist(i, 1);
    % 随机选择两个字母
    stimuli(i, letterPos(i, :)) = datasample(letters, nLetters, 'Replace', false);
    % 随机选择二十个数字
    stimuli(i, setdiff(1:nStimuli, letterPos(i, :))) = datasample(numbers, nNumbers, 'Replace', true);
end

% 打乱试次顺序
trialOrder = Shuffle(1:nTrials);

% 初始化数据
data = struct();
data.trial = trialOrder; % 试次编号
data.letterPos = letterPos(trialOrder, :); % 字母的位置
data.letterDist = letterDist(trialOrder, :); % 字母之间的距离
data.stimuli = stimuli(trialOrder, :); % 刺激
data.response = cell(nTrials, nLetters); % 反应
data.correct = zeros(nTrials, nLetters); % 正确性
data.rt = zeros(nTrials, nLetters); % 反应时

% 初始化屏幕
[window, windowRect] = PsychImaging('OpenWindow', screenNumber, screenColor);
[xCenter, yCenter] = RectCenter(windowRect);
Screen('TextFont', window, textFont);
Screen('TextSize', window, textSize);
Screen('TextColor', window, textColor);

% 初始化键盘
KbName('UnifyKeyNames');
responseKeyCodes = KbName(responseKeys);
escapeKey = KbName('ESCAPE');
RestrictKeysForKbCheck([responseKeyCodes, escapeKey]);

% 初始化声音
InitializePsychSound;
pahandle = PsychPortAudio('Open', [], [], 0, [], 1);
beep = MakeBeep(500, 0.1);
PsychPortAudio('FillBuffer', pahandle, beep);

% 显示欢迎语
welcomeText = '欢迎参加注意瞬脱实验！\n\n在这个实验中，你将看到一系列快速变换的数字和字母，其中有两个字母，二十个数字。\n\n你的任务是尽量准确地报告你看到的两个字母分别是什么。\n\n请按照出现的顺序，使用键盘上的字母键输入你的反应。\n\n如果你没有看到字母，或者不确定，可以随便猜一个。\n\n你有5秒的时间输入你的反应，如果超时，你将听到一声提示音。\n\n每输入一个字母，你将看到一个反馈，绿色表示正确，红色表示错误。\n\n这个实验分为4个block进行，每个block有40个试次，完成一个block之后，你可以休息一会儿。\n\n如果你准备好了，请按任意键开始实验。';
DrawFormattedText(window, welcomeText, 'center', 'center', textColor, textWrap);
Screen('Flip', window);
KbStrokeWait;

% 开始实验
for block = 1:nBlocks
    % 显示block编号
    blockText = sprintf('第%d个block，按任意键开始', block);
    DrawFormattedText(window, blockText, 'center', 'center', textColor, textWrap);
    Screen('Flip', window);
    KbStrokeWait;
    
    % 显示试次编号
    for trial = 1:nTrialsPerBlock
        % 显示试次编号
        trialText = sprintf('第%d个block，第%d个试次，按任意键开始', block, trial);
        DrawFormattedText(window, trialText, 'center', 'center', textColor, textWrap);
        Screen('Flip', window);
        KbStrokeWait;
        
        % 显示刺激
        for stimulus = 1:nStimuli
            DrawFormattedText(window, data.stimuli{trial, stimulus}, stimulusX, stimulusY, stimulusColor, [], [], [], [], [], [stimulusX, stimulusY, stimulusX, stimulusY]);
            Screen('Flip', window);
            WaitSecs(stimulusDuration);
            Screen('Flip', window);
            WaitSecs(isi);
        end
        
        % 显示反应提示
        responseText = '请输入你看到的两个字母，按回车键结束';
        DrawFormattedText(window, responseText, 'center', 'center', textColor, textWrap);
        Screen('Flip', window);
        
        % 收集反应
        for letter = 1:nLetters
            % 等待反应
            responseStart = GetSecs;
            while true
                [keyIsDown, responseEnd, keyCode] = KbCheck;
                if keyIsDown
                    break;
                end
                if responseEnd - responseStart > responseTimeout
                    break;
                end
            end
            
            % 处理反应
            if keyIsDown
                % 记录反应
                data.response{trial, letter} = KbName(keyCode);
                data.rt(trial, letter) = responseEnd - responseStart;
                % 显示反馈
                if strcmp(data.response{trial, letter}, data.stimuli{trial, data.letterPos(trial, letter)})
                    data.correct(trial, letter) = 1;
                    DrawFormattedText(window, data.response{trial, letter}, 'center', 'center', feedbackColor(1, :), textWrap);
                else
                    data.correct(trial, letter) = 0;
                    DrawFormattedText(window, data.response{trial, letter}, 'center', 'center', feedbackColor(2, :), textWrap);
                end
                Screen('Flip', window);
                WaitSecs(feedbackDuration);
            else
                % 播放提示音
                PsychPortAudio('Start', pahandle);
                % 显示反馈
                DrawFormattedText(window, '?', 'center', 'center', feedbackColor(2, :), textWrap);
                Screen('Flip', window);
                WaitSecs(feedbackDuration);
            end
        end

        % 显示休息提示
        if trial < nTrialsPerBlock
            breakText = sprintf('第%d个block，第%d个试次，休息一下，按任意键继续', block, trial);
            DrawFormattedText(window, breakText, 'center', 'center', textColor, textWrap);
            Screen('Flip', window);
            KbStrokeWait;
        end
    end

    % 显示block休息
    if block < nBlocks
        breakText = sprintf('第%d个block，休息一下，按任意键继续', block);
        DrawFormattedText(window, breakText, 'center', 'center', textColor, textWrap);
        Screen('Flip', window);
        KbStrokeWait;
    end
end

% 保存数据
save(dataFile, 'data');
dataTable = struct2table(data);
writetable(dataTable, csvFile);

% 显示结束语
endText = '实验结束，谢谢参加！';
DrawFormattedText(window, endText, 'center', 'center', textColor, textWrap);
Screen('Flip', window);
KbStrokeWait;

% 清理环境
PsychPortAudio('Close', pahandle);
RestrictKeysForKbCheck([]);
Screen('CloseAll');
sca;
