function plot_function(a,b,c,d,e,f,g)
asize=size(a);
aN=asize(1,1);
bsize=size(b);
bN=bsize(1,1);
csize=size(c);
cN=csize(1,1);
dsize=size(d);
dN=dsize(1,1);
esize=size(e);
eN=esize(1,1);
fsize=size(f);
fN=fsize(1,1);
gsize=size(g);
gN=gsize(1,1);

at=1:aN;
bt=1:bN;
ct=1:cN;
dt=1:dN;
et=1:eN;
ft=1:fN;
gt=1:gN;

plot(at,a,'ks-','markersize',3);
hold on;
plot(bt,b,'ms-','markersize',3);    
hold on;
plot(ct,c,'bs-','markersize',3);        
hold on;
plot(dt,d,'rs-','markersize',3);
hold on;
plot(et,e,'gs-','markersize',3);
hold on;
plot(ft,f,'cs-','markersize',3);
hold on;
plot(gt,g,'ys-','markersize',3);
hold on;

% legend('1','2','3','4','5');%ע��
xlabel('Time(s)');
ylabel('RSSI(dBm)');
% set (gca,'position',[0.1,0.1,0.9,0.9]);%����ͼ�Ĵ�С��ҳ�߾�֮���
set(gca,'xaxislocation','top');% x���Ϸ���ʾ
% set(gca,'XLim',[0 3000]);%X���������ʾ��Χ
% set(gca,'XTick',[0:300:3000]);%����Ҫ��ʾ����̶�
% set(gca,'XTickLabel',[0:0.1:1.5]);%������ӱ�ǩ 
set(gca,'YLim',[-90 -40]);%X���������ʾ��Χ
set(gca,'YTick',[-90:5:-40]);%����Ҫ��ʾ����̶�
% set(gca,'YTickLabel',[0:0.1:1.5]);%������ӱ�ǩ 



