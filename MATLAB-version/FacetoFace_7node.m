% conn=database('dx9-dy15-18.db','','','org.sqlite.JDBC','jdbc:sqlite:G:/wrk/filter data/dx9-dy15-18.db');
% ping(conn)
% 
% curs1=exec(conn,'select RSSI,curtime from RSSI1');
% dat1=fetch(curs1);
% dat1=dat1.Data;
% 
% curs2=exec(conn,'select RSSI,curtime from RSSI2');
% dat2=fetch(curs2);
% dat2=dat2.Data;
% 
% curs3=exec(conn,'select RSSI,curtime from RSSI3');
% dat3=fetch(curs3);
% dat3=dat3.Data;
% 
% curs4=exec(conn,'select RSSI,curtime from RSSI4');
% dat4=fetch(curs4);
% dat4=dat4.Data;
%  
% curs5=exec(conn,'select RSSI,curtime from RSSI5');
% dat5=fetch(curs5);
% dat5=dat5.Data;
% 
% start=1001;
% over=2000;
% 
% r1=cell2mat(dat1(start:over,1));
% r2=cell2mat(dat2(start:over,1));
% r3=cell2mat(dat3(start:over,1));
% r4=cell2mat(dat4(start:over,1));
% r5=cell2mat(dat5(start:over,1));

% % % % % % % start=91;
% % % % % % % last=3000;
% % % % % % % data_all=(last-start+1);
% % % % % % % data_sample=30;     %分组之后的每组个数
% % % % % % % BLE_num=7;
% % % % % % % collecttime=7;   %选取的样本数量
% % % % % % % facewho=4;
% % % % % % % F2F_mean_min=51;      %dx12
%fid=fopen('F2F_final_result.txt', 'wt');
%每一次换dxdy的时候清0
succeed_count=0;
size_select_node=[0,0,0,0,0,0,0,0,0,0]; %第一个值：保存筛选出来0个节点的个数，以此类推
Consume_time_manu1=0;%有叠加，要清0

% % % % % % % %循环读入文件+注意维度要一致
% % % % % % % filepath='G:\王荣凯\TII重投-N6-论文新实验\4-7个点重测-旧摆法node4321758-新理想场景\12.18\';%文件夹的路径
% % % % % % % % filepath='C:\Users\Administrator\Documents\MATLAB\滤波算法\N6_data\dx12\dy18\';%文件夹的路径
% % % % % % % % filepath='C:\Users\Administrator\Documents\MATLAB\滤波算法\N6_data\dx12\左右移动-dx12dy12\7对4，左移45cm\';%文件夹的路径
% % % % % % % % filepath='C:\Users\Administrator\Documents\MATLAB\滤波算法\N6_data\dx12\左右移动-dx12dy12\7对4，右移45cm\';%文件夹的路径
% % % % % % % for i1=1:7  %n是要读入的文件的个数
% % % % % % %    data=load([filepath,'RSSI',num2str(i1),'.txt']);
% % % % % % %    r_initial(:,i1)=data(start:last,1);           %%%%统一格式：一个node，存1列
% % % % % % % end

% group=45;
for group=1:1:(data_all/data_sample);
    %每连接一次，这些值最好清0
    first_initial=[];
    E=[];
    
    %先取出单次需要的数据个数(即即每组20个数，按循环次数),每次换组都会覆盖数据+取出每组的第一个数
    for i1=1:numfile
        r_everytime(:,i1)=r_initial((1+(group-1)*data_sample):(group*data_sample),i1);
        first_initial(:,i1)=r_everytime(1:collecttime,i1);
    end
    
    %EWMA滤波
    for j=1:1:numfile;  %有几个节点就滤几次波        
%         for m=1:1:collecttime
%             if m==1
%                 E(j,1)=0-first_initial(m,j);
%             else
%                 E(j,1) = (0-first_initial(m,j))*0.5+E(j,1)*0.5;
%             end
%         end
        E(j,1)=0-mean(first_initial(:,j));
    end
  
           
    %开始F2F筛选
    E(E>F2F_mean_min)=0;
    
    [final_index,column]=find(E>0);%取索引值，索引的个数为节点个数，值为对应的节点（位置）

    %输出和计算结果 
    [final_index_num,column4]=size(final_index);%仅仅找出筛选出几个点
    size_select_node(1,(final_index_num+1))=size_select_node(1,(final_index_num+1))+1;%为了最终的结果输出
    fprintf(fid, '%s ',['筛选出节点的个数：',num2str(final_index_num)]); 
    fprintf(fid, '\n');
% % % % % % %     disp(['筛选出节点个数：',num2str(final_index_num)]);
    for g=1:1:final_index_num;
% % % % % % %         disp(['节点：',num2str(final_index(g,1))]);
        fprintf(fid, '%s ', ['节点：',num2str(final_index(g,1))]); 
        fprintf(fid, '\n');
        if(final_index(g,1)==face_who)
            succeed_count=succeed_count+1;
        end
    end
    
    %手动选择的时间   
    if (final_index_num<=1)  %2轮没选到，也没有手动选择时间
        manu_time1=0;
    else
%         manu_time1=(970.12+76.88*final_index_num)*2;
        manu_time1=1491.5+247.6*final_index_num;
    end
    Consume_time_manu1=Consume_time_manu1+manu_time1;
    
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

% figure(3);
% plot_function(r_initial(:,1),r_initial(:,2),r_initial(:,3),r_initial(:,4), ...
%     r_initial(:,5),r_initial(:,6),r_initial(:,7));
% legend(['1 ',num2str(mean(r_initial(:,1))),' Std: ',num2str(std(r_initial(:,1),0,1))], ...
%     ['2 ',num2str(mean(r_initial(:,2))),' Std: ',num2str(std(r_initial(:,2),0,1))], ...
%     ['3 ',num2str(mean(r_initial(:,3))),' Std: ',num2str(std(r_initial(:,3),0,1))], ...
%     ['4 ',num2str(mean(r_initial(:,4))),' Std: ',num2str(std(r_initial(:,4),0,1))], ...
%     ['5 ',num2str(mean(r_initial(:,5))),' Std: ',num2str(std(r_initial(:,5),0,1))], ...
%     ['6 ',num2str(mean(r_initial(:,6))),' Std: ',num2str(std(r_initial(:,6),0,1))], ...
%     ['7 ',num2str(mean(r_initial(:,7))),' Std: ',num2str(std(r_initial(:,7),0,1))]);%注释