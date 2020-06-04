function [x,fval,history] = GeneticAlgo(fun,nvars,lb,ub,options)
    % �Ŵ��㷨
    %
    % ����˵����
    % fun��    Ŀ�꺯��
    % nvars��  ��������
    % lb��     �����½�
    % ub��     �����Ͻ�
    % options��ѡ��
    
    % ��������
    popSize = options.PopulationSize;
    maxGeneration = options.Generations;
    nEliteKids = options.EliteCount;
    nXoverKids = round(options.CrossoverFraction*(popSize-nEliteKids));
    nMutateKids = popSize-nEliteKids-nXoverKids;
    nParents = 2*nXoverKids+nMutateKids;
    history = zeros(maxGeneration,2);
    gen = 1;
    
    % ��ʼ����Ⱥ
    population = lb+(ub-lb).*rand(popSize,nvars);
    
    % ����
    while gen <= maxGeneration
        % ��Ӧ������
        scores = zeros(popSize,1);
        for pop = 1:popSize
            scores(pop) = fun(population(pop,:));
        end
        
        % ������
        [~,k] = sort(scores);  % k��ԭ�����������е�����ֵ
        n = length(scores);
        expectation = zeros(n,1);
        expectation(k) = 1./sqrt(1:n);  % ��1/sqrt(rank)��Ϊ����
        expectation = expectation./sum(expectation);  % ʹ������֮��Ϊ1
        
        % ��־
        x = population(k(1),:);  % �������Ž�
        fval = scores(k(1));     % ��������ֵ
        meanScore = mean(scores);
        history(gen,:) = [fval,meanScore];
        fprintf('%d\t%.4f\t%.4f\n',gen,fval,meanScore)
        
        % ѡ��
        parents = Selection(expectation,nParents);
        parents = parents(randperm(nParents));  % ����˳��
        
        % ����
        xoverKids = Crossover(parents(1:2*nXoverKids),population);
        
        % ����
        mutateKids = Mutation(parents((1+2*nXoverKids):end),population,...
            gen,maxGeneration,lb,ub);
        
        % �滻��Ⱥ
        eliteKids = population(k(1:nEliteKids),:);
        population = [eliteKids;xoverKids;mutateKids];
        
        gen = gen + 1;
    end
end

% -------------------------------------------------------------------------

function parents = Selection(expectation,nParents)
    % ���̶�ѡ��
    wheel = cumsum(expectation);  % �ۼ������������
    parents = zeros(nParents,1);
    stepSize = 1/nParents;        % ����
    position = rand*stepSize;     % ��ʼλ��
    lowest = 1;
    for i = 1:nParents
        for j = lowest:length(wheel)
            if(position < wheel(j))  % ����
                parents(i) = j;
                lowest = j;
                break;
            end
        end
        position = position + stepSize;  % ��һ������
    end
end

% -------------------------------------------------------------------------

function xoverKids = Crossover(parents,population)
    % ����
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
        % ���ѡ��ĸ����
        xoverKids(i,index1) = population(r1,index1);
        xoverKids(i,index2) = population(r2,index2);  
    end
end

% -------------------------------------------------------------------------

function mutateKids = Mutation(parents,population,generation,...
    maxGeneration,lb,ub)
    % ����
    shrink = 1;
    scale = 1;
    scale = (scale-shrink*scale*generation/maxGeneration).*(ub-lb);
    nKids = length(parents);
    GenomeLength = length(population(1,:));
    mutateKids = zeros(nKids,GenomeLength);
    for i = 1:nKids
        % ͨ����׼��̬�ֲ������������ԭ����ֵ
        mutant = population(parents(i),:)+scale.*randn(1,GenomeLength);
        % �������½�Լ��
        if isempty(find(mutant<lb, 1)) && isempty(find(mutant>ub, 1))
            mutateKids(i,:) = mutant;
        else
            mutateKids(i,:) = population(parents(i),:);
        end
    end
end
