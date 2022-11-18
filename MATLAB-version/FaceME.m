clc;
clear;
close all;
filepath='E:\fuda\HMI\数据\5个\0608z\';%先设置好txt文件所在路径，譬如当前文件夹下的文件'A'中
dir1=dir(sprintf('%s*.txt',filepath));%把文件夹下的txt文件列表存放到dir1中
numfile=size(dir1,1);%给出文件个数
start=61;
% last=size(r_initial(:,1),1); %获得矩阵行数，每个点收集的次数
last=3000; 
face_who=3
r_evertime=[];
everygroup_num=30;  %分组，每组多少个数
sample_num=10;   %采样次数，多少值来滤波;保证FM和F2F都是测试集和训练集一样的就好
num_all=(last-start+1);%减去舍弃的点
fid33=fopen('success_rate_zuoyou.txt', 'a');  %wt会不停地重写，会覆盖，a是在txt中不断往后添加
fid1=fopen('parameter_set_zuoyou.txt', 'a');



for i1=1:numfile  %n是要读入的文件的个数
   data=load([filepath,'RSSI',num2str(i1),'.txt']);
   r_initial(:,i1)=data(start:last,1);           %%%%统一格式：一个node，存1列
end
if(sample_num==30)
    collecttime=29;   %选取的样本数量,注意FM的样本数量要少1，第一个数用来第一次筛选
else
    collecttime=sample_num;
end
% mean(r_initial)
% median(r_initial);
% mode(r_initial)


first_initial=[];
for n=1:numfile
    eval(['r',num2str(n),'=','r_initial(:,n)',';']);
end
% for i=1:numfile
%     eval(['sor',num2str(n),'=','r_initial(:,n)',';']);
%  end
% mean(r_initial)
% plot_function(r1,r2,r3,r4,0,0,0);
% %legend('r1','r2','r3','r4');%注释
% subplot(2,2,1)
% plot(r1)
% box off
% subplot(2,2,2)
% plot(r2)
% box off
% subplot(2,2,3)
% plot(r3)
% box off
% subplot(2,2,4)
% plot(r4)
% box off
 run('E:\fuda\HMI\数据\2222\xianxia.m');

data_all=size(r_initial(:,1),1);
data_all=(last-start+1);
data_sample=30;
BLE_num=numfile;
collecttime=10; %9
deltaR1=-delta_1_min;
deltaR7=-delta_2_min;
Consume_time_sum=0;  %要叠加，起始给0
Consume_time_auto=0;
Consume_time_manu=0;

 fid=fopen('final_result.txt', 'wt');
%每一次换dxdy的时候清0
succeed_count=0;
size_select_node=[0,0,0,0,0,0,0,0,0,0]; %第一个值：保存筛选出来0个节点的个数，以此类推

% group=45;
for group=1:1:(data_all/data_sample);
    %每连接一次，这些值最好清0
    first_initial=[];
    second_initial=[];
    gauss=[];
    filter_result=[];
    
    %先取出单次需要的数据个数
    for i=1:numfile
    r_evertime(:,i)=r_initial((1+(group-1)*data_sample):(group*data_sample),i);
    first_initial(i,1)=0- r_evertime(1,i);
    end
    
% 

  %开始第一轮筛选，先判断条件，是否第一轮可直接选出
    first_sort=sort(first_initial);
    first_min=first_sort(1,1);     %是否每组第一个数超出上界
    [first_index,column]=find(first_initial<Notface_first_value_max_Rvalue);%取索引值，索引的个数为节点个数，值为对应的节点（位置）
    [first_select_node_num,column1]=size(first_index);%仅仅找出筛选出几个点
    if(first_select_node_num==1)  
        select_mode=1;      %1轮直选
    else if(first_select_node_num>0)
            select_mode=2;      %1轮直选出的点有多个，需2轮筛选
         else
            select_mode=3;      %1轮没选出，需2轮筛选
         end
    end
    
    select_mode_show(group,1)=select_mode;  %记录看看都是怎么选出来的
    
    switch select_mode
        case 1
            if(first_index==face_who)   %面对哪个点？
                succeed_count=succeed_count+1;
            end
            fprintf(fid, '%s ',['筛选出节点的个数：',num2str(1)]); 
            fprintf(fid, '\n');  %100组每组筛选出来的结果
            fprintf(fid, '%s ', ['节点：',num2str(first_index)]);
            size_select_node(1,(first_select_node_num+1))=size_select_node(1,(first_select_node_num+1))+1;%为了最终的结果输出
        case 2
            for j=1:1:first_select_node_num;  %选出来有几个node就执行多少遍，按列将剩下的采集值存到数组，进行滤波
                second_initial(1:collecttime,j)=find_seconddeal_need_node(first_index(j,1),collecttime, r_evertime);
%                 gauss(1,j) = 0-mean(gaosi_function(second_initial(1:collecttime,j),collecttime));
                gauss(1,j) = 0-mean(second_initial(1:collecttime,j));
            end 
        case 3
            %重新第一轮筛选
            first_initial(first_initial>(face_first_value_min_Rvalue))=0;
            [first_index,column]=find(first_initial>0);%取索引值，索引的个数为节点个数，值为对应的节点（位置）
            [first_select_node_num,column1]=size(first_index);%仅仅找出筛选出几个点
            for j=1:1:first_select_node_num;  %选出来有几个node就执行多少遍，按列将剩下的采集值存到数组，进行滤波
                second_initial(1:collecttime,j)=find_seconddeal_need_node(first_index(j,1),collecttime,r_evertime);
