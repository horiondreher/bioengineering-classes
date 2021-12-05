function [Vm_t] = Vm_t(t, V_m, G_K, G_Na)

    %% Variáveis
    
    V_Na = 50;
    V_K = -77;
    V_L = -54.389;
    
    I_m = 10;
    C_m = 1;
    G_L = 0.3;
    
    %% Equação
    
    Vm_t = (I_m - (V_m - V_Na)*G_Na - (V_m - V_K)*G_K - (V_m - V_L)*G_L)/C_m;

end

