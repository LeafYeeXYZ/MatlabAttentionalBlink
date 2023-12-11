% 清空工作空间和命令窗口
clear;
clc;

% 设置随机数种子
rng('shuffle');

% 定义一些常量
NUM_LETTERS = 2; % 字母的个数
NUM_DIGITS = 20; % 数字的个数
NUM_ITEMS = NUM_LETTERS + NUM_DIGITS; % 总共的项目个数
LETTER_POS_MIN = 5; % 第一个字母的最小位置
LETTER_POS_MAX = 9; % 第一个字母的最大位置
LETTER_DIST_MIN = 1; % 第二个字母与第一个字母的最小相对距离
LETTER_DIST_MAX = 8; % 第二个字母与第一个字母的最大相对距离
NUM_TRIALS = 4; % 每个字母位置和距离的配对的试次个数
NUM_BLOCKS = 4; % 实验的block个数
SCREEN_WIDTH = 1920; % 屏幕的宽度（像素）
SCREEN_HEIGHT = 1080; % 屏幕的高度（像素）
TEXT_SIZE = 40; % 文本的大小（像素）
TEXT_COLOR = [255, 255, 255]; % 文本的颜色（RGB）
BG_COLOR = [0, 0, 0]; % 背景的颜色（RGB）
STIM_DUR = 0.1; % 刺激的持续时间（秒）
ISI = 0.05; % 刺激之间的间隔时间（秒）
FIX_DUR = 0.5; % 固定点的持续时间（秒）
BREAK_DUR = 10; % 每个block之间的休息时间（秒）
DATA_FILE = 'data.mat'; % 保存数据的文件名（.mat格式）
CSV_FILE = 'data.csv'; % 保存数据的文件名（.csv格式）

