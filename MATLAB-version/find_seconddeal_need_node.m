function second_initial=find_seconddeal_need_node(index,collecttime,r_evertime)
switch index
    case 1
        second_initial=r_evertime(2:(collecttime+1),1);
    case 2
        second_initial=r_evertime(2:(collecttime+1),2);
    case 3
        second_initial=r_evertime(2:(collecttime+1),3);
    case 4
        second_initial=r_evertime(2:(collecttime+1),4);
    case 5
        second_initial=r_evertime(2:(collecttime+1),5);
    case 6
        second_initial=r_evertime(2:(collecttime+1),6);
    case 7
        second_initial=r_evertime(2:(collecttime+1),7);
%     otherwise
%         disp('输入的不是1 2 3 4')
end 