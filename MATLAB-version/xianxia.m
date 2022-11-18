%清0和初始赋值很重要啊
right_shift=[];
left_shift=[];
right_shift1=[];
left_shift1=[];
relative_Rmax_Rface=[];
relative_Rmax_Rface1=[];

%这个是整体不分组所有的数据来找deltaR1
delta_1(1,1)=find_min_delta_fuction_version1(face_who,numfile,r_initial); 
alldata_othernode=r_initial;
alldata_othernode(:,face_who)=[];   
alldata_othernode_upperbound=0-max(max(alldata_othernode));
alldata_facenode_lowerbound=0-min(r_initial(:,face_who));
disp(['原始整体数据最近点最小值|Rvalue|，12轮下界：',num2str(alldata_facenode_lowerbound)]);
disp(['原始整体数据除最近其他点最大|Rvalue|，12轮上界：',num2str(alldata_othernode_upperbound)]);

%Gaussian去掉跳变值,每个去掉多少不确定，维度不一样,没有可比性，不是同一个时间段采集的     
%采集时：30个一组，所以要分组+取出每组第一个数和采样的sample+合并成大区间，在求deltaR
for j=1:1:(num_all/everygroup_num);
    %取出每组第一个数+每组的前sample的数：要不要去掉第一个数？？？？？？？？？？？
    %如果去掉第一个数，sample_num最大29，那么F2F就没法做到m=30啦
    for i3=1:numfile
        r_firstvalue_grouped(j,i3)=r_initial((1+(j-1)*everygroup_num),i3);
        r_samplenum_grouped((1+(j-1)*sample_num):(j*sample_num),i3)= ...
            r_initial((2+(j-1)*everygroup_num):(sample_num+1+(j-1)*everygroup_num),i3);
        %高斯滤波成一个数,审稿意见说高斯已经不管用了?
%         r_Gauss_grouped(j,i3)=mean(gaosi_function ...
%             (r_samplenum_grouped((1+(j-1)*sample_num):(j*sample_num),i3),sample_num));
          r_Gauss_grouped(j,i3)=mean( ...
            r_samplenum_grouped((1+(j-1)*sample_num):(j*sample_num),i3));
    end      

    %先分组，直接对最近的node所有值均值滤波，来求F2F的阈值shreshold
%     F2F_mean_grouped(j,1)=mean(r_initial((1+(j-1)*everygroup_num):(j*everygroup_num),face_who));
    F2F_mean_grouped(j,1)=mean(r_initial((1+(j-1)*everygroup_num):(sample_num+(j-1)*everygroup_num),face_who));
    
    %先分组，直接对最近的node每组sample个值EWMA滤波     
    for m=1:1:sample_num
        if m==1
            E = r_samplenum_grouped((m+(j-1)*sample_num),face_who);
        else
            E = r_samplenum_grouped((m+(j-1)*sample_num),face_who)*0.5+E*0.5;
        end
    end
    F2F_EWMA_grouped(j,1)=E;

    %每一组取第一个数和滤波之后，直接求一次deltaR，不用区间来求
    %deltaR_everygroup的第一列是每一组求出来deltaR1，第二列是每一组求出来的deltaR2
    deltaR_everygroup(j,1)=find_min_delta_fuction_version1(face_who,numfile,r_firstvalue_grouped); 
    deltaR_everygroup(j,2)=find_min_delta_fuction_version1(face_who,numfile,r_Gauss_grouped); 
    
    %记录每组实验中Rmax的位置,注意离线和在线Rmax不同，但都是从Rmax开始判断
%     both_leftright_flag=0; %为了提醒，在线的时候，要从Rmax位置的两边都移动找最近节点
%     Rmax=max(r_Gauss_grouped(j,:));
%     [r1,Rmax_index_gaussed]=find(r_Gauss_grouped(j,:)==Rmax);  %index不可能出现重复的
%     relative_Rmax_Rface=[];
    Rmax=max(r_firstvalue_grouped(j,:));
    [r1,Rmax_index_gaussed]=find(r_firstvalue_grouped(j,:)==Rmax);  %index不可能出现重复的
    [~,Rmax_num]=size(Rmax_index_gaussed);
    if(Rmax_num==1)     %只有一个RSSI最大值
%         loc_Rmax_notRepeat(j,1)=Rmax_index_gaussed;  %有重复的Rmax不会纪录在此数组
%         relative_Rmax_Rface(j,1)=loc_Rmax_notRepeat(j,1)-face_who;%正右负左
        relative_Rmax_Rface=[relative_Rmax_Rface;(Rmax_index_gaussed-face_who)];
    else    %有重复的RSSI最大值，找到距离的最远值，正负情况要区分
        for ii5=1:1:Rmax_num;
