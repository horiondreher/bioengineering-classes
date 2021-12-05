%% Modelagem da condut�ncia do s�dio
close all
clear
clc

%% Varia��o de tens�o na membrana

Vm = [-100:0.001:40];
V_r = -65; %tens�o da membrana em repouso em mV
dV = Vm - V_r; %varia��o de tens�o de tens�o de membrana da tens�o de repouso

a_m = (2.5-0.1.*dV)./(exp(2.5-0.1.*dV)-1); %coeficiente das particulas m (fechado para aberto)
b_m = 4./exp(dV./18); %coeficiente das particulas m (aberto para fechado)
a_h = 0.07./(exp(0.05.*dV));
b_h = 1./(exp(3-0.1.*dV)+1);

m_inf = a_m./(a_m + b_m); %valor do estado est�vel de m
h_inf = a_h./(a_h + b_h); %valor do estado est�vel de h

figure
subplot(2, 2, 1);
plot(Vm, a_m); hold on 
plot(Vm, b_m); hold off
title("Varia��o das taxas \alpha_m e \beta_m")
xlabel('V_m')
ylabel('1/ms')
legend('\alpha_m','\beta_m')

subplot(2, 2, 2);
plot(Vm, m_inf, '--'); hold on 
plot(Vm, h_inf, '--'); hold off
title("Varia��o de m_\infty e h_\infty")
xlabel('V_m')
ylabel('')
legend('m_\infty','h_\infty')

subplot(2, 2, 3);
plot(Vm, a_h); hold on 
plot(Vm, b_h); hold off
title("Varia��o das taxas \alpha_h e \beta_h")
xlabel('V_m')
ylabel('1/ms')
legend('\alpha_h','\beta_h')

subplot(2, 2, 4);
plot(Vm, (m_inf.^3).*h_inf);
title("Varia��o de m^3_\infty h")
xlabel('V_m')
ylabel('')
legend('m^3_\infty h')

%% Variacao no tempo
clear

V_r = -65; %tens�o da membrana em repouso em mV
t1 = 0:0.01:4; %tempo para despolariza��o do s�dio
t2 = 0:0.01:4; %tempo para polariza��o do s�dio
t = [t1 t2];

Vm1 = zeros(1, length(t1)) + 20; %voltage clamp para despolari��o (20mV)
Vm2 = zeros(1, length(t2)) - 60; %voltage clamp para polari��o (-60mV)
Vm = [Vm1 Vm2];

m_01 = zeros(1, length(t1)) + 0.1; %n inicial para despolariza��o do s�dio
m_02 = zeros(1, length(t1)) + 0.9446; %n inicial para polariza��o do s�dio (n final da despolariza��o)
m_0 = [m_01 m_02]; %n

m_31 = zeros(1, length(t1)); %n inicial para despolariza��o do s�dio
m_32 = zeros(1, length(t1)) + 0.9825; %n^4 inicial para polariza��o do s�dio (n final da despolariza��o)
m_30 = [m_31 m_32]; %n

h_01 = zeros(1, length(t1)) + 0.5; %n inicial para despolariza��o do s�dio
h_02 = zeros(1, length(t1)) + 0.001002; %n^4 inicial para polariza��o do s�dio (n final da despolariza��o)
h_0 = [h_01 h_02]; %n

dV = Vm - V_r; %variacao de tens�o fixa
a_m = (2.5-0.1.*dV)./(exp(2.5-0.1.*dV)-1); %coeficiente das particulas m (fechado para aberto)
b_m = 4./exp(dV./18); %coeficiente das particulas m (aberto para fechado)
a_h = 0.07./(exp(0.05.*dV));
b_h = 1./(exp(3-0.1.*dV)+1);

T_m = 1./(a_m + b_m); %constante de tempo
T_h = 1./(a_h + b_h); %constante de tempo
m_inf = a_m./(a_m + b_m); %valor do estado est�vel de m
h_inf = a_h./(a_h + b_h); %valor do estado est�vel de h

m_t = m_inf - ((m_inf - m_0).*exp(-t./T_m)); %equa��o para n no voltage clamp
h_t = h_inf - ((h_inf - h_0).*exp(-t./T_h)); %equa��o para n no voltage clamp

t_plot = 0:0.01:8.01;
figure
plot(t_plot, m_t); hold on
plot(t_plot, m_t.^3);
plot(t_plot, h_t);
plot(t_plot, (m_t.^3).*h_t);
legend("m", "m^3", "h", "m^3 h");

