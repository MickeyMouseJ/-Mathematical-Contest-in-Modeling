clear,clc
 q=5;%类型
 hs=16;%海深 16 或 20m
 mm1=3880;%重物球
 lts=121;%链条数%%%%依次增加
 v=36;%风速
 vs=1.5;%水速

[hc,phy2,R]=f3(q,hs,mm1,lts,v,vs)
function [ fuli ro ] = ffuli(g,h )
ro=1025;
r=1;
vpai=pi*r*r*h;
fuli=ro*g*vpai;
end
function [hc,phy2,R] = f3(q,hs,mm1,lts,v,vs)
zhunzhongli1=[];
zl=[];
cd=[0.078 0.105 0.12 0.15 0.18];%锚链长度
zl1=[3.2,7,12.5,19.5,28.12];%锚链单位长度质量
m=[1000 10 10 10 10 100];
for j=1:lts
 m1=zl1(q).*cd(q);
 m=[m,m1];
end
l=[1,1,1,1,1];
for jj=1:lts
 l=[l,cd(q)];
end
g=9.80665;
for i=1:length(m)
 if i==1
 zhunzhongli=m(i)*g;
 zhunzhongli1=[zhunzhongli1,zhunzhongli];
 elseif i<=5&&i>=2
 v1=0.025^2*pi*1;%钢管体积
 zhunzhongli=-1025*g*v1+m(i)*g;%重力加速度 g=9.80665
 zhunzhongli1=[zhunzhongli1,zhunzhongli];
 elseif i==6
 v2=0.15^2*pi*1;
 zhunzhongli=-1025*g*v2+m(i)*g;
 zhunzhongli1=[zhunzhongli1,zhunzhongli];
 elseif i>=7
 zl=zl1(q).*cd(q);
 v3=zl./7850;
 zhunzhongli=-1025*g*v3+m(i)*g;
 zhunzhongli1=[zhunzhongli1,zhunzhongli];
 end
end
k=1;
phy1={};
wz=[];
aa2={};
fx=[];
fy=[];
h2=[];
flll={};
fyy=[];
h3=[0.3:0.001:2];
for h=h3
 phy=zeros(1,lts+5);
 fyy=[];
 h1=[];
 fuli=ffuli(g,h);
 fengli=ffengli(v,h);%v 指风速
 %%%%%%
 %力和杆的角度递推
 fx(1)=fengli+374*2*h*vs*vs;%%%%vs 指水速
 fy(1)=fuli-zhunzhongli1(1);
 phy(1)=atan(((2*fy(1))-zhunzhongli1(2))/fx(1)/2);
 for j=2:lts+5
 if j<=5
 fy(j)=fy(j-1)-zhunzhongli1(j); %准重力的编号从浮标开始为 1
 fx(j)=fx(j-1)+374*vs*vs*sin(phy(j-1))*0.05*1;
 phy(j)=atan(((2*fy(j-1))-zhunzhongli1(j))/(fx(j-1)*2));
 elseif j==6
 vz=mm1/7850;
 fll=-1025*vz*g+mm1*g;
 fy(6)=fy(5)-zhunzhongli1(5)-fll;
fx(6)=fx(5)+374*vs*vs*sin(phy(5))*0.3*1+374*vs*vs*(3*mm1/4/pi/7850)^(2/3)*pi;
 phy(j)=atan(((2*fy(j-1))-zhunzhongli1(j))/(fx(j-1)*2));
 else
 fy(j)=fy(j-1)-zhunzhongli1(j); %准重力的编号从浮标开始为 1
 fx(j)=fx(j-1)+374*vs*vs*sin(phy(j-1))*2*sqrt(m(j)*l(j-1)/7850/pi);
 phy(j)=atan(((2*fy(j-1))-zhunzhongli1(j))/(fx(j-1)*2));
 end
 if fy(j)<0
 break
 end
 end
 flll{k}=fy;
 phy1{k}=phy;
 h1=sin(phy).*l;
 H(k)=sum(h1)+h;
 k=k+1;
 phy=[];
end
[h_min,u]=min(abs(hs-H(:)));
 hc=0.3+u*0.001;
 phy2=phy1{u}*180/pi;

 phw=phy1{u}
 R=sum(cos(phy2*pi/180).*l);
end


function [fengli] = ffengli( v,h )
s=(2-h)*2;
fengli=0.625*s*v.*v;
end