%             multiple_relative_Rmax_Rface(i5,1)=Rmax_index_gaussed(1,i5)-face_who;
            relative_Rmax_Rface=[relative_Rmax_Rface;(Rmax_index_gaussed(1,ii5)-face_who)];
        end
%         [max_index,~]=find(abs(multiple_relative_Rmax_Rface)==max(abs(multiple_relative_Rmax_Rface)));
%         [size_max_index,~]=size(max_index);
%         if(size_max_index>1)  %正负都出现了,即位置差有正有负，大小可能相等，可能不相等
%             relative_Rmax_Rface(j,1)=multiple_relative_Rmax_Rface(max_index(1,1),1);%正负绝对值都存在最大值且相等，则还是用这个最大值，这种情况在线时左右都要移动
% %             both_leftright_flag=1; %注意什么时候清0
%         else
%             relative_Rmax_Rface(j,1)=multiple_relative_Rmax_Rface(max_index,1);%正右负左,找到距离最远的Rmax的移动信息：正负？
%         end        
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%
    %为了第二轮的筛选用位置差
    %记录所有的Rmax和最近点的位置差。多于group很正常，因为每组实验可能有多个Rmax
    %%%%%%%%%%%%%%%%%%%%%%%%%
%     both_leftright_flag=0; %为了提醒，在线的时候，要从Rmax位置的两边都移动找最近节点
    Rmax1=max(r_Gauss_grouped(j,:));
    [~,Rmax_index_gaussed1]=find(r_Gauss_grouped(j,:)==Rmax1);  %index不可能出现重复的
%     Rmax=max(r_firstvalue_grouped(j,:));
%     [r1,Rmax_index_gaussed]=find(r_firstvalue_grouped(j,:)==Rmax);  %index不可能出现重复的
    [~,Rmax_num1]=size(Rmax_index_gaussed1);
    if(Rmax_num1==1)     %只有一个RSSI最大值
%         loc_Rmax_notRepeat1(j,1)=Rmax_index_gaussed1;  %有重复的Rmax不会纪录在此数组
%         relative_Rmax_Rface1(j,1)=loc_Rmax_notRepeat1(j,1)-face_who;%正右负左
        relative_Rmax_Rface1=[relative_Rmax_Rface1;(Rmax_index_gaussed1-face_who)];
    else    %有重复的RSSI最大值，找到距离的最远值，正负情况要区分
        for i5=1:1:Rmax_num1;
%             multiple_relative_Rmax_Rface1(i5,1)=Rmax_index_gaussed1(1,i5)-face_who;
            relative_Rmax_Rface1=[relative_Rmax_Rface1;(Rmax_index_gaussed1(1,i5)-face_who)];
        end
%         [max_index1,~]=find(abs(multiple_relative_Rmax_Rface1)==max(abs(multiple_relative_Rmax_Rface1)));
%         [size_max_index1,~]=size(max_index1);
%         if(size_max_index1>1)  %正负都出现了,即位置差有正有负，大小可能相等，可能不相等
%             relative_Rmax_Rface1(j,1)=multiple_relative_Rmax_Rface1(max_index1(1,1),1);%正负绝对值都存在最大值且相等，则还是用这个最大值，这种情况在线时左右都要移动
% %             both_leftright_flag=1; %注意什么时候清0
%         else
%             relative_Rmax_Rface1(j,1)=multiple_relative_Rmax_Rface1(max_index1,1);%正右负左,找到距离最远的Rmax的移动信息：正负？
%         end        
    end
    
end

%横向对比：分好组之后，每组的第一个数和sample的数组成新的区间，用这些区间来找deltaR1和deltaR2
%横向对比大问题：不能保证求deltaR的区间的上下界是同时的
delta_1_grouped(1,1)=find_min_delta_fuction_version1(face_who,numfile,r_firstvalue_grouped); 
delta_2_gauss_grouped(1,1)=find_min_delta_fuction_version1(face_who,numfile,r_Gauss_grouped); 
%不横向对比
delta_1_min=min(deltaR_everygroup(:,1));
delta_2_min=min(deltaR_everygroup(:,2));
face_gauss_filtered_min_Rvalue=0-min(r_Gauss_grouped(:,face_who)); %lmk,m次滤波后目标机器2筛滤波后最近点的最小值
face_first_value_min_Rvalue=0-min(r_firstvalue_grouped(:,face_who));%l1k,第一次目标机器，1筛每组第一个数的最小值
NearbyNode_r_Gauss_grouped=r_Gauss_grouped;
NearbyNode_r_Gauss_grouped(:,face_who)=[];%去掉最近点的滤波后的数据（M-)
Notface_gauss_filtered_max_Rvalue=0-max(max(NearbyNode_r_Gauss_grouped));
NearbyNode_r_firstvalue_grouped=r_firstvalue_grouped;
NearbyNode_r_firstvalue_grouped(:,face_who)=[];%去掉最近点的每组第一个数的数据(M-)
Notface_first_value_max_Rvalue= 0-max(max(NearbyNode_r_firstvalue_grouped));

