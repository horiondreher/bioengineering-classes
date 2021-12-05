%% Modelagem da condut�ncia do pot�ssio
close all
clear
clc

%% Varia��o de tens�o na membrana
Vm = [-100:0.001:40];
V_r = -65; %tens�o da membrana em repouso em mV

dV = Vm - V_r; %varia��o de tens�o de tens�o de membrana da tens�o de repouso
a_n = (0.1 - 0.01.*dV)./(exp(1 - 0.1.*dV) - 1); %coeficiente da taxa de transfer�ncia  para n particulas em estado fechado para aberto[1/s]
b_n = 0.125./exp(0.0125.*dV); %coeficiente da taxa de transfer�ncia  para n particulas em estado aberto para fechado [1/s]

n_inf = a_n./(a_n + b_n); %valor do estado est�vel de n
N4inf = n_inf.^4; %n elevado a 4a pot�ncia

figure
subplot(1, 2, 1);
plot(Vm, a_n); hold on 
plot(Vm, b_n); hold off 
title("Varia��o das taxas \alpha_n e \beta_n")
xlabel('V_m')
ylabel('1/ms')
legend('\alpha_n','\beta_n')

subplot(1, 2, 2);
plot(Vm, n_inf, '--'); hold on 
plot(Vm, N4inf); hold off
title("Varia��o de n_\infty")
xlabel('V_m')
ylabel('')
legend('n_\infty','n_\infty^4')

%% Varia��o no tempo
clear

V_r = -65; %tens�o da membrana em repouso em mV
t1 = 0:0.01:8; %tempo para despolariza��o do pot�ssio
t2 = 0:0.01:8; %tempo para polariza��o do pot�ssio
t = [t1 t2];

Vm1 = zeros(1, length(t1)) + 20; %voltage clamp para despolari��o (20mV)
Vm2 = zeros(1, length(t2)) - 60; %voltage clamp para polari��o (-60mV)
Vm = [Vm1 Vm2];

n_01 = zeros(1, length(t1)) + 0.4; %n inicial para despolariza��o do pot�ssio
n_02 = zeros(1, length(t1)) + 0.9446; %n inicial para polariza��o do pot�ssio (n final da despolariza��o)
n_11 = zeros(1, length(t1)); %n inicial para despolariza��o do pot�ssio
n_12 = zeros(1, length(t1)) + 0.7987; %n^4 inicial para polariza��o do pot�ssio (n final da despolariza��o)
n_0 = [n_01 n_02]; %n
n_1 = [n_11 n_12]; %n^4

dV = Vm - V_r; %variacao de tens�o fixa
a_n = (0.1 - 0.01.*dV)./(exp(1 - 0.1.*dV) - 1);
b_n = 0.125./exp(0.0125.*dV);

T_n = 1./(a_n + b_n); %constante de tempo
n_inf = a_n./(a_n + b_n);
N4inf = n_inf.^4;

n_t = n_inf - ((n_inf - n_0).*exp(-t./T_n)); %equa��o para n no voltage clamp
n_t2 = N4inf - ((N4inf - n_1).*exp(-t./T_n)); %n^4

t_plot = 0:0.01:16.01;
figure
plot(t_plot, n_t, '--'); hold on
plot(t_plot, n_t2); hold off
title("Varia��o de n no tempo")
xlabel('t')
ylabel('n')
legend('n','n^4')