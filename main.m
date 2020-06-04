clear
% 读取数据
global Settles OptSpecs Strikes Maturities OptPrices AssetPrices Rates
[Settles,OptSpecs,Strikes,Maturities,OptPrices,AssetPrices,Rates] = ...
textread('data/train.txt','%s%s%f%s%f%f%f','headerlines',1);

% 参数设定
%      v0    θ    κ    σv   ρ
lb = [0.001 0.001 0.001 0.001 -1];       % 变量下界
ub = [1     1     10    5     1];        % 变量上界
PopulationSize = 20;                     % 种群规模
Generations = 50;                        % 最大迭代次数
EliteCount = ceil(0.05*PopulationSize);  % 精英数量
CrossoverFraction = 0.8;                 % 交叉比例
options = optimoptions('ga','PopulationSize',PopulationSize,...
    'Generations',Generations,'EliteCount',EliteCount,...
    'CrossoverFraction',CrossoverFraction,...
    'Display','iter','PlotFcn','gaplotbestf');

% 运行遗传算法
rng(0)
% MATLAB自带遗传算法
% [x,fval] = ga(@ObjFun,5,[],[],[],[],lb,ub,[],options);
% 自己编写的遗传算法
[x,fval,history] = GeneticAlgo(@ObjFun,5,lb,ub,options);