%                 gauss(1,j) = 0-mean(gaosi_function(second_initial(1:collecttime,j),collecttime));
                gauss(1,j) = 0-mean(second_initial(1:collecttime,j));
            end
    end 
    
    if(select_mode>1 & first_select_node_num~=0)
        %找出滤波后的最小值，为第二轮滤波做准备
        gauss_sort=sort(gauss);
        filter_min=gauss_sort(1,1);
        
        for k=1:1:first_select_node_num;  %将滤波之后的值存到结果数组的对应索引的位置吗，其他地方补0
            filter_result(first_index(k,1),1)=gauss(1,k);
        end
        if (size(filter_result)<BLE_num)
            filter_result(BLE_num,1)=0;  %不够的补0，保证有值的索引对应相应的节点
        end 
        
        %开始第二轮筛选，判断是否可以2轮直选，不行的话再切
        if(filter_min<Notface_gauss_filtered_max_Rvalue)
            [final_index,column3]=find(filter_result>0 & filter_result<Notface_gauss_filtered_max_Rvalue);%因为补0了，要加限制>0;取索引值，索引的个数为节点个数，值为对应的节点（位置）
        else           
            filter_result(filter_result>(face_gauss_filtered_min_Rvalue))=0;
            [final_index,column3]=find(filter_result>0);%取索引值，索引的个数为节点个数，值为对应的节点（位置）
        end

        %输出和计算结果,每一轮选出几个点，分别是什么
        [final_index_num,column4]=size(final_index);%仅仅找出筛选出几个点
        size_select_node(1,(final_index_num+1))=size_select_node(1,(final_index_num+1))+1;%为了最终的结果输出
        fprintf(fid, '%s ',['筛选出节点的个数：',num2str(final_index_num)]); 
        fprintf(fid, '\n');  %100组每组筛选出来的结果
    % % % % % % %     disp(['筛选出节点个数：',num2str(final_index_num)]);
        for g=1:1:final_index_num;
    % % % % % % %         disp(['节点：',num2str(final_index(g,1))]);
            fprintf(fid, '%s ', ['节点：',num2str(final_index(g,1))]); 
            fprintf(fid, '\n');
            if(final_index(g,1)==face_who)   %面对哪个点？
                succeed_count=succeed_count+1;
            end
        end
    else if(select_mode>1 & first_select_node_num==0) %为了防止第一轮筛选一个都没有找到，程序挂了
            fprintf(fid, '%s ',['筛选出节点的个数：',num2str(0)]); 
            fprintf(fid, '\n');  %100组每组筛选出来的结果
            fprintf(fid, '%s ', ['节点：',num2str(first_index)]);
            size_select_node(1,(first_select_node_num+1))=size_select_node(1,(first_select_node_num+1))+1;%为了最终的结果输出 
        end
    end
    
    
    %时间模型
    temp1=9.605*(10/(1.343*100+9.7));
    T11=(1.343*100+9.7)*exp(temp1);
    if (select_mode==1)
        auto_time=T11*1;
    else
        temp=9.605*(first_select_node_num/(1.343*100+9.7));
        T12=(1.343*100+9.7)*exp(temp);
        auto_time=T11*1+T12*collecttime;
    end
    
    if (select_mode==1)
        manu_time=0;
    else if (final_index_num<=1)  %2轮没选到，也没有手动选择时间
            manu_time=0;
        else
%             manu_time=(970.12+76.88*final_index_num)*2;
            manu_time=1491.5+247.6*final_index_num;
        end
    end
            
%     if (final_index_num==1)
%         manu_time=0;
%     else
%         manu_time=870.1+123.8*final_index_num;
%     end

    Consume_time_auto=Consume_time_auto+auto_time;
    Consume_time_manu=Consume_time_manu+manu_time;
    Consume_time_sum=Consume_time_sum+(manu_time+auto_time);
    
%     %每一轮筛选出来的节点个数保存
    first_node_save(group,1)=first_select_node_num;
%     second_node_save(group,1)=final_index_num;
%     
end
%所有循环都结束，输出结果
disp(['成功率：',num2str(succeed_count/(data_all/data_sample)*100)]);
fprintf(fid, '%s ', ['成功率：',num2str(succeed_count/(data_all/data_sample)*100)]); 
fprintf(fid, '\n');
for n=1:1:10;
    if size_select_node(1,n)~=0;
        disp(['筛选出：',num2str(n-1),'个节点：',num2str(size_select_node(1,n))]);
        fprintf(fid, '%s ', ['筛选出：',num2str(n-1),'个节点：',num2str(size_select_node(1,n))]); 
        fprintf(fid, '\n');
    end
end

% % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% collecttime=sample_num;
% % F2F_mean_min=0-min_EWMA_threshold_F2F;      %dx12
% F2F_mean_min=0-min_average_threshold_F2F;
% % F2F_mean_min=face_first_value_min_Rvalue;
% run('E:\fuda\HMI\数据\2222\FacetoFace_7node.m');
% fprintf(fid33, '%s ', [num2str(1),'--F2F成功率：',num2str(succeed_count/(data_all/data_sample)*100)]); 
% fprintf(fid33, '\n');
% for n=1:1:10;
%     if size_select_node(1,n)~=0;
%         fprintf(fid33, '%s ', ['筛选出：',num2str(n-1),'个节点：',num2str(size_select_node(1,n))]); 
%         fprintf(fid33, '\n');
%     end
% end
meanr=[];
meanr=mean(r_initial);
% moder=[];
% moder=mode(r_initial)



