function gaosi = gaosi_function(r,caiji_num)%1000点分组，每组一次高斯求平均
gaosi=zeros();
% caiji_num=20;%采集20个数据为一组
rsize=size(r);
% N=rsize(1,1)/caiji_num;%组数
N=50;%计算deltaR，用这行！！！


% for i=1:N;    %计算deltaR不用再在这里循环！！！
%     duilie = r((1+caiji_num*(i-1)):(i*caiji_num),1);
%     duilie = group_function(r,i,caiji_num,0);%随机
%     duilie = group_function(r,i,caiji_num,1);%顺序
    duilie=r;%此时是在计算deltaR所以用这行！！！
    duilie_no_dele=duilie;
    averg=mean(duilie);
    Std=std(duilie,0,1);%求标准差
    for j=1:caiji_num
        if duilie(j,1)<(averg-Std)
            duilie_no_dele(duilie_no_dele==duilie(j,1))=[];
        else if duilie(j,1)>(averg+Std)
                duilie_no_dele(duilie_no_dele==duilie(j,1))=[];
             end
        end
    end
%     gaosi(i,1)=mean(duilie_no_dele);
    gaosi=duilie_no_dele;%此时是在计算deltaR所以用这行！！！
    
% end


% function [gaosi,Std_filter] = gaosi_function(r,average,Std)
% gaosi=zeros();
% delete_num=0;
% rsize=size(r);
% N=rsize(1,1);
% for i=1:N;
%     if r(i,1)<(average-Std)
%         delete_num = delete_num+1;
%     else if r(i,1)>(average+Std)
%             delete_num = delete_num+1;
%          else
%             gaosi_num=i-delete_num;
%             gaosi(gaosi_num,1)=r(i,1);
%          end
%     end
% end
% Std_filter=std(gaosi,0,1);