disp(['deltaR1：',num2str(delta_1_min)]);
disp(['deltaR2：',num2str(delta_2_min)]);
disp(['最近点第一个值最小|Rvalue|，1轮下界：',num2str(face_first_value_min_Rvalue)]);
disp(['最近点滤波后最小|Rvalue|，2轮下界：',num2str(face_gauss_filtered_min_Rvalue)]);
disp(['除最近点其他点第一个值最大|Rvalue|，1轮上界：',num2str(Notface_first_value_max_Rvalue)]);
disp(['除最近点其他点滤波后最大|Rvalue|，2轮上界：',num2str(Notface_gauss_filtered_max_Rvalue)]);

%输出Rmax位置和Rface的相对关系
left_shift_max=max(relative_Rmax_Rface(find(relative_Rmax_Rface>=0)));
right_shift_max=0-min(relative_Rmax_Rface(find(relative_Rmax_Rface<0)));
if(isempty(left_shift_max)) %判断是否为空，空为1
    left_shift_max=0;
end
if(isempty(right_shift_max))
    right_shift_max=0;
end
shift_max=max(left_shift_max,right_shift_max);
%对于最近点正好是Rmax，即移动0，也需要记录
[left_shift(:,1),~]=size(find(relative_Rmax_Rface==0));
[right_shift(:,1),~]=size(find(relative_Rmax_Rface==0));%每列代表从Rmax左移j1个位置的情况有多少个
disp(['从Rmax位置移动0个位置有',num2str(right_shift(:,1)),'组数据']);
for j1=1:1:shift_max; %这两个数组仅仅是为了便于查看数据
    [left_shift(:,(j1+1)),c3]=size(find(relative_Rmax_Rface==j1));%每列代表从Rmax左移j1个位置的情况有多少个
    [right_shift(:,(j1+1)),c4]=size(find(relative_Rmax_Rface==(-j1)));%每列代表从Rmax右移j1个位置的情况有多少个
    disp(['从Rmax位置左移',num2str(j1),'个位置有',num2str(left_shift(:,(j1+1))),'组数据']);
    disp(['从Rmax位置右移',num2str(j1),'个位置有',num2str(right_shift(:,(j1+1))),'组数据']);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   输出Rmax位置和Rface的相对关系
%   第二轮直接位置差做准备
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
left_shift_max1=max(relative_Rmax_Rface1(find(relative_Rmax_Rface1>=0)));
right_shift_max1=0-min(relative_Rmax_Rface1(find(relative_Rmax_Rface1<0)));
if(isempty(left_shift_max1))
    left_shift_max1=0;
end
if(isempty(right_shift_max1))
    right_shift_max1=0;
end
shift_max1=max(left_shift_max1,right_shift_max1); %若等于0，表明都是最近点，不用下述循环
%对于最近点正好是Rmax，即移动0，也需要记录
[left_shift1(:,1),~]=size(find(relative_Rmax_Rface1==0));
[right_shift1(:,1),~]=size(find(relative_Rmax_Rface1==0));%每列代表从Rmax左移j1个位置的情况有多少个
disp(['从Rmax位置移动0个位置有',num2str(right_shift1(:,1)),'组数据']);
for j1=1:1:shift_max1; %这两个数组仅仅是为了便于查看数据
    [left_shift1(:,(j1+1)),c3]=size(find(relative_Rmax_Rface1==j1));%每列代表从Rmax左移j1个位置的情况有多少个
    [right_shift1(:,(j1+1)),c4]=size(find(relative_Rmax_Rface1==(-j1)));%每列代表从Rmax右移j1个位置的情况有多少个
    disp(['从Rmax位置左移',num2str(j1),'个位置有',num2str(left_shift1(:,(j1+1))),'组数据']);
    disp(['从Rmax位置右移',num2str(j1),'个位置有',num2str(right_shift1(:,(j1+1))),'组数据']);
end

