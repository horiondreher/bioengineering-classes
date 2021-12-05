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
    po = input('Em repouso[1] ou realizando operações[2]?\n');
    if (po ~= 1) && (po ~= 2)
        fprintf('Erro: insira um valor válido (1 ou 2) \n')
    else
        po = num2str(po);
        error = false;
    end
end

file = strcat('Subject', p, '_', po, '.edf')
[hdr, record] = edfread(file);

error = true;
while error
    el = input('Escolha o eletrodo de acordo com o sistema internacional 10-20');
    if isempty(el)
        fprintf('Erro: insira um nome de eletrodo válido \n')
    else
        error = false;
    end
end
find(strcmp(strcat('EEG1' ,Fp2), hdr.label))

%% Variáveis

ch = 20;
offset = 0;
L = length(record(el,:));
Fs = hdr.frequency(1);              
T = 1/Fs;  
t = (0:L-1)*T;  

%% Plot do EEG

figure(1)
hold on
for i = 1:ch   
    plot(t, record(i,:) + offset)
    offset = offset + 100;
end
hold off
title('EEG em operações aritméticas')
xlabel('Time (s)')
ylabel('Voltage (\mu V)')
ylim([-100 2000])
legend(hdr.label(1:ch))

%% AnÃ¡lise
Y = fft(record(1,:));

P2 = abs(Y/L);
P1 = P2(1:L/2+1);
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

%% Plot FFT

figure(2)
plot(f(delta), power(delta))
title('FFT do Canal 1')
xlabel('f (Hz)')
ylabel('|P1(f)|')

