function [f,result] = evaluate()
    % 读取数据
    [Settles,OptSpecs,Strikes,Maturities,OptPrices,AssetPrices,Rates] = ...
    textread('data/test.txt','%s%s%f%s%f%f%f','headerlines',1);
    
    % 参数设定
    % MATLAB自带遗传算法校正结果
    % x = [0.0330 0.0043 2.2632 2.0447 -0.3912];
    % 自己编写的遗传算法校正结果
    x = [0.0291 0.0610 6.8685 4.1902 -0.3905];
    V0 = x(1);
    ThetaV = x(2);
    Kappa = x(3);
    SigmaV = x(4);
    RhoSV = x(5);
    
    % 计算误差
    n = length(Settles);
    result = zeros(n,2);
    f = 0;
    for row = 1:n
        Settle = datetime(Settles{row});
        OptSpec = OptSpecs{row};
        Strike = Strikes(row);
        Maturity = datetime(Maturities{row});
        OptPrice = OptPrices(row);
        AssetPrice = AssetPrices(row);
        Rate = Rates(row);
        HestonPrice = optByHestonNI(Rate,AssetPrice,Settle,Maturity,...
            OptSpec,Strike,V0,ThetaV,Kappa,SigmaV,RhoSV);
        f = f+abs(OptPrice-HestonPrice);
        result(row,:) = [OptPrice HestonPrice];
    end
    f = f/n;
end
