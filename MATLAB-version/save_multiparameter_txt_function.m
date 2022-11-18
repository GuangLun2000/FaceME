function save_multiparameter_txt_function(index,m,fid,para1,para2,para3,para4,para5,para6,para7,para8,para9,para10,para11,para12)
    fprintf(fid, '\n');
    fprintf(fid, '%s ', ['不同dxdy：',num2str(index),'不同m：',num2str(m)]); 
    fprintf(fid, '\n');
    fprintf(fid, '%s ', ['deltaR1：',num2str(para1)]); 
    fprintf(fid, '\n');
    fprintf(fid, '%s ', ['deltaR2：',num2str(para2)]); 
    fprintf(fid, '\n');
    fprintf(fid, '%s ', ['最近点第一个值最小|Rvalue|，1轮下界：',num2str(para3)]); 
    fprintf(fid, '\n');
    fprintf(fid, '%s ', ['最近点滤波后最小|Rvalue|，2轮下界：',num2str(para4)]); 
    fprintf(fid, '\n');
    fprintf(fid, '%s ', ['除最近点其他点第一个值最大|Rvalue|，1轮上界：',num2str(para5)]); 
    fprintf(fid, '\n');
    fprintf(fid, '%s ', ['除最近点其他点滤波后最大|Rvalue|，2轮上界：',num2str(para6)]); 
    fprintf(fid, '\n');
    fprintf(fid, '%s ', ['均值滤波阈值：平均',num2str(para7)]); 
    fprintf(fid, '\n');
    fprintf(fid, '%s ', ['均值滤波阈值：最小',num2str(para8)]); 
    fprintf(fid, '\n');
    fprintf(fid, '%s ', ['EWMA滤波阈值：平均',num2str(para9)]); 
    fprintf(fid, '\n');
    fprintf(fid, '%s ', ['EWMA滤波阈值：最小',num2str(para10)]); 
    fprintf(fid, '\n');
    fprintf(fid, '%s ', ['原始整体数据最近点最小值|Rvalue|，12轮下界：',num2str(para11)]); 
    fprintf(fid, '\n');
    fprintf(fid, '%s ', ['原始整体数据除最近其他点最大|Rvalue|，12轮上界：',num2str(para12)]); 
    fprintf(fid, '\n');
end


