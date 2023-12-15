%% 定义实验参数
% 清除现有变量
clear;
% 时间
FeedBackTime = 1;% 正误反馈呈现时间
TrailWaitTime = 1;% 试次间隔时间（注视点呈现时间）
LetterInputTime = 0.4;% 字母输入后的延迟时间（显示"请稍等"的时间，绝对不能设为0）
StimulusTime = 0.1;% 单个刺激呈现时间（要求是0.1s）
% 字号
FontSizeCN = 40;% 提示语字号
FontSizeStimulus = 120;% 刺激字号
FontSizeCross = 80;% 试次间隔注视点字号
% 文件名
OriFileName = 'OriginalData';% 原始数据保存文件名
CalFileName = 'CalculatedData';% 处理后数据保存文件名
% 其他
DEBUG = 1;% 等于1时始终保存数据（就算退出）
TrailPerSituation = 1;% 每个条件的试次(要求是4次！！！)

%----------------------------------------------------------------------------------------%

%% 实验简介
% 注意瞬脱 / Attentional Blink, AB
% 实验刺激：T1：第一个字母；T2：第二个字母；数字刺激为20个
% 自变量：T2LagPosition：T2相对T1的位置，1-8，8个水平
% 无关变量：T1Position：T1出现的位置，5-9，5个水平
% 因变量：T1正确率，T2正确率

%% 定义实验设计矩阵
dataOri = struct("TrialNumber", [], "T1Position", [], "T2LagPosition", [],...
    "T1Target", [], "T2Target", [], "T1Response", [], "T2Response", [], "T1Correct", [], "T2Correct", []);
dataCal = struct( "Time", [], "Gender", [], "Age", [],...
    "T1Accuracy_Lag1", [], "T2Accuracy_Lag1", [], "T1Accuracy_Lag2", [], "T2Accuracy_Lag2", [],...
    "T1Accuracy_Lag3", [], "T2Accuracy_Lag3", [], "T1Accuracy_Lag4", [], "T2Accuracy_Lag4", [],...
    "T1Accuracy_Lag5", [], "T2Accuracy_Lag5", [], "T1Accuracy_Lag6", [], "T2Accuracy_Lag6", [],...
    "T1Accuracy_Lag7", [], "T2Accuracy_Lag7", [], "T1Accuracy_Lag8", [], "T2Accuracy_Lag8", []);
