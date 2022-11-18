function delta_min=find_min_delta_fuction_version1(face,numfile,r_initial)%面对3号，
sum_deltaR=0;
delta_R=zeros();
section_deltaR=[];
% if size(r_initial,1) ==1
%     b=r_initial;
% else
%     b=sort(r_initial);
% end

% for i=1:numfile
%     eval(['sort',num2str(i),'=','b(:,i)',';']);
%   end

for n=1:numfile
    eval(['r',num2str(n),'=','r_initial(:,n)',';']);
end
 switch  numfile
     case 7
         sort1=sort(r1);
sort2=sort(r2);
sort3=sort(r3);
sort4=sort(r4);
sort5=sort(r5);
sort6=sort(r6);
sort7=sort(r7);
section1=[sort1(end,1);sort1(1,1)];%取最大和最小值
section2=[sort2(end,1);sort2(1,1)];
section3=[sort3(end,1);sort3(1,1)];
section4=[sort4(end,1);sort4(1,1)];
section5=[sort5(end,1);sort5(1,1)];
section6=[sort6(end,1);sort6(1,1)];
section7=[sort7(end,1);sort7(1,1)];
     case 6
         sort1=sort(r1);
sort2=sort(r2);
sort3=sort(r3);
sort4=sort(r4);
sort5=sort(r5);
sort6=sort(r6);

      section1=[sort1(end,1);sort1(1,1)];%取最大和最小值
    section2=[sort2(end,1);sort2(1,1)];
    section3=[sort3(end,1);sort3(1,1)];
    section4=[sort4(end,1);sort4(1,1)];
    section5=[sort5(end,1);sort5(1,1)];
    section6=[sort6(end,1);sort6(1,1)];
     case 5
         sort1=sort(r1);
sort2=sort(r2);
sort3=sort(r3);
sort4=sort(r4);
sort5=sort(r5);

     section1=[sort1(end,1);sort1(1,1)];%取最大和最小值
    section2=[sort2(end,1);sort2(1,1)];
    section3=[sort3(end,1);sort3(1,1)];
    section4=[sort4(end,1);sort4(1,1)];
    section5=[sort5(end,1);sort5(1,1)];    
     case 4
         sort1=sort(r1);
         sort2=sort(r2);
        sort3=sort(r3);
        sort4=sort(r4);

      section1=[sort1(end,1);sort1(1,1)];%取最大和最小值
      section2=[sort2(end,1);sort2(1,1)];
      section3=[sort3(end,1);sort3(1,1)];
      section4=[sort4(end,1);sort4(1,1)];
     case 3
         sort1=sort(r1);
         sort2=sort(r2);
         sort3=sort(r3);

         section1=[sort1(end,1);sort1(1,1)];%取最大和最小值
         section2=[sort2(end,1);sort2(1,1)];
         section3=[sort3(end,1);sort3(1,1)];
     case 2
         sort1=sort(r1);
         sort2=sort(r2);

          section1=[sort1(end,1);sort1(1,1)];%取最大和最小值
    section2=[sort2(end,1);sort2(1,1)];
 end
switch face
    case 1
        section1=flipud(section1);%按行翻转（上下倒过来）
        k_section=section1;
    case 2
        section2=flipud(section2);
        k_section=section2;
    case 3
        section3=flipud(section3);
        k_section=section3;
    case 4
        section4=flipud(section4);
        k_section=section4;
    case 5
        section5=flipud(section5);
        k_section=section5;
    case 6
        section6=flipud(section6);
        k_section=section6;
    otherwise
        section7=flipud(section7);
        k_section=section7;
end

for i=1:numfile%循环5次，本身算一次，求平均的时候除以4，因为算法不好写
    delta_R=k_section-eval(['section',num2str(i)]);
    section_deltaR=[section_deltaR;delta_R(1,1)];%此时面对的section已经颠倒
end
section_deltaR(section_deltaR==0)=[];%把本身给清掉
Sort=sort(section_deltaR);
delta_min=Sort(1,1);  %如果有负数，怎么滴也比0小，先去0没毛病
if (delta_min>0) & (size(section_deltaR)<(numfile-1))
    delta_min=0;
end
% Sort=sort(section_deltaR);
% delta_min=Sort(2,1);
% sum_deltaR=0;




