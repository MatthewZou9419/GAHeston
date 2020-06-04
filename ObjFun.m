function f = ObjFun(x)
    % 利用遗传算法校正Heston模型参数的目标函数
    % 
    % 参数说明：
    % V0：    初始方差
    % ThetaV：长期方差
    % Kappa： 均值回归速度
    % SigmaV：方差的波动率
    % RhoSV： 两个维纳过程间的相关系数
    
    V0 = x(1);
    ThetaV = x(2);
    Kappa = x(3);
    SigmaV = x(4);
    RhoSV = x(5);
    global Settles OptSpecs Strikes Maturities OptPrices AssetPrices Rates
    n = length(Settles);
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
    end
    f = f/n;
end
