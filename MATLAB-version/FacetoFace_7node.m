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
% % % % % % % data_sample=30;     %����֮���ÿ�����
% % % % % % % BLE_num=7;
% % % % % % % collecttime=7;   %ѡȡ����������
% % % % % % % facewho=4;
% % % % % % % F2F_mean_min=51;      %dx12
%fid=fopen('F2F_final_result.txt', 'wt');
%ÿһ�λ�dxdy��ʱ����0
succeed_count=0;
size_select_node=[0,0,0,0,0,0,0,0,0,0]; %��һ��ֵ������ɸѡ����0���ڵ�ĸ������Դ�����
Consume_time_manu1=0;%�е��ӣ�Ҫ��0

% % % % % % % %ѭ�������ļ�+ע��ά��Ҫһ��
% % % % % % % filepath='G:\���ٿ�\TII��Ͷ-N6-������ʵ��\4-7�����ز�-�ɰڷ�node4321758-�����볡��\12.18\';%�ļ��е�·��
% % % % % % % % filepath='C:\Users\Administrator\Documents\MATLAB\�˲��㷨\N6_data\dx12\dy18\';%�ļ��е�·��
% % % % % % % % filepath='C:\Users\Administrator\Documents\MATLAB\�˲��㷨\N6_data\dx12\�����ƶ�-dx12dy12\7��4������45cm\';%�ļ��е�·��
% % % % % % % % filepath='C:\Users\Administrator\Documents\MATLAB\�˲��㷨\N6_data\dx12\�����ƶ�-dx12dy12\7��4������45cm\';%�ļ��е�·��
% % % % % % % for i1=1:7  %n��Ҫ������ļ��ĸ���
% % % % % % %    data=load([filepath,'RSSI',num2str(i1),'.txt']);
% % % % % % %    r_initial(:,i1)=data(start:last,1);           %%%%ͳһ��ʽ��һ��node����1��
% % % % % % % end

% group=45;
for group=1:1:(data_all/data_sample);
    %ÿ����һ�Σ���Щֵ�����0
    first_initial=[];
    E=[];
    
    %��ȡ��������Ҫ�����ݸ���(����ÿ��20��������ѭ������),ÿ�λ��鶼�Ḳ������+ȡ��ÿ��ĵ�һ����
    for i1=1:numfile
        r_everytime(:,i1)=r_initial((1+(group-1)*data_sample):(group*data_sample),i1);
        first_initial(:,i1)=r_everytime(1:collecttime,i1);
    end
    
    %EWMA�˲�
    for j=1:1:numfile;  %�м����ڵ���˼��β�        
%         for m=1:1:collecttime
%             if m==1
%                 E(j,1)=0-first_initial(m,j);
%             else
%                 E(j,1) = (0-first_initial(m,j))*0.5+E(j,1)*0.5;
%             end
%         end
        E(j,1)=0-mean(first_initial(:,j));
    end
  
           
    %��ʼF2Fɸѡ
    E(E>F2F_mean_min)=0;
    
    [final_index,column]=find(E>0);%ȡ����ֵ�������ĸ���Ϊ�ڵ������ֵΪ��Ӧ�Ľڵ㣨λ�ã�

    %����ͼ����� 
    [final_index_num,column4]=size(final_index);%�����ҳ�ɸѡ��������
    size_select_node(1,(final_index_num+1))=size_select_node(1,(final_index_num+1))+1;%Ϊ�����յĽ�����
    fprintf(fid, '%s ',['ɸѡ���ڵ�ĸ�����',num2str(final_index_num)]); 
    fprintf(fid, '\n');
% % % % % % %     disp(['ɸѡ���ڵ������',num2str(final_index_num)]);
    for g=1:1:final_index_num;
% % % % % % %         disp(['�ڵ㣺',num2str(final_index(g,1))]);
        fprintf(fid, '%s ', ['�ڵ㣺',num2str(final_index(g,1))]); 
        fprintf(fid, '\n');
        if(final_index(g,1)==face_who)
            succeed_count=succeed_count+1;
        end
    end
    
    %�ֶ�ѡ���ʱ��   
    if (final_index_num<=1)  %2��ûѡ����Ҳû���ֶ�ѡ��ʱ��
        manu_time1=0;
    else
%         manu_time1=(970.12+76.88*final_index_num)*2;
        manu_time1=1491.5+247.6*final_index_num;
    end
    Consume_time_manu1=Consume_time_manu1+manu_time1;
    
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

% figure(3);
% plot_function(r_initial(:,1),r_initial(:,2),r_initial(:,3),r_initial(:,4), ...
%     r_initial(:,5),r_initial(:,6),r_initial(:,7));
% legend(['1 ',num2str(mean(r_initial(:,1))),' Std: ',num2str(std(r_initial(:,1),0,1))], ...
%     ['2 ',num2str(mean(r_initial(:,2))),' Std: ',num2str(std(r_initial(:,2),0,1))], ...
%     ['3 ',num2str(mean(r_initial(:,3))),' Std: ',num2str(std(r_initial(:,3),0,1))], ...
%     ['4 ',num2str(mean(r_initial(:,4))),' Std: ',num2str(std(r_initial(:,4),0,1))], ...
%     ['5 ',num2str(mean(r_initial(:,5))),' Std: ',num2str(std(r_initial(:,5),0,1))], ...
%     ['6 ',num2str(mean(r_initial(:,6))),' Std: ',num2str(std(r_initial(:,6),0,1))], ...
%     ['7 ',num2str(mean(r_initial(:,7))),' Std: ',num2str(std(r_initial(:,7),0,1))]);%ע��