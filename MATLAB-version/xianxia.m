%��0�ͳ�ʼ��ֵ����Ҫ��
right_shift=[];
left_shift=[];
right_shift1=[];
left_shift1=[];
relative_Rmax_Rface=[];
relative_Rmax_Rface1=[];

%��������岻�������е���������deltaR1
delta_1(1,1)=find_min_delta_fuction_version1(face_who,numfile,r_initial); 
alldata_othernode=r_initial;
alldata_othernode(:,face_who)=[];   
alldata_othernode_upperbound=0-max(max(alldata_othernode));
alldata_facenode_lowerbound=0-min(r_initial(:,face_who));
disp(['ԭʼ���������������Сֵ|Rvalue|��12���½磺',num2str(alldata_facenode_lowerbound)]);
disp(['ԭʼ�������ݳ�������������|Rvalue|��12���Ͻ磺',num2str(alldata_othernode_upperbound)]);

%Gaussianȥ������ֵ,ÿ��ȥ�����ٲ�ȷ����ά�Ȳ�һ��,û�пɱ��ԣ�����ͬһ��ʱ��βɼ���     
%�ɼ�ʱ��30��һ�飬����Ҫ����+ȡ��ÿ���һ�����Ͳ�����sample+�ϲ��ɴ����䣬����deltaR
for j=1:1:(num_all/everygroup_num);
    %ȡ��ÿ���һ����+ÿ���ǰsample������Ҫ��Ҫȥ����һ��������������������������
    %���ȥ����һ������sample_num���29����ôF2F��û������m=30��
    for i3=1:numfile
        r_firstvalue_grouped(j,i3)=r_initial((1+(j-1)*everygroup_num),i3);
        r_samplenum_grouped((1+(j-1)*sample_num):(j*sample_num),i3)= ...
            r_initial((2+(j-1)*everygroup_num):(sample_num+1+(j-1)*everygroup_num),i3);
        %��˹�˲���һ����,������˵��˹�Ѿ���������?
%         r_Gauss_grouped(j,i3)=mean(gaosi_function ...
%             (r_samplenum_grouped((1+(j-1)*sample_num):(j*sample_num),i3),sample_num));
          r_Gauss_grouped(j,i3)=mean( ...
            r_samplenum_grouped((1+(j-1)*sample_num):(j*sample_num),i3));
    end      

    %�ȷ��飬ֱ�Ӷ������node����ֵ��ֵ�˲�������F2F����ֵshreshold
%     F2F_mean_grouped(j,1)=mean(r_initial((1+(j-1)*everygroup_num):(j*everygroup_num),face_who));
    F2F_mean_grouped(j,1)=mean(r_initial((1+(j-1)*everygroup_num):(sample_num+(j-1)*everygroup_num),face_who));
    
    %�ȷ��飬ֱ�Ӷ������nodeÿ��sample��ֵEWMA�˲�     
    for m=1:1:sample_num
        if m==1
            E = r_samplenum_grouped((m+(j-1)*sample_num),face_who);
        else
            E = r_samplenum_grouped((m+(j-1)*sample_num),face_who)*0.5+E*0.5;
        end
    end
    F2F_EWMA_grouped(j,1)=E;

    %ÿһ��ȡ��һ�������˲�֮��ֱ����һ��deltaR��������������
    %deltaR_everygroup�ĵ�һ����ÿһ�������deltaR1���ڶ�����ÿһ���������deltaR2
    deltaR_everygroup(j,1)=find_min_delta_fuction_version1(face_who,numfile,r_firstvalue_grouped); 
    deltaR_everygroup(j,2)=find_min_delta_fuction_version1(face_who,numfile,r_Gauss_grouped); 
    
    %��¼ÿ��ʵ����Rmax��λ��,ע�����ߺ�����Rmax��ͬ�������Ǵ�Rmax��ʼ�ж�
%     both_leftright_flag=0; %Ϊ�����ѣ����ߵ�ʱ��Ҫ��Rmaxλ�õ����߶��ƶ�������ڵ�
%     Rmax=max(r_Gauss_grouped(j,:));
%     [r1,Rmax_index_gaussed]=find(r_Gauss_grouped(j,:)==Rmax);  %index�����ܳ����ظ���
%     relative_Rmax_Rface=[];
    Rmax=max(r_firstvalue_grouped(j,:));
    [r1,Rmax_index_gaussed]=find(r_firstvalue_grouped(j,:)==Rmax);  %index�����ܳ����ظ���
    [~,Rmax_num]=size(Rmax_index_gaussed);
    if(Rmax_num==1)     %ֻ��һ��RSSI���ֵ