% 初始化psychtoolbox
PsychDefaultSetup(2);
Screen('Preference', 'SkipSyncTests', 1); % 跳过同步测试(1)
Screen('Preference', 'VisualDebugLevel', 0); % 跳过青蛙画面(0)
screens = Screen('Screens'); % 获取可用的屏幕编号
screenNumber = max(screens); % 选择最大的屏幕编号，通常是外接的显示器
[window, windowRect] = PsychImaging('OpenWindow', screenNumber, BG_COLOR); % 打开一个窗口
[xCenter, yCenter] = RectCenter(windowRect); % 获取屏幕中心的坐标
Screen('TextSize', window, TEXT_SIZE); % 设置文本的大小
Screen('TextFont', window, 'SimHei'); % 设置文本的字体
Screen('BlendFunction', window, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA'); % 设置混合模式，以便于透明度的控制
HideCursor; % 隐藏鼠标光标
topPriorityLevel = MaxPriority(window); % 获取最高的优先级
Priority(topPriorityLevel); % 设置最高的优先级
ifi = Screen('GetFlipInterval', window); % 获取屏幕的刷新间隔
slack = ifi / 2; % 计算一个时间余量，用于翻转屏幕

% 定义一些变量
letters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'; % 所有可能的字母
digits = '0123456789'; % 所有可能的数字
letterPos = LETTER_POS_MIN:LETTER_POS_MAX; % 所有可能的第一个字母的位置
letterDist = LETTER_DIST_MIN:LETTER_DIST_MAX; % 所有可能的第二个字母与第一个字母的相对距离
conditions = combvec(letterPos, letterDist)'; % 所有可能的条件，每一行是一个字母位置和距离的配对
numConditions = size(conditions, 1); % 条件的个数
trialsPerBlock = numConditions * NUM_TRIALS; % 每个block的试次个数
totalTrials = trialsPerBlock * NUM_BLOCKS; % 总共的试次个数
trialOrder = repmat(conditions, NUM_TRIALS, 1); % 生成试次顺序，每个条件重复NUM_TRIALS次
trialOrder = trialOrder(randperm(trialsPerBlock), :); % 随机打乱试次顺序
trialOrder = repmat(trialOrder, NUM_BLOCKS, 1); % 重复试次顺序，生成NUM_BLOCKS个block
data = zeros(totalTrials, 5); % 初始化数据矩阵，每一行是一个试次，每一列分别是试次编号、第一个字母位置、第二个字母与第一个字母的相对位置、第一个字母反应是否正确、第二个字母反应是否正确
responseKeys = KbName({'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z'}); % 定义反应键
escapeKey = KbName('ESCAPE'); % 定义退出键

% 显示实验说明
DrawFormattedText(window, double('欢迎参加本实验！\n\n在本实验中，你将看到一系列快速变换的数字和字母，其中有两个字母，二十个数字。\n你的任务是尽量准确地记住并报告你看到的两个字母分别是什么。\n你可以使用键盘上的字母键来输入你的反应，按回车键确认。\n\n本实验共有4个block，每个block有40个试次，每个试次之间有短暂的间隔。\n每个block之后，你可以休息一会儿，按任意键继续。\n\n如果你想提前结束实验，你可以按ESC键退出。\n\n如果你对实验说明清楚了，就请按空格键开始吧！'), 'center', 'center', TEXT_COLOR);
Screen('Flip', window); % 翻转屏幕，显示实验说明
KbStrokeWait; % 等待按键反应

% 开始实验
for trial = 1:totalTrials % 对每个试次进行循环
    % 获取当前试次的条件
    currentPos = trialOrder(trial, 1); % 获取当前试次的第一个字母的位置
    currentDist = trialOrder(trial, 2); % 获取当前试次的第二个字母与第一个字母的相对距离
    
    % 生成当前试次的刺激
    stim = randperm(10, NUM_DIGITS) + '0'; % 随机生成NUM_DIGITS个不重复的数字
    stim = char(stim); % 转换为字符数组
    firstLetter = randi(26); % 随机生成第一个字母的索引
    secondLetter = mod(firstLetter + randi(25), 26) + 1; % 随机生成第二个字母的索引，确保与第一个字母不同
    stim(currentPos) = letters(firstLetter); % 将第一个字母插入到刺激中
    stim(currentPos + currentDist) = letters(secondLetter); % 将第二个字母插入到刺激中
    
    % 显示固定点
    DrawFormattedText(window, '+', 'center', 'center', TEXT_COLOR); % 在屏幕中心画一个加号
    fixOnset = Screen('Flip', window); % 翻转屏幕，显示固定点
    WaitSecs(FIX_DUR); % 等待固定点的持续时间
    
    % 显示刺激
    for i = 1:NUM_ITEMS % 对每个项目进行循环
        DrawFormattedText(window, stim(i), 'center', 'center', TEXT_COLOR); % 在屏幕中心画当前的项目
        stimOnset = Screen('Flip', window, fixOnset + FIX_DUR + (i - 1) * (STIM_DUR + ISI) - slack); % 翻转屏幕，显示刺激，控制刺激的开始时间
        WaitSecs(STIM_DUR); % 等待刺激的持续时间
        Screen('Flip', window, stimOnset + STIM_DUR - slack); % 翻转屏幕，清空刺激，控制刺激的结束时间
    end
    
    % 等待被试反应
    response = []; % 初始化反应为空
    while true % 无限循环，直到被试按回车键或退出键
        [keyIsDown, ~, keyCode] = KbCheck; % 检查键盘是否有按键
        if keyIsDown % 如果有按键
            if keyCode(escapeKey) % 如果按了退出键
                sca; % 关闭屏幕
                return; % 结束程序
            elseif any(keyCode(responseKeys)) % 如果按了反应键
                response = [response, KbName(keyCode)]; % 将按键添加到反应中
                DrawFormattedText(window, response, 'center', 'center', TEXT_COLOR); % 在屏幕中心显示反应
                Screen('Flip', window); % 翻转屏幕，显示反应
            elseif keyCode(KbName('RETURN')) % 如果按了回车键
                break; % 跳出循环
            end
        end
    end
    
    % 判断反应是否正确
    correctLetters = [letters(firstLetter), letters(secondLetter)]; % 获取正确的字母
    correctResponse = sort(correctLetters); % 将正确的字母按字母顺序排序
    response = sort(response); % 将反应按字母顺序排序
    firstCorrect = strcmp(response(1), correctResponse(1)); % 判断第一个字母反应是否正确
    secondCorrect = strcmp(response(2), correctResponse(2)); % 判断第二个字母反应是否正确
    
    % 保存数据
    data(trial, :) = [trial, currentPos, currentDist, firstCorrect, secondCorrect]; % 将当前试次的数据保存到数据矩阵中
    
    % 显示反馈
    if firstCorrect && secondCorrect % 如果两个字母都正确
        feedback = '正确！'; % 反馈为正确
    else % 如果有一个或两个字母错误
        feedback = sprintf('错误！正确的字母是%s和%s。', correctLetters(1), correctLetters(2)); % 反馈为错误，并显示正确的字母
    end
    DrawFormattedText(window, feedback, 'center', 'center', TEXT_COLOR); % 在屏幕中心显示反馈
    Screen('Flip', window); % 翻转屏幕，显示反馈
    WaitSecs(1); % 等待1秒
    
    % 判断是否需要休息
    if mod(trial, trialsPerBlock) == 0 && trial < totalTrials % 如果当前试次是一个block的最后一个试次，且不是整个实验的最后一个试次
        DrawFormattedText(window, '你已经完成了一个block，请休息一会儿。\n\n按任意键继续。', 'center', 'center', TEXT_COLOR); % 在屏幕中心显示休息提示
        Screen('Flip', window); % 翻转屏幕，显示休息提示
        KbStrokeWait; % 等待按键反应
        WaitSecs(BREAK_DUR); % 等待休息时间
    end
end

% 结束实验
DrawFormattedText(window, '实验结束，谢谢你的参与！', 'center', 'center', TEXT_COLOR); % 在屏幕中心显示结束提示
Screen('Flip', window); % 翻转屏幕，显示结束提示
WaitSecs(2); % 等待2秒

% 保存数据
save(DATA_FILE, 'data'); % 以.mat格式保存数据
csvwrite(CSV_FILE, data); % 以.csv格式保存数据

% 关闭屏幕
sca;

