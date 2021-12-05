close all
clear
clc

%% Ler entradas do Usuário

error = true;
while error 
    p = input('Qual paciente? Insira um número de 1 a 36 \n');
    if p <= 0 || p > 36
        fprintf('Erro: insira um número dentro do intervalo \n')
    elseif p < 10
        p = strcat('0', num2str(p-1));
        error = false;
    else 
        p = num2str(p-1);
        error = false;
    end
end

error = true;
while error
    po = input('\nEm repouso[1] ou realizando operações[2]?\n');
    if (po ~= 1) && (po ~= 2)
        fprintf('Erro: insira um valor válido (1 ou 2) \n')
    else
        po = num2str(po);
        error = false;
    end
end

file = strcat('Subject', p, '_', po, '.edf');
[hdr, record] = edfread(file);

error = true;
while error
    el = input('\nEscolha o eletrodo de acordo com o sistema internacional 10-20\n', 's');
    el = find(strcmp(strcat('EEG',el), hdr.label));
    if isempty(el)
        fprintf('Erro: insira um nome de eletrodo válido \n')
    else
        error = false;
    end
end

%% Variáveis

% Temporárias
y = record(el,:);
L = length(y);
Fs = hdr.frequency(1);              
T = 1/Fs;  
t = (0:L-1)*T;

tf =  round(t(end));
fprintf('\nTempo total do exame: %d segundos \n', tf);

error = true;
while error
    fprintf('Insira o intervalo de tempo desejado, em segundos [Se vazio, total será utilizado]: \n');
    t1 = input('Tempo inicial: ');
    t2 = input('Tempo final: ');
    
    if isempty(t1) || isempty(t2)
        fprintf('Aviso: utilizando tempo total \n')
        error = false;
    elseif (t1 < 0) || (t2 > tf)
        fprintf('Erro: intervalo inválido \n')
    else
        nt = find(t>=t1 & t<=t2);
        y = y(nt);
        L = length(y);
        t = t(nt);
        error = false;
    end
end

%% Plot do EEG

figure(1)
plot(t, y)
title('EEG em operações aritméticas')
xlabel('Time (s)')
ylabel('Voltage (\mu V)')
legend(hdr.label(el))

%% Análise
Y = fft(y);

P2 = abs(Y/L);
P1 = P2(1:round(L/2+1));
P1(2:end-1) = 2*P1(2:end-1);

f = Fs*(0:(L/2))/L;
delta = find(f>=0.5 & f<=3);
theta = find(f>=3 & f<=8);
alpha = find(f>=8 & f<=12);
beta = find(f>=12 & f<=38);
gamma = find(f>=38 & f<=42  );

power = P1.^2;

bw(1) = sum(power(delta));
bw(2) = sum(power(theta));
bw(3) = sum(power(alpha));
bw(4) = sum(power(beta));
bw(5) = sum(power(gamma));
bw(6) = sum(power);

%% Plot das porcentagens
pct = zeros(1, 5);
xWaves = categorical({'delta', 'theta', 'alpha', 'beta', 'gamma'});
xWaves = reordercats(xWaves, {'delta', 'theta', 'alpha', 'beta', 'gamma'});
for i = 1:5
   pct(i) = bw(i)/bw(6)*100;  
end

figure(2)
bar(xWaves, pct)
title('Uso médio de ondas cerebrais durante o exame')
xlabel('Tipo de onda cerebral')
ylabel('Porcentagem (%)')
ylim([0 100])

%% Plot FFT

% figure(2)
% plot(f(delta), power(delta))
% title('FFT do Canal 1')
% xlabel('f (Hz)')
% ylabel('|P1(f)|')