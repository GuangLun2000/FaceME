clc;
clear;
close all;
filepath='E:\fuda\HMI\����\5��\0608z\';%�����ú�txt�ļ�����·����Ʃ�統ǰ�ļ����µ��ļ�'A'��
dir1=dir(sprintf('%s*.txt',filepath));%���ļ����µ�txt�ļ��б��ŵ�dir1��
numfile=size(dir1,1);%�����ļ�����
start=61;
% last=size(r_initial(:,1),1); %��þ���������ÿ�����ռ��Ĵ���
last=3000; 
face_who=3
r_evertime=[];
everygroup_num=30;  %���飬ÿ����ٸ���
sample_num=10;   %��������������ֵ���˲�;��֤FM��F2F���ǲ��Լ���ѵ����һ���ľͺ�
num_all=(last-start+1);%��ȥ�����ĵ�
fid33=fopen('success_rate_zuoyou.txt', 'a');  %wt�᲻ͣ����д���Ḳ�ǣ�a����txt�в����������
fid1=fopen('parameter_set_zuoyou.txt', 'a');



for i1=1:numfile  %n��Ҫ������ļ��ĸ���
   data=load([filepath,'RSSI',num2str(i1),'.txt']);
   r_initial(:,i1)=data(start:last,1);           %%%%ͳһ��ʽ��һ��node����1��
end
if(sample_num==30)
    collecttime=29;   %ѡȡ����������,ע��FM����������Ҫ��1����һ����������һ��ɸѡ
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
% %legend('r1','r2','r3','r4');%ע��
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
 run('E:\fuda\HMI\����\2222\xianxia.m');

data_all=size(r_initial(:,1),1);
data_all=(last-start+1);
data_sample=30;
BLE_num=numfile;
collecttime=10; %9
deltaR1=-delta_1_min;
deltaR7=-delta_2_min;
Consume_time_sum=0;  %Ҫ���ӣ���ʼ��0
Consume_time_auto=0;
Consume_time_manu=0;

 fid=fopen('final_result.txt', 'wt');
%ÿһ�λ�dxdy��ʱ����0
succeed_count=0;
size_select_node=[0,0,0,0,0,0,0,0,0,0]; %��һ��ֵ������ɸѡ����0���ڵ�ĸ������Դ�����

% group=45;
for group=1:1:(data_all/data_sample);
    %ÿ����һ�Σ���Щֵ�����0
    first_initial=[];
    second_initial=[];
    gauss=[];
    filter_result=[];
    
    %��ȡ��������Ҫ�����ݸ���
    for i=1:numfile
    r_evertime(:,i)=r_initial((1+(group-1)*data_sample):(group*data_sample),i);
    first_initial(i,1)=0- r_evertime(1,i);
    end
    
% 

  %��ʼ��һ��ɸѡ�����ж��������Ƿ��һ�ֿ�ֱ��ѡ��
    first_sort=sort(first_initial);
    first_min=first_sort(1,1);     %�Ƿ�ÿ���һ���������Ͻ�
    [first_index,column]=find(first_initial<Notface_first_value_max_Rvalue);%ȡ����ֵ�������ĸ���Ϊ�ڵ������ֵΪ��Ӧ�Ľڵ㣨λ�ã�
    [first_select_node_num,column1]=size(first_index);%�����ҳ�ɸѡ��������
    if(first_select_node_num==1)  
        select_mode=1;      %1��ֱѡ
    else if(first_select_node_num>0)
            select_mode=2;      %1��ֱѡ���ĵ��ж������2��ɸѡ
         else
            select_mode=3;      %1��ûѡ������2��ɸѡ
         end
    end
    
    select_mode_show(group,1)=select_mode;  %��¼����������ôѡ������
    
    switch select_mode
        case 1
            if(first_index==face_who)   %����ĸ��㣿
                succeed_count=succeed_count+1;
            end
            fprintf(fid, '%s ',['ɸѡ���ڵ�ĸ�����',num2str(1)]); 
            fprintf(fid, '\n');  %100��ÿ��ɸѡ�����Ľ��
            fprintf(fid, '%s ', ['�ڵ㣺',num2str(first_index)]);
            size_select_node(1,(first_select_node_num+1))=size_select_node(1,(first_select_node_num+1))+1;%Ϊ�����յĽ�����
        case 2
            for j=1:1:first_select_node_num;  %ѡ�����м���node��ִ�ж��ٱ飬���н�ʣ�µĲɼ�ֵ�浽���飬�����˲�
                second_initial(1:collecttime,j)=find_seconddeal_need_node(first_index(j,1),collecttime, r_evertime);
%                 gauss(1,j) = 0-mean(gaosi_function(second_initial(1:collecttime,j),collecttime));
                gauss(1,j) = 0-mean(second_initial(1:collecttime,j));
            end 
        case 3
            %���µ�һ��ɸѡ
            first_initial(first_initial>(face_first_value_min_Rvalue))=0;
            [first_index,column]=find(first_initial>0);%ȡ����ֵ�������ĸ���Ϊ�ڵ������ֵΪ��Ӧ�Ľڵ㣨λ�ã�
            [first_select_node_num,column1]=size(first_index);%�����ҳ�ɸѡ��������
            for j=1:1:first_select_node_num;  %ѡ�����м���node��ִ�ж��ٱ飬���н�ʣ�µĲɼ�ֵ�浽���飬�����˲�
                second_initial(1:collecttime,j)=find_seconddeal_need_node(first_index(j,1),collecttime,r_evertime);