% 刺激物序列
StimulusLetter = ['A', 'C', 'D', 'E', 'F', 'G', 'H', 'J', 'K', 'L', 'M', 'N', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y'];
StimulusNumber = ['3', '4', '5', '6', '7', '9'];
% 中文内容
instruction = ['欢迎参加本次实验\n\n',...% 指导语
    '你将会看到一系列快速变换的数字，其中会夹杂两个字母\n\n',...
    '你需要在看完这些数字和字母后\n\n',...
    '尽量准确地报告你看到的字母先后是什么\n\n',...
    '实验分四个部分进行，每个部分之间你可以休息一下\n\n',...
    '如需中途退出，请在要求按键时，按 Esc 键\n\n',...
    '如果您已经清楚实验规则，按任意键开始试验'];
suggestion = ['请开启大写锁定以避免输入法干扰\n\n',...% 提示语
    '如已开启，请等待3秒钟，实验将自动开始'];
rest = ['请休息一下\n\n',...% 休息语
    '按任意键继续'];
ending = ['实验结束，感谢您的参与\n\n',...% 结束语
    '按任意键退出'];
ESC = 0;% 用于记录是否退出

%% 创建刺激序列
% 先把所有试次用数字填充
Stimulus = char(zeros(40*TrailPerSituation,22));
for i = 1:40*TrailPerSituation 
    for j = 1:22
        Stimulus(i,j) = StimulusNumber(randi(length(StimulusNumber)));
        % 让前后数字不重复
        if j > 1
            while Stimulus(i,j) == Stimulus(i,j-1)
                Stimulus(i,j) = StimulusNumber(randi(length(StimulusNumber)));
            end
        end
    end
end
% 再确定两个字母的位置
temp = 0;
for i = 1:40*TrailPerSituation 
    dataOri(i).T1Target = StimulusLetter(randi(length(StimulusLetter)));
    dataOri(i).T2Target = StimulusLetter(randi(length(StimulusLetter)));
    while dataOri(i).T1Target == dataOri(i).T2Target
        dataOri(i).T2Target = StimulusLetter(randi(length(StimulusLetter)));
    end 
    % 确定T1的位置
    if i <= 8*TrailPerSituation
        dataOri(i).T1Position = 5;
    elseif i <= 16*TrailPerSituation
        dataOri(i).T1Position = 6;
    elseif i <= 24*TrailPerSituation
        dataOri(i).T1Position = 7;
    elseif i <= 32*TrailPerSituation
        dataOri(i).T1Position = 8;
    else
        dataOri(i).T1Position = 9;
    end
    % 确定T2的位置
    if temp == 0
        dataOri(i).T2LagPosition = 1;
        temp = 1;
    elseif temp == 1
        dataOri(i).T2LagPosition = 2;
        temp = 2;
    elseif temp == 2
        dataOri(i).T2LagPosition = 3;
        temp = 3;
    elseif temp == 3
        dataOri(i).T2LagPosition = 4;
        temp = 4;
    elseif temp == 4
        dataOri(i).T2LagPosition = 5;
        temp = 5;
    elseif temp == 5
        dataOri(i).T2LagPosition = 6;
        temp = 6;
    elseif temp == 6
        dataOri(i).T2LagPosition = 7;
        temp = 7;
    elseif temp == 7
        dataOri(i).T2LagPosition = 8;
        temp = 0;
    end 
end    
% 打乱顺序
dataOri = dataOri(randperm(length(dataOri)));
% 给打乱后的变量添加试次号
for i = 1:40*TrailPerSituation 
    dataOri(i).TrialNumber = i;
end
% 最后把刺激字母插入到刺激序列中
for i = 1:40*TrailPerSituation 
    Stimulus(i,dataOri(i).T1Position) = dataOri(i).T1Target;
    Stimulus(i,(dataOri(i).T1Position + dataOri(i).T2LagPosition)) = dataOri(i).T2Target;
end

%% 初始化Psychtoolbox
AssertOpenGL; % 检查 Psychtoolbox 是否正常运行
Screen('Preference', 'VisualDebugLevel', 0); % 跳过青蛙画面（0）
Screen('Preference', 'SkipSyncTests', 1); % 跳过同步测试（1）
screenNumber = max(Screen('Screens')); % 获取屏幕编号
[window, windowRect] = Screen('OpenWindow', screenNumber); % 打开一个窗口
Screen('BlendFunction', window, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA'); % 设置颜色混合模式
[xCenter, yCenter] = RectCenter(windowRect); % 获取屏幕中心坐标
Screen('TextFont', window, 'SimHei'); % 设置字体
KbName('UnifyKeyNames'); % 统一键盘名称
HideCursor;% 隐藏鼠标

%% 显示提示和指导语
Screen('TextSize', window, FontSizeCN); % 设置字号
DrawFormattedText(window,double(suggestion),'center','center',[0 0 0]);
Screen('Flip', window);
WaitSecs(3); % 等待x秒钟
DrawFormattedText(window,double(instruction),'center','center',[0 0 0]);
Screen('Flip', window); % 更新屏幕
KbStrokeWait; % 等待按键继续

%% 开始实验
for block = 1:4
    if ESC == 1
        break;
    end
    for i = ((block-1)*10*TrailPerSituation + 1):block*10*TrailPerSituation
        % 在屏幕上呈现刺激
        Screen('TextSize', window, FontSizeStimulus);
        for j = 1:22
            DrawFormattedText(window,char(Stimulus(i,j)),'center','center',[0 0 0]);
            Screen('Flip', window); % 更新屏幕
            WaitSecs(StimulusTime); % 等待0.1秒钟
        end
        Screen('TextSize', window, FontSizeCN);

        % 等待被试输入第一个字母
        DrawFormattedText(window,double('请按你看到的第一个字母\n\n如果没看清请按空格键'),'center','center',[0 0 0]);
        Screen('Flip', window); % 更新屏幕
        keyCode = zeros(1, 256); % 创建一个存储按键信息的变量
        keyIsDown = 0; % 初始化变量
        while ~keyIsDown
            [keyIsDown, ~, keyCode] = KbCheck; % 检测是否有按键按下
        end
        if keyCode(KbName('ESCAPE')) % 如果按了退出键
            ESC = 1;
            break; % 跳出循环，结束实验
        elseif keyCode(KbName(dataOri(i).T1Target)) % 如果按了T1Target
            dataOri(i).T1Correct = 1;
        else
            dataOri(i).T1Correct = 0;
        end
        dataOri(i).T1Response = upper(KbName(find(keyCode)));

        % 别让下面的程序读到上面的按键
        DrawFormattedText(window, double('请稍等'),'center','center',[0 0 0]);
        Screen('Flip', window);
        WaitSecs(LetterInputTime);

        % 等待被试输入第二个字母
        DrawFormattedText(window,double('请按你看到的第二个字母\n\n如果没看清请按空格键'),'center','center',[0 0 0]);
        Screen('Flip', window); % 更新屏幕
        keyCode = zeros(1, 256); % 创建一个存储按键信息的变量
        keyIsDown = 0; % 初始化变量
        while ~keyIsDown
            [keyIsDown, ~, keyCode] = KbCheck; % 检测是否有按键按下
        end
        if keyCode(KbName('ESCAPE')) % 如果按了退出键
            ESC = 1;
            break; % 跳出循环，结束实验
        elseif keyCode(KbName(dataOri(i).T2Target)) % 如果按了T2Target
            dataOri(i).T2Correct = 1;
        else
            dataOri(i).T2Correct = 0;
        end
        dataOri(i).T2Response = upper(KbName(find(keyCode)));

        % 为了保持一致性，这里也加上等待
        DrawFormattedText(window, double('请稍等'),'center','center',[0 0 0]);
        Screen('Flip', window);
        WaitSecs(LetterInputTime);

        % 显示正确错误反馈
        if (dataOri(i).T1Correct == 1) && (dataOri(i).T2Correct == 1)
            DrawFormattedText(window,double('全部正确'),'center','center',[0 0 0]);
            Screen('Flip', window); % 更新屏幕
        elseif (dataOri(i).T1Correct == 1) || (dataOri(i).T2Correct == 1)
            DrawFormattedText(window,double('部分正确'),'center','center',[0 0 0]);
            Screen('Flip', window); % 更新屏幕
        else
            DrawFormattedText(window,double('全部错误'),'center','center',[0 0 0]);
            Screen('Flip', window); % 更新屏幕
        end
        WaitSecs(FeedBackTime);

        % 在屏幕上呈现背景，表示试次间隔
        Screen('TextSize', window, FontSizeCross);
        DrawFormattedText(window, '+','center','center',[0 0 0]);
        Screen('Flip', window); % 更新屏幕
        Screen('TextSize', window, FontSizeCN);
        WaitSecs(TrailWaitTime);
    end

    if block ~= 4 && ESC ~= 1
        DrawFormattedText(window,double(rest),'center','center',[0 0 0]);
        Screen('Flip', window); % 更新屏幕
        KbStrokeWait; % 等待按键继续
    end
end

%% 显示结束语
Screen('TextSize', window, 40); % 设置字号
DrawFormattedText(window, double(ending), 'center', 'center', [0 0 0]); % 在屏幕中央绘制结束语
Screen('Flip', window); % 更新屏幕
KbStrokeWait; % 等待按键继续

%% 关闭Psychtoolbox
ShowCursor;% 显示鼠标
sca; % 关闭所有窗口和声音设备，恢复正常屏幕状态

%% 原始数据保存
if ESC == 0 || DEBUG == 1
    save([OriFileName '.mat'], 'dataOri'); % 保存数据为.mat
    % 将结构体转换为表格
    dataOriTable = struct2table(dataOri);
    % 将表格保存为.scv
    writetable(dataOriTable, [OriFileName '.csv'], 'Encoding', 'UTF-8');
end

%% 数据处理
dataCal.Time = string(datetime('now','Format','yyMMddHHmmss'));
dataCal.Gender = input('请输入您的性别(女性请输入0/男性请输入1):');
dataCal.Age = input('请输入您的当前年龄(18/19/20/...):');
T1L1 = 0;T1L2 = 0;T1L3 = 0;T1L4 = 0;T1L5 = 0;T1L6 = 0;T1L7 = 0;T1L8 = 0;
T2L1 = 0;T2L2 = 0;T2L3 = 0;T2L4 = 0;T2L5 = 0;T2L6 = 0;T2L7 = 0;T2L8 = 0;
for i = 1:40*TrailPerSituation
    if dataOri(i).T1Correct == 1
        if dataOri(i).T2LagPosition == 1
            T1L1 = T1L1 + 1;
        elseif dataOri(i).T2LagPosition == 2
            T1L2 = T1L2 + 1;
        elseif dataOri(i).T2LagPosition == 3
            T1L3 = T1L3 + 1;
        elseif dataOri(i).T2LagPosition == 4
            T1L4 = T1L4 + 1;
        elseif dataOri(i).T2LagPosition == 5
            T1L5 = T1L5 + 1;
        elseif dataOri(i).T2LagPosition == 6
            T1L6 = T1L6 + 1;
        elseif dataOri(i).T2LagPosition == 7
            T1L7 = T1L7 + 1;
        elseif dataOri(i).T2LagPosition == 8
            T1L8 = T1L8 + 1;
        end
    end
    if dataOri(i).T2Correct == 1
        if dataOri(i).T2LagPosition == 1
            T2L1 = T2L1 + 1;
        elseif dataOri(i).T2LagPosition == 2
            T2L2 = T2L2 + 1;
        elseif dataOri(i).T2LagPosition == 3
            T2L3 = T2L3 + 1;
        elseif dataOri(i).T2LagPosition == 4
            T2L4 = T2L4 + 1;
        elseif dataOri(i).T2LagPosition == 5
            T2L5 = T2L5 + 1;
        elseif dataOri(i).T2LagPosition == 6
            T2L6 = T2L6 + 1;
        elseif dataOri(i).T2LagPosition == 7
            T2L7 = T2L7 + 1;
        elseif dataOri(i).T2LagPosition == 8
            T2L8 = T2L8 + 1;
        end
    end
end
dataCal.T1Accuracy_Lag1 = T1L1 / (5*TrailPerSituation);
dataCal.T1Accuracy_Lag2 = T1L2 / (5*TrailPerSituation);
dataCal.T1Accuracy_Lag3 = T1L3 / (5*TrailPerSituation);
dataCal.T1Accuracy_Lag4 = T1L4 / (5*TrailPerSituation);
dataCal.T1Accuracy_Lag5 = T1L5 / (5*TrailPerSituation);
dataCal.T1Accuracy_Lag6 = T1L6 / (5*TrailPerSituation);
dataCal.T1Accuracy_Lag7 = T1L7 / (5*TrailPerSituation);
dataCal.T1Accuracy_Lag8 = T1L8 / (5*TrailPerSituation);
dataCal.T2Accuracy_Lag1 = T2L1 / (5*TrailPerSituation);
dataCal.T2Accuracy_Lag2 = T2L2 / (5*TrailPerSituation);
dataCal.T2Accuracy_Lag3 = T2L3 / (5*TrailPerSituation);
dataCal.T2Accuracy_Lag4 = T2L4 / (5*TrailPerSituation);
dataCal.T2Accuracy_Lag5 = T2L5 / (5*TrailPerSituation);
dataCal.T2Accuracy_Lag6 = T2L6 / (5*TrailPerSituation);
dataCal.T2Accuracy_Lag7 = T2L7 / (5*TrailPerSituation);
dataCal.T2Accuracy_Lag8 = T2L8 / (5*TrailPerSituation);

%% 处理后数据保存
if ESC == 0 || DEBUG == 1
    save([CalFileName '.mat'], 'dataCal'); % 保存数据为.mat
    % 将结构体转换为表格
    dataCalTable = struct2table(dataCal);
    % 将表格保存为.scv
    writetable(dataCalTable, [CalFileName '.csv'], 'Encoding', 'UTF-8', 'WriteMode', 'append');
end

