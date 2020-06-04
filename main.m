clear
% ��ȡ����
global Settles OptSpecs Strikes Maturities OptPrices AssetPrices Rates
[Settles,OptSpecs,Strikes,Maturities,OptPrices,AssetPrices,Rates] = ...
textread('data/train.txt','%s%s%f%s%f%f%f','headerlines',1);

% �����趨
%      v0    ��    ��    ��v   ��
lb = [0.001 0.001 0.001 0.001 -1];       % �����½�
ub = [1     1     10    5     1];        % �����Ͻ�
PopulationSize = 20;                     % ��Ⱥ��ģ
Generations = 50;                        % ����������
EliteCount = ceil(0.05*PopulationSize);  % ��Ӣ����
CrossoverFraction = 0.8;                 % �������
options = optimoptions('ga','PopulationSize',PopulationSize,...
    'Generations',Generations,'EliteCount',EliteCount,...
    'CrossoverFraction',CrossoverFraction,...
    'Display','iter','PlotFcn','gaplotbestf');

% �����Ŵ��㷨
rng(0)
% MATLAB�Դ��Ŵ��㷨
% [x,fval] = ga(@ObjFun,5,[],[],[],[],lb,ub,[],options);
% �Լ���д���Ŵ��㷨
[x,fval,history] = GeneticAlgo(@ObjFun,5,lb,ub,options);
