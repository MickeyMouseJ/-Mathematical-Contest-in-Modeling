clc,clear
data =[ 2027.957486	101.219204	393.4238787	77.60581175	266.6013898	723.8787113
2128.822766	64.42541225	140.6174102	71.94171034	39.26370957	1560.974051
8397.283814	108.0709534	222.3503326	173.0820399	67.53880266	7472.283814
2144.684638	79.39055175	133.8321914	158.7390311	156.7195576	1182.233442
1843.99559	52.28133657	145.0896138	164.0470402	102.4255103	816.0796065
3434.167586	68.01297002	102.4176574	75.77791683	80.59616588	2932.76068
2391.155276	65.099065	267.75935	239.2030276	208.9715049	1096.28228
1950.760087	72.08566108	345.8721291	44.23339541	176.0211049	962.0111732
2262.723785	72.89002558	113.9386189	110.6138107	110.5285592	1334.185848
1364.138977	87.52276393	114.2931474	130.8652896	126.7131484	477.4962277
2355.694595	94.42348241	111.6690711	141.5769615	186.5164799	1150.094329
2556.787748	63.32404266	71.67959283	69.34682501	47.88536112	2127.908386
1416.111165	54.30159497	110.6331561	80.64886419	72.31754471	621.2542291
1237.807553	71.27360386	56.40819606	104.4997991	64.28284452	677.7822419
2177.912504	85.20171674	223.1187411	226.6037196	172.6866953	817.5679542
1553.50267	73.3409611	110.7170099	110.488177	112.0518688	679.252479
1713.651814	107.189579	95.60574719	89.14854364	100.9671829	806.563426
2398.381747	32.45371099	71.4870181	52.06399161	38.22187254	2097.613428
2463.603478	72.94164142	96.13357924	91.10789092	68.69977605	1438.084574
2273.627213	73.48555452	157.3159366	131.4538677	177.9123952	754.8928239
6346.831003	69.49212529	180.0271338	194.1072377	107.7272459	5144.812128
2566.609459	110.5168075	207.2585328	251.112975	237.6992064	863.9912252
2380.811324	120.8562924	138.1468111	159.4717842	131.5409462	1341.123567
1638.826756	58.60299921	160.812944	148.5793212	59.234412	797.5532755
1409.702957	73.27788047	130.8133087	115.8471965	150.5668515	479.1743685
851.169218	58.99875879	95.65577162	74.47248655	47.82788581	147.703765
1116.61222	51.45190563	132.5468845	79.06231095	48.36055656	418.0096794

];%将原始数据保存在txt文件中
data=zscore(data);     %数据的标准化
r=corrcoef(data);      %计算相关系数矩阵r
%下面利用相关系数矩阵进行主成分分析，vec1的第一列为r的第一特征向量，即主成分的系数
[vec1,lamda,rate]=pcacov(r);                 %lamda为r的特征值，rate为各个主成分的贡献率
f=repmat(sign(sum(vec1)),size(vec1,1),1);    %构造与vec1同维数的元素为±1的矩阵
vec2=vec1.*f;             %修改特征向量的正负号，使得每个特征向量的分量和为正，即为最终的特征向量
num = max(find(lamda>1)); %num为选取的主成分的个数,这里选取特征值大于1的
num1=1:num  %成分
contribution_rate = lamda / sum(lamda);  % 计算贡献率
cum_contribution_rate = cumsum(lamda)/ sum(lamda);   % 计算累计贡献率  cumsum是求累加值的函数
plot(num1,contribution_rate(1:num),'.-','MarkerSize',20,'LineWidth',1)%碎石图

df=data*vec2(:,1:num);    %计算各个主成分的得分
tf=df*rate(1:num)/100;    %计算综合得分
[stf,ind]=sort(tf,'descend');  %把得照从高到低的次序排列分按
stf=stf'; ind=ind';            %stf为得分从高到低排序，ind为对应的样本编号