%         loc_Rmax_notRepeat(j,1)=Rmax_index_gaussed;  %���ظ���Rmax�����¼�ڴ�����
%         relative_Rmax_Rface(j,1)=loc_Rmax_notRepeat(j,1)-face_who;%���Ҹ���
        relative_Rmax_Rface=[relative_Rmax_Rface;(Rmax_index_gaussed-face_who)];
    else    %���ظ���RSSI���ֵ���ҵ��������Զֵ���������Ҫ����
        for ii5=1:1:Rmax_num;
%             multiple_relative_Rmax_Rface(i5,1)=Rmax_index_gaussed(1,i5)-face_who;
            relative_Rmax_Rface=[relative_Rmax_Rface;(Rmax_index_gaussed(1,ii5)-face_who)];
        end
%         [max_index,~]=find(abs(multiple_relative_Rmax_Rface)==max(abs(multiple_relative_Rmax_Rface)));
%         [size_max_index,~]=size(max_index);
%         if(size_max_index>1)  %������������,��λ�ò������и�����С������ȣ����ܲ����
%             relative_Rmax_Rface(j,1)=multiple_relative_Rmax_Rface(max_index(1,1),1);%��������ֵ���������ֵ����ȣ�������������ֵ�������������ʱ���Ҷ�Ҫ�ƶ�
% %             both_leftright_flag=1; %ע��ʲôʱ����0
%         else
%             relative_Rmax_Rface(j,1)=multiple_relative_Rmax_Rface(max_index,1);%���Ҹ���,�ҵ�������Զ��Rmax���ƶ���Ϣ��������
%         end        
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%
    %Ϊ�˵ڶ��ֵ�ɸѡ��λ�ò�
    %��¼���е�Rmax��������λ�ò����group����������Ϊÿ��ʵ������ж��Rmax
    %%%%%%%%%%%%%%%%%%%%%%%%%
%     both_leftright_flag=0; %Ϊ�����ѣ����ߵ�ʱ��Ҫ��Rmaxλ�õ����߶��ƶ�������ڵ�
    Rmax1=max(r_Gauss_grouped(j,:));
    [~,Rmax_index_gaussed1]=find(r_Gauss_grouped(j,:)==Rmax1);  %index�����ܳ����ظ���
%     Rmax=max(r_firstvalue_grouped(j,:));
%     [r1,Rmax_index_gaussed]=find(r_firstvalue_grouped(j,:)==Rmax);  %index�����ܳ����ظ���
    [~,Rmax_num1]=size(Rmax_index_gaussed1);
    if(Rmax_num1==1)     %ֻ��һ��RSSI���ֵ
%         loc_Rmax_notRepeat1(j,1)=Rmax_index_gaussed1;  %���ظ���Rmax�����¼�ڴ�����
%         relative_Rmax_Rface1(j,1)=loc_Rmax_notRepeat1(j,1)-face_who;%���Ҹ���
        relative_Rmax_Rface1=[relative_Rmax_Rface1;(Rmax_index_gaussed1-face_who)];
    else    %���ظ���RSSI���ֵ���ҵ��������Զֵ���������Ҫ����
        for i5=1:1:Rmax_num1;
%             multiple_relative_Rmax_Rface1(i5,1)=Rmax_index_gaussed1(1,i5)-face_who;
            relative_Rmax_Rface1=[relative_Rmax_Rface1;(Rmax_index_gaussed1(1,i5)-face_who)];
        end
%         [max_index1,~]=find(abs(multiple_relative_Rmax_Rface1)==max(abs(multiple_relative_Rmax_Rface1)));
%         [size_max_index1,~]=size(max_index1);
%         if(size_max_index1>1)  %������������,��λ�ò������и�����С������ȣ����ܲ����
%             relative_Rmax_Rface1(j,1)=multiple_relative_Rmax_Rface1(max_index1(1,1),1);%��������ֵ���������ֵ����ȣ�������������ֵ�������������ʱ���Ҷ�Ҫ�ƶ�
% %             both_leftright_flag=1; %ע��ʲôʱ����0
%         else
%             relative_Rmax_Rface1(j,1)=multiple_relative_Rmax_Rface1(max_index1,1);%���Ҹ���,�ҵ�������Զ��Rmax���ƶ���Ϣ��������
%         end        
    end
    
end

