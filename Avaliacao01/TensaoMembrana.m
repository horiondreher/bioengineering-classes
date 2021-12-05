%% Modelagem da tensão da membrana
close all
clear
clc

%% Variáveis Para Cálculo Numérico

intvl = 0.001;
t_i = 0;
t_f = 30;

%% Resolução das EDOs

[t, V_m, G_K, G_Na]  = NaKL(intvl, t_i, t_f);
 
figure
hold on
yyaxis left
plot(t, V_m);
xlabel('Tempo (ms)');
ylabel('V_m (mV)');
yyaxis right
plot(t, G_K);
plot(t, G_Na);
plot(t, G_Na+G_K);
ylabel('G (mS/cm^2)');
legend('\Delta V_m', 'G_K', 'G_N_a', 'G_N_a + G_K');
hold off;