% % 画图
% figure(1);
% subplot(2,2,1);
% plot_function(r_initial(:,1),r_initial(:,2),r_initial(:,3),r_initial(:,4), ...
%     r_initial(:,5),r_initial(:,6),r_initial(:,7));
% legend(['1 ',num2str(mean(r_initial(:,1))),' Std: ',num2str(std(r_initial(:,1),0,1))], ...
%     ['2 ',num2str(mean(r_initial(:,2))),' Std: ',num2str(std(r_initial(:,2),0,1))], ...
%     ['3 ',num2str(mean(r_initial(:,3))),' Std: ',num2str(std(r_initial(:,3),0,1))], ...
%     ['4 ',num2str(mean(r_initial(:,4))),' Std: ',num2str(std(r_initial(:,4),0,1))], ...
%     ['5 ',num2str(mean(r_initial(:,5))),' Std: ',num2str(std(r_initial(:,5),0,1))], ...
%     ['6 ',num2str(mean(r_initial(:,6))),' Std: ',num2str(std(r_initial(:,6),0,1))], ...
%     ['7 ',num2str(mean(r_initial(:,7))),' Std: ',num2str(std(r_initial(:,7),0,1))]);%注释
% xlabel(['原始数据',' 样本数量：',num2str(sample_num)]);
% subplot(2,2,2);
% plot_function(r_firstvalue_grouped(:,1),r_firstvalue_grouped(:,2),r_firstvalue_grouped(:,3), ...
%     r_firstvalue_grouped(:,4),r_firstvalue_grouped(:,5),r_firstvalue_grouped(:,6),r_firstvalue_grouped(:,7));
% legend(['max: ',num2str(max(r_firstvalue_grouped(:,1))),' min: ',num2str(min(r_firstvalue_grouped(:,1)))], ...
%     ['max: ',num2str(max(r_firstvalue_grouped(:,2))),' min: ',num2str(min(r_firstvalue_grouped(:,2)))], ...
%     ['max: ',num2str(max(r_firstvalue_grouped(:,3))),' min: ',num2str(min(r_firstvalue_grouped(:,3)))], ...
%     ['max: ',num2str(max(r_firstvalue_grouped(:,4))),' min: ',num2str(min(r_firstvalue_grouped(:,4)))], ...
%     ['max: ',num2str(max(r_firstvalue_grouped(:,5))),' min: ',num2str(min(r_firstvalue_grouped(:,5)))], ...
%     ['max: ',num2str(max(r_firstvalue_grouped(:,6))),' min: ',num2str(min(r_firstvalue_grouped(:,6)))], ...
%     ['max: ',num2str(max(r_firstvalue_grouped(:,7))),' min: ',num2str(min(r_firstvalue_grouped(:,7)))]);%注释
% xlabel(['每一组的第一个数',' 样本数量：',num2str(sample_num)]);
% subplot(2,2,3);
% plot_function(r_Gauss_grouped(:,1),r_Gauss_grouped(:,2),r_Gauss_grouped(:,3), ...
%     r_Gauss_grouped(:,4),r_Gauss_grouped(:,5),r_Gauss_grouped(:,6),r_Gauss_grouped(:,7));
% legend(['max: ',num2str(max(r_Gauss_grouped(:,1))),' min: ',num2str(min(r_Gauss_grouped(:,1)))], ...
%     ['max: ',num2str(max(r_Gauss_grouped(:,2))),' min: ',num2str(min(r_Gauss_grouped(:,2)))], ...
%     ['max: ',num2str(max(r_Gauss_grouped(:,3))),' min: ',num2str(min(r_Gauss_grouped(:,3)))], ...
%     ['max: ',num2str(max(r_Gauss_grouped(:,4))),' min: ',num2str(min(r_Gauss_grouped(:,4)))], ...
%     ['max: ',num2str(max(r_Gauss_grouped(:,5))),' min: ',num2str(min(r_Gauss_grouped(:,5)))], ...
%     ['max: ',num2str(max(r_Gauss_grouped(:,6))),' min: ',num2str(min(r_Gauss_grouped(:,6)))], ...
%     ['max: ',num2str(max(r_Gauss_grouped(:,7))),' min: ',num2str(min(r_Gauss_grouped(:,7)))]);%注释
% xlabel(['每一组的前m个数高斯滤波之后',' 样本数量：',num2str(sample_num)]);
% subplot(2,2,4);
% plot(deltaR_everygroup(:,1),'ro-','linewidth',2);
% hold on;
% plot(deltaR_everygroup(:,2),'gd-','linewidth',2);
% hold on;
% legend(['deltaR1: mean: ',num2str(mean(deltaR_everygroup(:,1))),' min: ',num2str(min(deltaR_everygroup(:,1)))], ...
%     ['deltaR2: mean: ',num2str(mean(deltaR_everygroup(:,2))),' min: ',num2str(min(deltaR_everygroup(:,2)))]);%注释
% xlabel('不横向对比，一组算一次deltaR，不用区间');
% 
min_average_threshold_F2F=min(F2F_mean_grouped);
mean_average_F2F=mean(F2F_mean_grouped);
min_EWMA_threshold_F2F=min(F2F_EWMA_grouped);
mean_EWMA_F2F=mean(F2F_EWMA_grouped);
disp(['均值滤波阈值：平均',num2str(mean_average_F2F)]);
disp(['均值滤波阈值：最小',num2str(min_average_threshold_F2F)]);
disp(['EWMA滤波阈值：平均',num2str(mean_EWMA_F2F)]);
disp(['EWMA滤波阈值：最小',num2str(min_EWMA_threshold_F2F)]);