%                 gauss(1,j) = 0-mean(gaosi_function(second_initial(1:collecttime,j),collecttime));
                gauss(1,j) = 0-mean(second_initial(1:collecttime,j));
            end
    end 
    
    if(select_mode>1 & first_select_node_num~=0)
        %�ҳ��˲������Сֵ��Ϊ�ڶ����˲���׼��
        gauss_sort=sort(gauss);
        filter_min=gauss_sort(1,1);
        
        for k=1:1:first_select_node_num;  %���˲�֮���ֵ�浽�������Ķ�Ӧ������λ���������ط���0
            filter_result(first_index(k,1),1)=gauss(1,k);
        end
        if (size(filter_result)<BLE_num)
            filter_result(BLE_num,1)=0;  %�����Ĳ�0����֤��ֵ��������Ӧ��Ӧ�Ľڵ�
        end 
        
        %��ʼ�ڶ���ɸѡ���ж��Ƿ����2��ֱѡ�����еĻ�����
        if(filter_min<Notface_gauss_filtered_max_Rvalue)
            [final_index,column3]=find(filter_result>0 & filter_result<Notface_gauss_filtered_max_Rvalue);%��Ϊ��0�ˣ�Ҫ������>0;ȡ����ֵ�������ĸ���Ϊ�ڵ������ֵΪ��Ӧ�Ľڵ㣨λ�ã�
        else           
            filter_result(filter_result>(face_gauss_filtered_min_Rvalue))=0;
            [final_index,column3]=find(filter_result>0);%ȡ����ֵ�������ĸ���Ϊ�ڵ������ֵΪ��Ӧ�Ľڵ㣨λ�ã�
        end

        %����ͼ�����,ÿһ��ѡ�������㣬�ֱ���ʲô
        [final_index_num,column4]=size(final_index);%�����ҳ�ɸѡ��������
        size_select_node(1,(final_index_num+1))=size_select_node(1,(final_index_num+1))+1;%Ϊ�����յĽ�����
        fprintf(fid, '%s ',['ɸѡ���ڵ�ĸ�����',num2str(final_index_num)]); 
        fprintf(fid, '\n');  %100��ÿ��ɸѡ�����Ľ��
    % % % % % % %     disp(['ɸѡ���ڵ������',num2str(final_index_num)]);
        for g=1:1:final_index_num;
    % % % % % % %         disp(['�ڵ㣺',num2str(final_index(g,1))]);
            fprintf(fid, '%s ', ['�ڵ㣺',num2str(final_index(g,1))]); 
            fprintf(fid, '\n');
            if(final_index(g,1)==face_who)   %����ĸ��㣿
                succeed_count=succeed_count+1;
            end
        end
    else if(select_mode>1 & first_select_node_num==0) %Ϊ�˷�ֹ��һ��ɸѡһ����û���ҵ����������
            fprintf(fid, '%s ',['ɸѡ���ڵ�ĸ�����',num2str(0)]); 
            fprintf(fid, '\n');  %100��ÿ��ɸѡ�����Ľ��
            fprintf(fid, '%s ', ['�ڵ㣺',num2str(first_index)]);
            size_select_node(1,(first_select_node_num+1))=size_select_node(1,(first_select_node_num+1))+1;%Ϊ�����յĽ����� 
        end
    end
    
    
    %ʱ��ģ��
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
    else if (final_index_num<=1)  %2��ûѡ����Ҳû���ֶ�ѡ��ʱ��
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
    
%     %ÿһ��ɸѡ�����Ľڵ��������
    first_node_save(group,1)=first_select_node_num;
%     second_node_save(group,1)=final_index_num;
%     
end
%����ѭ����������������
disp(['�ɹ��ʣ�',num2str(succeed_count/(data_all/data_sample)*100)]);
fprintf(fid, '%s ', ['�ɹ��ʣ�',num2str(succeed_count/(data_all/data_sample)*100)]); 
fprintf(fid, '\n');
for n=1:1:10;
    if size_select_node(1,n)~=0;
        disp(['ɸѡ����',num2str(n-1),'���ڵ㣺',num2str(size_select_node(1,n))]);
        fprintf(fid, '%s ', ['ɸѡ����',num2str(n-1),'���ڵ㣺',num2str(size_select_node(1,n))]); 
        fprintf(fid, '\n');
    end
end

% % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% collecttime=sample_num;
% % F2F_mean_min=0-min_EWMA_threshold_F2F;      %dx12
% F2F_mean_min=0-min_average_threshold_F2F;
% % F2F_mean_min=face_first_value_min_Rvalue;
% run('E:\fuda\HMI\����\2222\FacetoFace_7node.m');
% fprintf(fid33, '%s ', [num2str(1),'--F2F�ɹ��ʣ�',num2str(succeed_count/(data_all/data_sample)*100)]); 
% fprintf(fid33, '\n');
% for n=1:1:10;
%     if size_select_node(1,n)~=0;
%         fprintf(fid33, '%s ', ['ɸѡ����',num2str(n-1),'���ڵ㣺',num2str(size_select_node(1,n))]); 
%         fprintf(fid33, '\n');
%     end
% end
meanr=[];
meanr=mean(r_initial);
% moder=[];
% moder=mode(r_initial)



