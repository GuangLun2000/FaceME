function save_multiparameter_txt_function(index,m,fid,para1,para2,para3,para4,para5,para6,para7,para8,para9,para10,para11,para12)
    fprintf(fid, '\n');
    fprintf(fid, '%s ', ['��ͬdxdy��',num2str(index),'��ͬm��',num2str(m)]); 
    fprintf(fid, '\n');
    fprintf(fid, '%s ', ['deltaR1��',num2str(para1)]); 
    fprintf(fid, '\n');
    fprintf(fid, '%s ', ['deltaR2��',num2str(para2)]); 
    fprintf(fid, '\n');
    fprintf(fid, '%s ', ['������һ��ֵ��С|Rvalue|��1���½磺',num2str(para3)]); 
    fprintf(fid, '\n');
    fprintf(fid, '%s ', ['������˲�����С|Rvalue|��2���½磺',num2str(para4)]); 
    fprintf(fid, '\n');
    fprintf(fid, '%s ', ['��������������һ��ֵ���|Rvalue|��1���Ͻ磺',num2str(para5)]); 
    fprintf(fid, '\n');
    fprintf(fid, '%s ', ['��������������˲������|Rvalue|��2���Ͻ磺',num2str(para6)]); 
    fprintf(fid, '\n');
    fprintf(fid, '%s ', ['��ֵ�˲���ֵ��ƽ��',num2str(para7)]); 
    fprintf(fid, '\n');
    fprintf(fid, '%s ', ['��ֵ�˲���ֵ����С',num2str(para8)]); 
    fprintf(fid, '\n');
    fprintf(fid, '%s ', ['EWMA�˲���ֵ��ƽ��',num2str(para9)]); 
    fprintf(fid, '\n');
    fprintf(fid, '%s ', ['EWMA�˲���ֵ����С',num2str(para10)]); 
    fprintf(fid, '\n');
    fprintf(fid, '%s ', ['ԭʼ���������������Сֵ|Rvalue|��12���½磺',num2str(para11)]); 
    fprintf(fid, '\n');
    fprintf(fid, '%s ', ['ԭʼ�������ݳ�������������|Rvalue|��12���Ͻ磺',num2str(para12)]); 
    fprintf(fid, '\n');
end


