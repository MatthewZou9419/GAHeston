function [x,fval,history] = GeneticAlgo(fun,nvars,lb,ub,options)
    % 遗传算法
    %
    % 参数说明：
    % fun：    目标函数
    % nvars：  变量个数
    % lb：     变量下界
    % ub：     变量上界
    % options：选项
    
    % 参数设置
    popSize = options.PopulationSize;
    maxGeneration = options.Generations;
    nEliteKids = options.EliteCount;
    nXoverKids = round(options.CrossoverFraction*(popSize-nEliteKids));
    nMutateKids = popSize-nEliteKids-nXoverKids;
    nParents = 2*nXoverKids+nMutateKids;
    history = zeros(maxGeneration,2);
    gen = 1;
    
    % 初始化种群
    population = lb+(ub-lb).*rand(popSize,nvars);
    
    % 迭代
    while gen <= maxGeneration
        % 适应度评估
        scores = zeros(popSize,1);
        for pop = 1:popSize
            scores(pop) = fun(population(pop,:));
        end
        
        % 求期望
        [~,k] = sort(scores);  % k是原数据升序排列的索引值
        n = length(scores);
        expectation = zeros(n,1);
        expectation(k) = 1./sqrt(1:n);  % 用1/sqrt(rank)作为期望
        expectation = expectation./sum(expectation);  % 使得期望之和为1
        
        % 日志
        x = population(k(1),:);  % 更新最优解
        fval = scores(k(1));     % 更新最优值
        meanScore = mean(scores);
        history(gen,:) = [fval,meanScore];
        fprintf('%d\t%.4f\t%.4f\n',gen,fval,meanScore)
        
        % 选择
        parents = Selection(expectation,nParents);
        parents = parents(randperm(nParents));  % 打乱顺序
        
        % 交叉
        xoverKids = Crossover(parents(1:2*nXoverKids),population);
        
        % 变异
        mutateKids = Mutation(parents((1+2*nXoverKids):end),population,...
            gen,maxGeneration,lb,ub);
        
        % 替换种群
        eliteKids = population(k(1:nEliteKids),:);
        population = [eliteKids;xoverKids;mutateKids];
        
        gen = gen + 1;
    end
end

% -------------------------------------------------------------------------

function parents = Selection(expectation,nParents)
    % 轮盘赌选择
    wheel = cumsum(expectation);  % 累计求和生成轮盘
    parents = zeros(nParents,1);
    stepSize = 1/nParents;        % 步长
    position = rand*stepSize;     % 初始位置
    lowest = 1;
    for i = 1:nParents
        for j = lowest:length(wheel)
            if(position < wheel(j))  % 落入
                parents(i) = j;
                lowest = j;
                break;
            end
        end
        position = position + stepSize;  % 走一个步长
    end
end

% -------------------------------------------------------------------------

function xoverKids = Crossover(parents,population)
    % 交叉
    nKids = length(parents)/2;
    GenomeLength = length(population(1,:));
    xoverKids = zeros(nKids,GenomeLength);
    index = 1;
    for i = 1:nKids
        r1 = parents(index);
        r2 = parents(index+1);
        index = index+2;
        probas = rand(1,GenomeLength);
        index1 = find(probas>0.5);
        index2 = find(probas<=0.5);  
        % 随机选择父母基因
        xoverKids(i,index1) = population(r1,index1);
        xoverKids(i,index2) = population(r2,index2);  
    end
end

% -------------------------------------------------------------------------

function mutateKids = Mutation(parents,population,generation,...
    maxGeneration,lb,ub)
    % 变异
    shrink = 1;
    scale = 1;
    scale = (scale-shrink*scale*generation/maxGeneration).*(ub-lb);
    nKids = length(parents);
    GenomeLength = length(population(1,:));
    mutateKids = zeros(nKids,GenomeLength);
    for i = 1:nKids
        % 通过标准正态分布随机变量调整原基因值
        mutant = population(parents(i),:)+scale.*randn(1,GenomeLength);
        % 变量上下界约束
        if isempty(find(mutant<lb, 1)) && isempty(find(mutant>ub, 1))
            mutateKids(i,:) = mutant;
        else
            mutateKids(i,:) = population(parents(i),:);
        end
    end
end
