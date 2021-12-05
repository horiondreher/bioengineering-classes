function [t, V_m, G_K, G_Na] = NaKL(intvl, t_i, t_f)
    
    %% Variáveis
    G_Na_Max = 120;
    G_K_Max = 36;
    
    %% Inicialização do eixo x e y
    t = t_i:intvl:t_f; %intervalo de x
    max = length(t)-1;
    
    n = zeros(1,length(t));
    n(1) = 0.4;
    
    m = zeros(1,length(t));
    m(1) = 0.1;
    
    h = zeros(1,length(t));
    h(1) = 0.5;
    
    V_m = zeros(1,length(t)); % Variação de tensão
    V_m(1) = -65;   % valor inicial de y
    
    G_K = zeros(1, length(t));
    G_Na = zeros(1, length(t));
    
    %% Cálculo de Runge-Kutta
    for i = 1:max
        
        [a_n, b_n, a_m, b_m, a_h, b_h] = MemCoefs(V_m(i));
    
        k1_1 = n_t(t(i), n(i), a_n, b_n);
        k2_1 = n_t(t(i)+.5*intvl, n(i)+.5*k1_1*intvl, a_n, b_n);
        k3_1 = n_t(t(i)+.5*intvl, n(i)+.5*k2_1*intvl, a_n, b_n);
        k4_1 = n_t(t(i)+intvl, n(i)+k3_1*intvl, a_n, b_n);
        n(i+1) = n(i)+((k1_1+2*k2_1+2*k3_1+k4_1)/6)*intvl;
        
        k1_2 = m_t(t(i), m(i), a_m, b_m);
        k2_2 = m_t(t(i)+.5*intvl, m(i)+.5*k1_2*intvl, a_m, b_m);
        k3_2 = m_t(t(i)+.5*intvl, m(i)+.5*k2_2*intvl, a_m, b_m);
        k4_2 = m_t(t(i)+intvl, m(i)+k3_2*intvl, a_m, b_m);
        m(i+1) = m(i)+((k1_2+2*k2_2+2*k3_2+k4_2)/6)*intvl;
        
        k1_3 = h_t(t(i), h(i), a_h, b_h);
        k2_3 = h_t(t(i)+.5*intvl, h(i)+.5*k1_3*intvl, a_h, b_h);
        k3_3 = h_t(t(i)+.5*intvl, h(i)+.5*k2_3*intvl, a_h, b_h);
        k4_3 = h_t(t(i)+intvl, h(i)+k3_3*intvl, a_h, b_h);
        h(i+1) = h(i)+((k1_3+2*k2_3+2*k3_3+k4_3)/6)*intvl;
        
        G_K(i) = G_K_Max*n(i)^4;
        G_Na(i) = G_Na_Max*m(i)^3*h(i);

        k1_4 = Vm_t(t(i), V_m(i), G_K(i), G_Na(i));
        k2_4 = Vm_t(t(i)+.5*intvl, V_m(i)+.5*k1_4*intvl, G_K(i), G_Na(i));
        k3_4 = Vm_t(t(i)+.5*intvl, V_m(i)+.5*k2_4*intvl, G_K(i), G_Na(i));
        k4_4 = Vm_t(t(i)+intvl, V_m(i)+k3_4*intvl, G_K(i), G_Na(i));
        V_m(i+1) = V_m(i)+((k1_4+2*k2_4+2*k3_4+k4_4)/6)*intvl;
    end
end