function [a_n, b_n, a_m, b_m, a_h, b_h] = MemCoefs(V_m)
    V_r =   -65;
    dV = V_m - V_r; %variacao de tensão fixa
    
    a_n = (0.1 - 0.01*dV)/(exp(1 - 0.1*dV) - 1);%coeficiente da taxa de transferência  para n particulas em estado fechado para aberto[1/s]
    b_n = 0.125/exp(0.0125*dV); %coeficiente da taxa de transferência  para n particulas em estado aberto para fechado [1/s]
    
    a_m = (2.5-0.1*dV)/(exp(2.5-0.1*dV)-1); %coeficiente das particulas m (fechado para aberto)
    b_m = 4/exp(dV/18); %coeficiente das particulas m (aberto para fechado)
    
    a_h = 0.07/(exp(0.05*dV));
    b_h = 1/(exp(3-0.1*dV)+1);
end