%����Աȣ��ֺ���֮��ÿ��ĵ�һ������sample��������µ����䣬����Щ��������deltaR1��deltaR2
%����Աȴ����⣺���ܱ�֤��deltaR����������½���ͬʱ��
delta_1_grouped(1,1)=find_min_delta_fuction_version1(face_who,numfile,r_firstvalue_grouped); 
delta_2_gauss_grouped(1,1)=find_min_delta_fuction_version1(face_who,numfile,r_Gauss_grouped); 
%������Ա�
delta_1_min=min(deltaR_everygroup(:,1));
delta_2_min=min(deltaR_everygroup(:,2));
face_gauss_filtered_min_Rvalue=0-min(r_Gauss_grouped(:,face_who)); %lmk,m���˲���Ŀ�����2ɸ�˲�����������Сֵ
face_first_value_min_Rvalue=0-min(r_firstvalue_grouped(:,face_who));%l1k,��һ��Ŀ�������1ɸÿ���һ��������Сֵ
NearbyNode_r_Gauss_grouped=r_Gauss_grouped;
NearbyNode_r_Gauss_grouped(:,face_who)=[];%ȥ���������˲�������ݣ�M-)
Notface_gauss_filtered_max_Rvalue=0-max(max(NearbyNode_r_Gauss_grouped));
NearbyNode_r_firstvalue_grouped=r_firstvalue_grouped;
NearbyNode_r_firstvalue_grouped(:,face_who)=[];%ȥ��������ÿ���һ����������(M-)
Notface_first_value_max_Rvalue= 0-max(max(NearbyNode_r_firstvalue_grouped));

disp(['deltaR1��',num2str(delta_1_min)]);
disp(['deltaR2��',num2str(delta_2_min)]);
disp(['������һ��ֵ��С|Rvalue|��1���½磺',num2str(face_first_value_min_Rvalue)]);
disp(['������˲�����С|Rvalue|��2���½磺',num2str(face_gauss_filtered_min_Rvalue)]);
disp(['��������������һ��ֵ���|Rvalue|��1���Ͻ磺',num2str(Notface_first_value_max_Rvalue)]);
disp(['��������������˲������|Rvalue|��2���Ͻ磺',num2str(Notface_gauss_filtered_max_Rvalue)]);

%���Rmaxλ�ú�Rface����Թ�ϵ
left_shift_max=max(relative_Rmax_Rface(find(relative_Rmax_Rface>=0)));
right_shift_max=0-min(relative_Rmax_Rface(find(relative_Rmax_Rface<0)));
if(isempty(left_shift_max)) %�ж��Ƿ�Ϊ�գ���Ϊ1
    left_shift_max=0;
end
if(isempty(right_shift_max))
    right_shift_max=0;
end
shift_max=max(left_shift_max,right_shift_max);
%���������������Rmax�����ƶ�0��Ҳ��Ҫ��¼
[left_shift(:,1),~]=size(find(relative_Rmax_Rface==0));
[right_shift(:,1),~]=size(find(relative_Rmax_Rface==0));%ÿ�д����Rmax����j1��λ�õ�����ж��ٸ�
disp(['��Rmaxλ���ƶ�0��λ����',num2str(right_shift(:,1)),'������']);
for j1=1:1:shift_max; %���������������Ϊ�˱��ڲ鿴����
    [left_shift(:,(j1+1)),c3]=size(find(relative_Rmax_Rface==j1));%ÿ�д����Rmax����j1��λ�õ�����ж��ٸ�
    [right_shift(:,(j1+1)),c4]=size(find(relative_Rmax_Rface==(-j1)));%ÿ�д����Rmax����j1��λ�õ�����ж��ٸ�
    disp(['��Rmaxλ������',num2str(j1),'��λ����',num2str(left_shift(:,(j1+1))),'������']);
    disp(['��Rmaxλ������',num2str(j1),'��λ����',num2str(right_shift(:,(j1+1))),'������']);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   ���Rmaxλ�ú�Rface����Թ�ϵ
%   �ڶ���ֱ��λ�ò���׼��
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
left_shift_max1=max(relative_Rmax_Rface1(find(relative_Rmax_Rface1>=0)));
right_shift_max1=0-min(relative_Rmax_Rface1(find(relative_Rmax_Rface1<0)));
if(isempty(left_shift_max1))
    left_shift_max1=0;
end
if(isempty(right_shift_max1))
    right_shift_max1=0;
end
shift_max1=max(left_shift_max1,right_shift_max1); %������0��������������㣬��������ѭ��
%���������������Rmax�����ƶ�0��Ҳ��Ҫ��¼
[left_shift1(:,1),~]=size(find(relative_Rmax_Rface1==0));
[right_shift1(:,1),~]=size(find(relative_Rmax_Rface1==0));%ÿ�д����Rmax����j1��λ�õ�����ж��ٸ�
disp(['��Rmaxλ���ƶ�0��λ����',num2str(right_shift1(:,1)),'������']);
for j1=1:1:shift_max1; %���������������Ϊ�˱��ڲ鿴����
    [left_shift1(:,(j1+1)),c3]=size(find(relative_Rmax_Rface1==j1));%ÿ�д����Rmax����j1��λ�õ�����ж��ٸ�
    [right_shift1(:,(j1+1)),c4]=size(find(relative_Rmax_Rface1==(-j1)));%ÿ�д����Rmax����j1��λ�õ�����ж��ٸ�
    disp(['��Rmaxλ������',num2str(j1),'��λ����',num2str(left_shift1(:,(j1+1))),'������']);
    disp(['��Rmaxλ������',num2str(j1),'��λ����',num2str(right_shift1(:,(j1+1))),'������']);
