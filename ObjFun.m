function f = ObjFun(x)
    % �����Ŵ��㷨У��Hestonģ�Ͳ�����Ŀ�꺯��
    % 
    % ����˵����
    % V0��    ��ʼ����
    % ThetaV�����ڷ���
    % Kappa�� ��ֵ�ع��ٶ�
    % SigmaV������Ĳ�����
    % RhoSV�� ����ά�ɹ��̼�����ϵ��
    
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
