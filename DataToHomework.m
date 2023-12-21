function DataToHomework (dataOri,Stimulus)
    %% 为了提交作业，对数据进行处理
    design = struct("TrialNumber", [], "T1Position", [], "T2LagPosition", [],...
        "T1Target", [], "T2Target", [], "T1Response", [], "T2Response", []);
    for i = 1:length(dataOri)
        design(i).TrialNumber = double(dataOri(i).TrialNumber);
        design(i).T1Position = double(dataOri(i).T1Position);
        design(i).T2LagPosition = double(dataOri(i).T2LagPosition);
        design(i).T1Target = KbName(dataOri(i).T1Target);
        design(i).T2Target = KbName(dataOri(i).T2Target);
        design(i).T1Response = KbName(dataOri(i).T1Response);
        design(i).T2Response = KbName(dataOri(i).T2Response);
    end
    sbjInfo = struct(...
        "sbjID", '201810011001',...
        "name", 'xyz',...
        "age", '20',...
        "gender", 'F',...
        "handedness", 'R');
    % 将design结构体数组转换为单元格数组
    designCell = struct2cell(design);
    % 移除单元格数组中的单维度条目
    designCell = squeeze(designCell);
    % 将单元格数组转换为双精度数组
    designDouble = cell2mat(designCell);
    % 将designDouble数组转置
    designDouble = transpose(designDouble);
    Data = struct(...
        "design", designDouble,...
        "trial", double(Stimulus));
    save('Data.mat', 'Data'); % 保存数据为.mat
    save('sbjInfo.mat', 'sbjInfo'); % 保存数据为.mat
end