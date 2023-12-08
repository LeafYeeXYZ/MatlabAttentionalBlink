% 初始化Psychtoolbox
clear;
clc;
PsychDefaultSetup(2); % 设置默认参数
AssertOpenGL; % 检查 Psychtoolbox 是否正常运行
Screen('Preference', 'VisualDebugLevel', 0); % 跳过青蛙画面（0）
Screen('Preference', 'SkipSyncTests', 1); % 跳过同步测试（1）
screenNumber = max(Screen('Screens')); % 获取屏幕编号
white = WhiteIndex(screenNumber); % 定义白色
black = BlackIndex(screenNumber); % 定义黑色
[window, windowRect] = PsychImaging('OpenWindow', screenNumber, black); % 打开一个窗口
[xCenter, yCenter] = RectCenter(windowRect); % 获取中心坐标
[screenXpixels, screenYpixels] = Screen('WindowSize', window); % 获取屏幕尺寸
ifi = Screen('GetFlipInterval', window); % 获取每帧间隔
topPriorityLevel = MaxPriority(window); % 获取最高优先级
HideCursor; % 隐藏光标
Screen('TextFont', window, 'SimHei'); % 设置字体
KbName('UnifyKeyNames'); % 统一键盘名称

% 定义刺激列表
StimulusList = {
    ['A', 'C', 'D', 'E', 'F', 'G', 'H', 'J', 'K', 'L', 'M', 'N', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y'];... % 字母刺激
    ['3', '4', '5', '6', '7', '9']}; % 数字刺激

% 定义实验参数
nBlocks = 4; % block数-4
nTrials = 40; % 每个block的试次数-40
nDigits = 20; % 每个试次的数字数-20
nLetters = 2; % 每个试次的字母数-2
T1Position = [3, 5, 7, 9, 11]; % T1可能出现的位置
T2LagPosition = 1:8; % T2相对T1的延迟位置
stimulusDuration = 0.1; % 每个刺激的持续时间，单位秒
isi = 0.05; % 刺激间隔，单位秒
fixationDuration = 1; % 注视点的持续时间，单位秒
feedbackDuration = 0.5; % 反馈的持续时间，单位秒
Screen('TextSize', window, 32);
textColor = white; % 文字颜色
fixationSize = 20; % 注视点大小，单位像素
fixationColor = white; % 注视点颜色
feedbackColor = white; % 反馈颜色
responseKeys = {'1!', '2@', '3#', '4$', '5%', '6^', '7&', '8*', '9(', '0)', 'Q', 'W', 'E', 'R', 'T', 'Y', 'U', 'I', 'O', 'P', 'A', 'S', 'D', 'F', 'G', 'H', 'J', 'K', 'L', 'Z', 'X', 'C', 'V', 'B', 'N', 'M', 'q', 'w', 'e', 'r', 't', 'y', 'u', 'i', 'o', 'p', 'a', 's', 'd', 'f', 'g', 'h', 'j', 'k', 'l', 'z', 'x', 'c', 'v', 'b', 'n', 'm', 'ESCAPE'}; % 可能的反应键
escapeKey = KbName('ESCAPE'); % 退出键，用于中止实验

% 定义指导语
instructions = '你将会看到一系列快速变换的数字，其中会夹杂两个字母，你需要在看完这些数字和字母后，尽量准确地报告你看到的字母分别是什么。\n\n请按空格键开始。';
endText = '实验结束，谢谢你的参与！';

% 预分配结果矩阵
results = zeros(nBlocks, nTrials, 4); % 列：T1位置，T2延迟位置，T1正确率，T2正确率

% 显示指导语
DrawFormattedText(window, double(instructions), 'center', 'center', textColor); % 在屏幕中央绘制指导语
Screen('Flip', window); % 更新屏幕
KbStrokeWait; % 等待按键

% 开始实验循环
for block = 1:nBlocks
    Screen('TextSize', window, 128);
    % 随机打乱试次顺序
    trialOrder = Shuffle(1:nTrials);
    % 开始block循环
    for trial = trialOrder
        % 随机选择T1位置
        T1pos = T1Position(randi(length(T1Position)));
        % 随机选择T2延迟位置
        T2lag = T2LagPosition(randi(length(T2LagPosition)));
        % 随机选择T1字母
        T1 = StimulusList{1}(randi(length(StimulusList{1})));
        % 随机选择T2字母
        T2 = StimulusList{1}(randi(length(StimulusList{1})));
        % 确保T1和T2不相同
        while T2 == T1
            T2 = StimulusList{1}(randi(length(StimulusList{1})));
        end
        % 随机选择数字
        digits = StimulusList{2}(randi(length(StimulusList{2}), 1, nDigits));
        % 将字母插入数字中
        digits(T1pos) = T1;
        digits(T1pos + T2lag) = T2;
        % 将数字转换为单元数组
        stimuli = cellstr(digits');
        % 显示注视点
        DrawFormattedText(window, '+', xCenter, yCenter, fixationColor, [], [], [], [], []); % 在屏幕中央绘制注视点
        vbl = Screen('Flip', window); % 更新屏幕
        % 等待注视点持续时间
        WaitSecs(fixationDuration);
        % 开始刺激循环
        for i = 1:nDigits
            % 绘制刺激
            DrawFormattedText(window, stimuli{i}, 'center', 'center', textColor, [], [], [], [], [], []); % 在屏幕中央绘制刺激
            % 更新屏幕
            vbl = Screen('Flip', window, vbl + (stimulusDuration - 0.5 * ifi)); % 在刺激持续时间结束后更新屏幕
            % 等待刺激间隔
            WaitSecs(isi);
        end
        % 清空屏幕
        Screen('Flip', window);
        % 获取用户反应
        respT1 = [];
        respT2 = [];
        while isempty(respT1) || isempty(respT2) % 当用户没有反应完两个字母时
            % 检查键盘
            [keyIsDown, secs, keyCode] = KbCheck;
            % 如果用户按下了键
            if keyIsDown
                % 获取键名
                keyName = KbName(keyCode);
                % 如果用户按下了退出键，中止实验
                if isequal(keyName, escapeKey)
                    sca;
                    return;
                end
                % 如果用户按下了有效键，记录反应
                if ismember(keyName, responseKeys)
                    % 如果用户还没有反应T1，记录T1反应
                    if isempty(respT1)
                        respT1 = keyName;
                    % 如果用户还没有反应T2，记录T2反应
                    elseif isempty(respT2)
                        respT2 = keyName;
                    end
                end
            end
        end
        % 检查反应的正确性
        accT1 = strcmp(respT1, T1);
        accT2 = strcmp(respT2, T2);
        % 给用户反馈
        if accT1 && accT2
            feedback = '正确';
        else
            feedback = '错误';
        end
        % 显示反馈
        DrawFormattedText(window, double(feedback), 'center', 'center', feedbackColor);
        Screen('Flip', window);
        % 等待反馈持续时间
        WaitSecs(feedbackDuration);
        % 保存结果
        results(block, trial, :) = [T1pos, T2lag, accT1, accT2];
    end
    % 显示休息信息
    Screen('TextSize', window, 64);
    if block < nBlocks
        breakText = sprintf('你已经完成了第%d个block，请休息一下。\n\n请按空格键继续。', block);
        DrawFormattedText(window, double(breakText), 'center', 'center', textColor);
        Screen('Flip', window);
        KbStrokeWait;
    end
end

% 显示结束语
Screen('TextSize', window, 64);
DrawFormattedText(window, double(endText), 'center', 'center', textColor);
Screen('Flip', window);
KbStrokeWait;

% 关闭屏幕并退出
sca;