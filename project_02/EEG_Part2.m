close all
clear
clc

%% Ler entradas do Usuário

error = true;
while error 
    p = input('Qual paciente? Insira um número de 1 a 36 \n');
    if p <= 0 || p > 36
        fprintf('Erro: insira um número dentro do intervalo \n')
    elseif p < 11
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

% error = true;
% while error
%     el = input('\nEscolha o eletrodo de acordo com o sistema internacional 10-20\n', 's');
%     el = find(strcmp(strcat('EEG',el), hdr.label));
%     if isempty(el)
%         fprintf('Erro: insira um nome de eletrodo válido \n')
%     else
%         error = false;
%     end
% end

%% Variáveis
P3 = 13;
P4 = 14;
% Temporárias
y = record(P3,:) + record(P4,:);
L = length(y);
Fs = hdr.frequency(1);              
T = 1/Fs;  
t = (0:L-1)*T;

t = t(t>=0 & t<=60);
y = y(t>=0 & t<=60);

%% Plot do EEG

% Tamanho da janela para ser plotada
W = 100;
LPlotInicial = 1;
LPlotFinal = W;

% Array com janelamento
xPlot = t(LPlotInicial:LPlotFinal);
yPlot = y(LPlotInicial:LPlotFinal);

% Variáveis para apresentar porcentagem
%pct = zeros(1, 5);
xWaves = categorical({'delta', 'theta', 'alpha', 'beta', 'gamma'});
xWaves = reordercats(xWaves, {'delta', 'theta', 'alpha', 'beta', 'gamma'});

counter = 1;
for i = LPlotFinal:W:length(y)
    % Intervalo da janela
    xPlot = t(LPlotInicial:LPlotFinal);
    yPlot = y(LPlotInicial:LPlotFinal);
    
    LPlotInicial = LPlotInicial + W;
    LPlotFinal = LPlotFinal + W;
    
    % Cálculo de porcentagem
    Y = fft(yPlot);

    P2 = abs(Y/W);
    P1 = P2(1:round(W/2+1));
    P1(2:end-1) = 2*P1(2:end-1);

    f = Fs*(0:(W/2))/W;
    delta = find(f<4);
    theta = find(f>=4 & f<7);
    alpha = find(f>=7 & f<=13);
    beta = find(f>13 & f<=40);
    gamma = find(f>40);

    power = P1.^2;

    bw = zeros(1, 5);
    bw(1) = sum(power(delta));
    bw(2) = sum(power(theta));
    bw(3) = sum(power(alpha));
    bw(4) = sum(power(beta));
    bw(5) = sum(power(gamma));
    bw(6) = sum(power);
    
    for j = 1:5
        pct(j,counter) = bw(j)/bw(6)*100;  
    end
    counter = counter + 1;
end

% % Apresentação da janela do tempo escolhida
% subplot(6, 1, 1);
% plot(t,y);
% title('EEG em operações aritméticas')
% ylabel('\mu V)')
% %legend(hdr.label(el))
% ylim([-100 100])
% 
% % Apresentação da porcentagem na janela de tempo atual
% subplot(6, 1, 2)
% plot(pct(1,:));
% ylabel('%')
% legend('Delta')
% ylim([0 100])
% 
% % Apresentação da porcentagem na janela de tempo atual
% subplot(6, 1, 3)
% plot(pct(2,:));
% ylabel('%')
% legend('Theta')
% ylim([0 100])
% 
% % Apresentação da porcentagem na janela de tempo atual
% subplot(6, 1, 4)
% plot(pct(3,:));
% ylabel('%')
% legend('Alpha')
% ylim([0 100])
% 
% % Apresentação da porcentagem na janela de tempo atual
% subplot(6, 1, 5)
% plot(pct(4,:));
% ylabel('%')
% legend('Beta')
% ylim([0 100])
% 
% % Apresentação da porcentagem na janela de tempo atual
% subplot(6, 1, 6)
% plot(pct(5,:));
% ylabel('%')
% legend('Gamma')
% ylim([0 100])

mAlpha = mean(pct(3,:));
mBeta = mean(pct(4,:));

fprintf('Média Alpha: %f\nMédia Beta: %f\n', mAlpha, mBeta);
if mAlpha > mBeta
    fprintf('Paciente em repouso\n');
else 
    fprintf('Paciente realizando operação\n');
end
