%%
clc;clear
%%
% 1 导入数据
% 1.1 定义文件信息
File_path=inputdlg({'文件路径'},'路径',1,{''});
% 1.2 融合文件路径
DATA_path_list=dir(strcat(File_path{1,1},''));
% 1.3 获取数据数量
DATA_num = length(DATA_path_list);
%%
% 2 整理数据
% 2.1 形成多人原始数据整合
if DATA_num>0
    for j = 3:DATA_num
        Data_fullpath=fullfile(File_path,DATA_path_list(j).name);
        fid = fopen(Data_fullpath{1,1},'r');
        csvdata(j-2,:)  = textscan(fid, '%s %s %s %s %s %s %s %s %s %s %s %s','delimiter', ',');
        %fid>0表示打开成功，f浮点型，d整数型，s字符串型（实现数据以不同形式导入matlab中）
        fclose(fid);
    end
end
% 2.2 csvdata数据结构
% 第3列：试次，作为检索标志！！！
% 第6列：反应时；
% 第7列：刺激；
% 第8列：按键；
% 第11列：调查信息：
%%
% 3 形成个人数据
% 3.1 个人实验流程数据
for j = 3:DATA_num
    n=1;
    for i=1:150
        if csvdata{j-2,3}{i,1}~= ''''& strcmp(csvdata{j-2,3}{i,1},'""')~=1& strcmp(csvdata{j-2,3}{i,1},'"trial_index"')~=1;
            index(i,1)=1;
            % 试次
            if index(i,1)==1
                % SubInfo
                DATAsubject(j-2).SubID = DATA_path_list(j).name(15:17);
                DATAsubject(j-2).Group = DATA_path_list(j).name(10:13);
                DATAsubject(j-2).Sex = str2double(csvdata{j-2,11}{12,1}(2:2));
                DATAsubject(j-2).Age = str2double(csvdata{j-2,11}{13,1}(2:3));
                DATAsubject(j-2).Edu = str2double(csvdata{j-2,11}{14,1}(2:2));
                % Block：0为SubInfo，1-5为五个实验部分，方便看。
                if n<=7
                    DATAsubject(j-2).trial(n).Block = 0;
                elseif n>7 & n<=32
                    DATAsubject(j-2).trial(n).Block = 1;
                elseif n>32 & n<=57
                    DATAsubject(j-2).trial(n).Block = 2;
                elseif n>57 & n<=82
                    DATAsubject(j-2).trial(n).Block = 3;
                elseif n>82 & n<=107
                    DATAsubject(j-2).trial(n).Block = 4;
                else
                    DATAsubject(j-2).trial(n).Block = 5;
                end
                % 反应
                DATAsubject(j-2).trial(n).trial = n;
                DATAsubject(j-2).trial(n).stimuls = csvdata{j-2,7}{i,1};
                DATAsubject(j-2).trial(n).RT = csvdata{j-2,6}{i,1};
                DATAsubject(j-2).trial(n).KB = csvdata{j-2,8}{i,1};
                % 情绪
                if strcmp(csvdata{j-2,10}{i,1},'"PreEmotion"')==1 || strcmp(csvdata{j-2,10}{i,1},'"PostEmotion"')==1 || strcmp(csvdata{j-2,10}{i,1},'"PostEmotion2"')==1
                    DATAsubject(j-2).trial(n).Emotion = csvdata{j-2,11}{12,1}(2:2);
                end
                n=n+1;
            end
        end
    end
end
% 3.2 个人数据简化（只留下刺激类型、反应、按键时等信息）
% Block1
for j=1:DATA_num-2
    n=1;
    for i=1:130
        if DATAsubject(j).trial(i).Block == 1;
            DATAsubject(j).B1PreEmo = str2double(DATAsubject(j).trial(10).Emotion);
            DATAsubject(j).B1PstEmo1 = str2double(DATAsubject(j).trial(12).Emotion);
            DATAsubject(j).B1PstEmo2 = str2double(DATAsubject(j).trial(30).Emotion);
            if i >= 15 & i<= 29
                if strcmp(DATAsubject(j).trial(i).stimuls,'"+"')~=1
                    if strcmp(DATAsubject(j).trial(i).stimuls(6:7),'IM')
                        DATAsubject(j).Block1(n).stimuls = 'IM';
                        DATAsubject(j).Block1(n).stimulstype = 1;
                    elseif strcmp(DATAsubject(j).trial(i).stimuls(6:7),'PE')
                        DATAsubject(j).Block1(n).stimuls = 'PE';
                        DATAsubject(j).Block1(n).stimulstype = 2;
                    elseif strcmp(DATAsubject(j).trial(i).stimuls(6:7),'NO')
                        DATAsubject(j).Block1(n).stimuls = 'NO';
                        DATAsubject(j).Block1(n).stimulstype = 3;
                    end
                    DATAsubject(j).Block1(n).RT = str2double(DATAsubject(j).trial(i).RT(2:length(DATAsubject(j).trial(i).RT)-1));
                    DATAsubject(j).Block1(n).KB = str2double(DATAsubject(j).trial(i).KB(2:3));
                    n=n+1;
                end
            end
        end
    end
end
% Block2
for j=1:DATA_num-2
    n=1;
    for i=1:130
        
        if DATAsubject(j).trial(i).Block == 2;
            DATAsubject(j).B2PreEmo = str2double(DATAsubject(j).trial(35).Emotion);
            DATAsubject(j).B2PstEmo1 = str2double(DATAsubject(j).trial(37).Emotion);
            DATAsubject(j).B2PstEmo2 = str2double(DATAsubject(j).trial(55).Emotion);
            if i >=40 & i<= 54
                if strcmp(DATAsubject(j).trial(i).stimuls,'"+"')~=1
                    if strcmp(DATAsubject(j).trial(i).stimuls(6:7),'IM')
                        DATAsubject(j).Block2(n).stimuls = 'IM';
                        DATAsubject(j).Block2(n).stimulstype = 1;
                    elseif strcmp(DATAsubject(j).trial(i).stimuls(6:7),'PE')
                        DATAsubject(j).Block2(n).stimuls = 'PE';
                        DATAsubject(j).Block2(n).stimulstype = 2;
                    elseif strcmp(DATAsubject(j).trial(i).stimuls(6:7),'NO')
                        DATAsubject(j).Block2(n).stimuls = 'NO';
                        DATAsubject(j).Block2(n).stimulstype = 3;
                    end
                    DATAsubject(j).Block2(n).RT = str2double(DATAsubject(j).trial(i).RT(2:length(DATAsubject(j).trial(i).RT)-1));
                    DATAsubject(j).Block2(n).KB = str2double(DATAsubject(j).trial(i).KB(2:3));
                    n=n+1;
                end
            end
        end
    end
end
% Block3
for j=1:DATA_num-2
    n=1;
    for i=1:130
        
        if DATAsubject(j).trial(i).Block == 3;
            DATAsubject(j).B3PreEmo = str2double(DATAsubject(j).trial(60).Emotion);
            DATAsubject(j).B3PstEmo1 = str2double(DATAsubject(j).trial(62).Emotion);
            DATAsubject(j).B3PstEmo2 = str2double(DATAsubject(j).trial(80).Emotion);
            if i >=65 & i<= 79
                if strcmp(DATAsubject(j).trial(i).stimuls,'"+"')~=1
                    if strcmp(DATAsubject(j).trial(i).stimuls(6:7),'IM')
                        DATAsubject(j).Block3(n).stimuls = 'IM';
                        DATAsubject(j).Block3(n).stimulstype = 1;
                    elseif strcmp(DATAsubject(j).trial(i).stimuls(6:7),'PE')
                        DATAsubject(j).Block3(n).stimuls = 'PE';
                        DATAsubject(j).Block3(n).stimulstype = 2;
                    elseif strcmp(DATAsubject(j).trial(i).stimuls(6:7),'NO')
                        DATAsubject(j).Block3(n).stimuls = 'NO';
                        DATAsubject(j).Block3(n).stimulstype = 3;
                    end
                    DATAsubject(j).Block3(n).RT = str2double(DATAsubject(j).trial(i).RT(2:length(DATAsubject(j).trial(i).RT)-1));
                    DATAsubject(j).Block3(n).KB = str2double(DATAsubject(j).trial(i).KB(2:3));
                    n=n+1;
                end
            end
        end
    end
end
% Block3
for j=1:DATA_num-2
    n=1;
    for i=1:130
        if DATAsubject(j).trial(i).Block == 4;
            DATAsubject(j).B4PreEmo = str2double(DATAsubject(j).trial(85).Emotion);
            DATAsubject(j).B4PstEmo1 = str2double(DATAsubject(j).trial(87).Emotion);
            DATAsubject(j).B4PstEmo2 = str2double(DATAsubject(j).trial(105).Emotion);
            if i >=90 & i<= 104
                if strcmp(DATAsubject(j).trial(i).stimuls,'"+"')~=1
                    if strcmp(DATAsubject(j).trial(i).stimuls(6:7),'IM')
                        DATAsubject(j).Block4(n).stimuls = 'IM';
                        DATAsubject(j).Block4(n).stimulstype = 1;
                    elseif strcmp(DATAsubject(j).trial(i).stimuls(6:7),'PE')
                        DATAsubject(j).Block4(n).stimuls = 'PE';
                        DATAsubject(j).Block4(n).stimulstype = 2;
                    elseif strcmp(DATAsubject(j).trial(i).stimuls(6:7),'NO')
                        DATAsubject(j).Block4(n).stimuls = 'NO';
                        DATAsubject(j).Block4(n).stimulstype = 3;
                    end
                    DATAsubject(j).Block4(n).RT = str2double(DATAsubject(j).trial(i).RT(2:length(DATAsubject(j).trial(i).RT)-1));
                    DATAsubject(j).Block4(n).KB = str2double(DATAsubject(j).trial(i).KB(2:3));
                    n=n+1;
                end
            end
        end
    end
end
for j=1:DATA_num-2
    n=1;
    for i=1:130
        if DATAsubject(j).trial(i).Block == 5;
            DATAsubject(j).B5PreEmo = str2double(DATAsubject(j).trial(110).Emotion);
            DATAsubject(j).B5PstEmo1 = str2double(DATAsubject(j).trial(112).Emotion);
            DATAsubject(j).B5PstEmo2 = str2double(DATAsubject(j).trial(130).Emotion);
            if i >=115 & i<= 129
                if strcmp(DATAsubject(j).trial(i).stimuls,'"+"')~=1
                    if strcmp(DATAsubject(j).trial(i).stimuls(6:7),'IM')
                        DATAsubject(j).Block5(n).stimuls = 'IM';
                        DATAsubject(j).Block5(n).stimulstype = 1;
                    elseif strcmp(DATAsubject(j).trial(i).stimuls(6:7),'PE')
                        DATAsubject(j).Block5(n).stimuls = 'PE';
                        DATAsubject(j).Block5(n).stimulstype = 2;
                    elseif strcmp(DATAsubject(j).trial(i).stimuls(6:7),'NO')
                        DATAsubject(j).Block5(n).stimuls = 'NO';
                        DATAsubject(j).Block5(n).stimulstype = 3;
                    end
                    DATAsubject(j).Block5(n).RT = str2double(DATAsubject(j).trial(i).RT(2:length(DATAsubject(j).trial(i).RT)-1));
                    DATAsubject(j).Block5(n).KB = str2double(DATAsubject(j).trial(i).KB(2:3));
                    n=n+1;
                end
            end
        end
    end
end
%%
% 4 整合
% Block1
for j=1:DATA_num-2    
    stimulstype = [DATAsubject(j).Block1.stimulstype];
    RT = [DATAsubject(j).Block1.RT];
    KB = [DATAsubject(j).Block1.KB];
    % (1)B1_PE
    % a.B1_PE_RT
    DATAsubject(j).B1_PE_Y_RT = mean(RT(1,(stimulstype==2)&(KB==68)));
    DATAsubject(j).B1_PE_N_RT = mean(RT(1,(stimulstype==2)&(KB==75)));
    % b.B1_PE_Y
    DATAsubject(j).B1_PE_Y = sum((stimulstype==2)&(KB==68));
    % (2)B1_IM
    % B1_IM_RT
    DATAsubject(j).B1_IM_Y_RT = mean(RT(1,(stimulstype==1)&(KB==68)));
    DATAsubject(j).B1_IM_N_RT = mean(RT(1,(stimulstype==1)&(KB==75)));
    % B1_IM_Y
    DATAsubject(j).B1_IM_Y = sum((stimulstype==1)&(KB==68));
    % (3)B1_NO
    % B1_NO_RT
    DATAsubject(j).B1_NO_Y_RT = mean(RT(1,(stimulstype==3)&(KB==68)));
    DATAsubject(j).B1_NO_N_RT = mean(RT(1,(stimulstype==3)&(KB==75)));
    % B1_NO_Y
    DATAsubject(j).B1_NO_Y = sum((stimulstype==3)&(KB==68));
end
% block2
for j=1:DATA_num-2    
    stimulstype = [DATAsubject(j).Block2.stimulstype];
    RT = [DATAsubject(j).Block2.RT];
    KB = [DATAsubject(j).Block2.KB];
    % (1)B2_PE
    % a.B2_PE_RT
    DATAsubject(j).B2_PE_Y_RT = mean(RT(1,(stimulstype==2)&(KB==68)));
    DATAsubject(j).B2_PE_N_RT = mean(RT(1,(stimulstype==2)&(KB==75)));
    % b.B2_PE_Y
    DATAsubject(j).B2_PE_Y = sum((stimulstype==2)&(KB==68));
    % (2)B2_IM
    % B2_IM_RT
    DATAsubject(j).B2_IM_Y_RT = mean(RT(1,(stimulstype==1)&(KB==68)));
    DATAsubject(j).B2_IM_N_RT = mean(RT(1,(stimulstype==1)&(KB==75)));
    % B2_IM_Y
    DATAsubject(j).B2_IM_Y = sum((stimulstype==1)&(KB==68));
    % (3)B2_NO
    % B2_NO_RT
    DATAsubject(j).B2_NO_Y_RT = mean(RT(1,(stimulstype==3)&(KB==68)));
    DATAsubject(j).B2_NO_N_RT = mean(RT(1,(stimulstype==3)&(KB==75)));
    % B2_NO_Y
    DATAsubject(j).B2_NO_Y = sum((stimulstype==3)&(KB==68));
end
% block3
for j=1:DATA_num-2    
    stimulstype = [DATAsubject(j).Block3.stimulstype];
    RT = [DATAsubject(j).Block3.RT];
    KB = [DATAsubject(j).Block3.KB];
    % (1)B3_PE
    % a.B3_PE_RT
    DATAsubject(j).B3_PE_Y_RT = mean(RT(1,(stimulstype==2)&(KB==68)));
    DATAsubject(j).B3_PE_N_RT = mean(RT(1,(stimulstype==2)&(KB==75)));
    % b.B3_PE_Y
    DATAsubject(j).B3_PE_Y = sum((stimulstype==2)&(KB==68));
    % (2)B3_IM
    % B3_IM_RT
    DATAsubject(j).B3_IM_Y_RT = mean(RT(1,(stimulstype==1)&(KB==68)));
    DATAsubject(j).B3_IM_N_RT = mean(RT(1,(stimulstype==1)&(KB==75)));
    % B3_IM_Y
    DATAsubject(j).B3_IM_Y = sum((stimulstype==1)&(KB==68));
    % (3)B3_NO
    % B3_NO_RT
    DATAsubject(j).B3_NO_Y_RT = mean(RT(1,(stimulstype==3)&(KB==68)));
    DATAsubject(j).B3_NO_N_RT = mean(RT(1,(stimulstype==3)&(KB==75)));
    % B3_NO_Y
    DATAsubject(j).B3_NO_Y = sum((stimulstype==3)&(KB==68));
end
% block4
for j=1:DATA_num-2    
    stimulstype = [DATAsubject(j).Block3.stimulstype];
    RT = [DATAsubject(j).Block3.RT];
    KB = [DATAsubject(j).Block3.KB];
    % (1)B4_PE
    % a.B4_PE_RT
    DATAsubject(j).B4_PE_Y_RT = mean(RT(1,(stimulstype==2)&(KB==68)));
    DATAsubject(j).B4_PE_N_RT = mean(RT(1,(stimulstype==2)&(KB==75)));
    % b.B4_PE_Y
    DATAsubject(j).B4_PE_Y = sum((stimulstype==2)&(KB==68));
    % (2)B4_IM
    % B4_IM_RT
    DATAsubject(j).B4_IM_Y_RT = mean(RT(1,(stimulstype==1)&(KB==68)));
    DATAsubject(j).B4_IM_N_RT = mean(RT(1,(stimulstype==1)&(KB==75)));
    % B4_IM_Y
    DATAsubject(j).B4_IM_Y = sum((stimulstype==1)&(KB==68));
    % (3)B4_NO
    % B4_NO_RT
    DATAsubject(j).B4_NO_Y_RT = mean(RT(1,(stimulstype==3)&(KB==68)));
    DATAsubject(j).B4_NO_N_RT = mean(RT(1,(stimulstype==3)&(KB==75)));
    % B4_NO_Y
    DATAsubject(j).B4_NO_Y = sum((stimulstype==3)&(KB==68));
end
% block5
for j=1:DATA_num-2    
    stimulstype = [DATAsubject(j).Block3.stimulstype];
    RT = [DATAsubject(j).Block3.RT];
    KB = [DATAsubject(j).Block3.KB];
    % (1)B5_PE
    % a.B5_PE_RT
    DATAsubject(j).B5_PE_Y_RT = mean(RT(1,(stimulstype==2)&(KB==68)));
    DATAsubject(j).B5_PE_N_RT = mean(RT(1,(stimulstype==2)&(KB==75)));
    % b.B5_PE_Y
    DATAsubject(j).B5_PE_Y = sum((stimulstype==2)&(KB==68));
    % (2)B5_IM
    % B5_IM_RT
    DATAsubject(j).B5_IM_Y_RT = mean(RT(1,(stimulstype==1)&(KB==68)));
    DATAsubject(j).B5_IM_N_RT = mean(RT(1,(stimulstype==1)&(KB==75)));
    % B5_IM_Y
    DATAsubject(j).B5_IM_Y = sum((stimulstype==1)&(KB==68));
    % (3)B5_NO
    % B5_NO_RT
    DATAsubject(j).B5_NO_Y_RT = mean(RT(1,(stimulstype==3)&(KB==68)));
    DATAsubject(j).B5_NO_N_RT = mean(RT(1,(stimulstype==3)&(KB==75)));
    % B5_NO_Y
    DATAsubject(j).B5_NO_Y = sum((stimulstype==3)&(KB==68));
end

%%
% 5 Block整合
for j=1:DATA_num-2
    % SubInfo
    DATASV(j).SubID = DATAsubject(j).SubID;
    DATASV(j).Group = DATAsubject(j).Group;
    DATASV(j).Sex = DATAsubject(j).Sex;
    DATASV(j).Age = DATAsubject(j).Age;
    DATASV(j).Edu = DATAsubject(j).Edu;
    % 三个情绪
    % PreEmo
    DATASV(j).PreEmo = mean ([DATAsubject(j).B1PreEmo,DATAsubject(j).B2PreEmo,DATAsubject(j).B1PreEmo,DATAsubject(j).B4PreEmo,DATAsubject(j).B5PreEmo]);
    % MidEmo
    DATASV(j).MidEmo = mean ([DATAsubject(j).B1PstEmo1,DATAsubject(j).B2PstEmo1,DATAsubject(j).B3PstEmo1,DATAsubject(j).B4PstEmo1,DATAsubject(j).B5PstEmo1]);
    % PstEmo
    DATASV(j).PstEmo = mean ([DATAsubject(j).B1PstEmo2,DATAsubject(j).B2PstEmo2,DATAsubject(j).B3PstEmo2,DATAsubject(j).B4PstEmo2,DATAsubject(j).B5PstEmo2]);
    % IM
    % IM_Y
    DATASV(j).IM_Y = sum ([DATAsubject(j).B1_IM_Y,DATAsubject(j).B2_IM_Y,DATAsubject(j).B3_IM_Y,DATAsubject(j).B4_IM_Y,DATAsubject(j).B5_IM_Y]);
    % IM_RT
    DATASV(j).IM_Y_RT = mean ([DATAsubject(j).B1_IM_Y_RT,DATAsubject(j).B2_IM_Y_RT,DATAsubject(j).B3_IM_Y_RT,DATAsubject(j).B4_IM_Y_RT,DATAsubject(j).B5_IM_Y_RT]);
    DATASV(j).IM_N_RT = mean ([DATAsubject(j).B1_IM_N_RT,DATAsubject(j).B2_IM_N_RT,DATAsubject(j).B3_IM_N_RT,DATAsubject(j).B4_IM_N_RT,DATAsubject(j).B5_IM_N_RT]);
    % PE
    % PE_Y
    DATASV(j).PE_Y = sum ([DATAsubject(j).B1_PE_Y,DATAsubject(j).B2_PE_Y,DATAsubject(j).B3_PE_Y,DATAsubject(j).B4_PE_Y,DATAsubject(j).B5_PE_Y]);
    % PE_RT
    DATASV(j).PE_Y_RT = mean ([DATAsubject(j).B1_PE_Y_RT,DATAsubject(j).B2_PE_Y_RT,DATAsubject(j).B3_PE_Y_RT,DATAsubject(j).B4_PE_Y_RT,DATAsubject(j).B5_PE_Y_RT]);
    DATASV(j).PE_N_RT = mean ([DATAsubject(j).B1_PE_N_RT,DATAsubject(j).B2_PE_N_RT,DATAsubject(j).B3_PE_N_RT,DATAsubject(j).B4_PE_N_RT,DATAsubject(j).B5_PE_N_RT]);
    % NO
    % NO_Y
    DATASV(j).NO_Y = sum ([DATAsubject(j).B1_NO_Y,DATAsubject(j).B2_NO_Y,DATAsubject(j).B3_NO_Y,DATAsubject(j).B4_NO_Y,DATAsubject(j).B5_NO_Y]);
    % NO_RT
    DATASV(j).NO_Y_RT = mean ([DATAsubject(j).B1_NO_Y_RT,DATAsubject(j).B2_NO_Y_RT,DATAsubject(j).B3_NO_Y_RT,DATAsubject(j).B4_NO_Y_RT,DATAsubject(j).B5_NO_Y_RT]);
    DATASV(j).NO_N_RT = mean ([DATAsubject(j).B1_NO_N_RT,DATAsubject(j).B2_NO_N_RT,DATAsubject(j).B3_NO_N_RT,DATAsubject(j).B4_NO_N_RT,DATAsubject(j).B5_NO_N_RT]);
end
% 6 写excel
columnheader1={'SubID','Group','Sex','Age','Edu','PreEmo','MidEmo','PstEmo','IM_Y','IM_Y_RT','IM_N_RT','PE_Y','PE_Y_RT','PE_N_RT','NO_Y','NO_Y_RT','NO_N_RT'};
Sizechd1=size(columnheader1);
alldata=[columnheader1;(reshape(struct2cell(DATASV),Sizechd1(2),DATA_num-2))'];

filename1=strcat('Alldata.xlsx');
[file,path]=uiputfile('*.*','File Selection',filename1);
xlswrite([path file],alldata,2,'A1');