end

% % ��ͼ
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
%     ['7 ',num2str(mean(r_initial(:,7))),' Std: ',num2str(std(r_initial(:,7),0,1))]);%ע��
% xlabel(['ԭʼ����',' ����������',num2str(sample_num)]);
% subplot(2,2,2);
% plot_function(r_firstvalue_grouped(:,1),r_firstvalue_grouped(:,2),r_firstvalue_grouped(:,3), ...
%     r_firstvalue_grouped(:,4),r_firstvalue_grouped(:,5),r_firstvalue_grouped(:,6),r_firstvalue_grouped(:,7));
% legend(['max: ',num2str(max(r_firstvalue_grouped(:,1))),' min: ',num2str(min(r_firstvalue_grouped(:,1)))], ...
%     ['max: ',num2str(max(r_firstvalue_grouped(:,2))),' min: ',num2str(min(r_firstvalue_grouped(:,2)))], ...
%     ['max: ',num2str(max(r_firstvalue_grouped(:,3))),' min: ',num2str(min(r_firstvalue_grouped(:,3)))], ...
%     ['max: ',num2str(max(r_firstvalue_grouped(:,4))),' min: ',num2str(min(r_firstvalue_grouped(:,4)))], ...
%     ['max: ',num2str(max(r_firstvalue_grouped(:,5))),' min: ',num2str(min(r_firstvalue_grouped(:,5)))], ...
%     ['max: ',num2str(max(r_firstvalue_grouped(:,6))),' min: ',num2str(min(r_firstvalue_grouped(:,6)))], ...
%     ['max: ',num2str(max(r_firstvalue_grouped(:,7))),' min: ',num2str(min(r_firstvalue_grouped(:,7)))]);%ע��
% xlabel(['ÿһ��ĵ�һ����',' ����������',num2str(sample_num)]);
% subplot(2,2,3);
% plot_function(r_Gauss_grouped(:,1),r_Gauss_grouped(:,2),r_Gauss_grouped(:,3), ...
%     r_Gauss_grouped(:,4),r_Gauss_grouped(:,5),r_Gauss_grouped(:,6),r_Gauss_grouped(:,7));
% legend(['max: ',num2str(max(r_Gauss_grouped(:,1))),' min: ',num2str(min(r_Gauss_grouped(:,1)))], ...
%     ['max: ',num2str(max(r_Gauss_grouped(:,2))),' min: ',num2str(min(r_Gauss_grouped(:,2)))], ...
%     ['max: ',num2str(max(r_Gauss_grouped(:,3))),' min: ',num2str(min(r_Gauss_grouped(:,3)))], ...
%     ['max: ',num2str(max(r_Gauss_grouped(:,4))),' min: ',num2str(min(r_Gauss_grouped(:,4)))], ...
%     ['max: ',num2str(max(r_Gauss_grouped(:,5))),' min: ',num2str(min(r_Gauss_grouped(:,5)))], ...
%     ['max: ',num2str(max(r_Gauss_grouped(:,6))),' min: ',num2str(min(r_Gauss_grouped(:,6)))], ...
%     ['max: ',num2str(max(r_Gauss_grouped(:,7))),' min: ',num2str(min(r_Gauss_grouped(:,7)))]);%ע��
% xlabel(['ÿһ���ǰm������˹�˲�֮��',' ����������',num2str(sample_num)]);
% subplot(2,2,4);
% plot(deltaR_everygroup(:,1),'ro-','linewidth',2);
% hold on;
% plot(deltaR_everygroup(:,2),'gd-','linewidth',2);
% hold on;
% legend(['deltaR1: mean: ',num2str(mean(deltaR_everygroup(:,1))),' min: ',num2str(min(deltaR_everygroup(:,1)))], ...
%     ['deltaR2: mean: ',num2str(mean(deltaR_everygroup(:,2))),' min: ',num2str(min(deltaR_everygroup(:,2)))]);%ע��
% xlabel('������Աȣ�һ����һ��deltaR����������');
% 
min_average_threshold_F2F=min(F2F_mean_grouped);
mean_average_F2F=mean(F2F_mean_grouped);
min_EWMA_threshold_F2F=min(F2F_EWMA_grouped);
mean_EWMA_F2F=mean(F2F_EWMA_grouped);
disp(['��ֵ�˲���ֵ��ƽ��',num2str(mean_average_F2F)]);
disp(['��ֵ�˲���ֵ����С',num2str(min_average_threshold_F2F)]);
disp(['EWMA�˲���ֵ��ƽ��',num2str(mean_EWMA_F2F)]);
disp(['EWMA�˲���ֵ����С',num2str(min_EWMA_threshold_F2F)]);
