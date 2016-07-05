%Aluno: Fernando Soares Carnevale Ito - 7152681
clear all;

%Mapeamento junta - index
%Index 1 - Origem
%Index 2 - Junta 1
%Index 3 - Junta 2
%Index 4 - Junta 3
%Index 5 - Efetuador
dim = 5;

%%%%%variaveis simbolicas%%%%%
THETA = sym('theta', [dim 1]);
THETA1 = sym('theta1_%d', [dim 1]);
THETA2 = sym('theta2_%d', [dim 1]);

w = cell(dim, 1);
w1 = cell(dim, 1);
v1 = cell(dim, 1);
v1C = cell(dim, 1);

F = cell(dim, 1);
N = cell(dim, 1);

f = cell(dim, 1);
n = cell(dim, 1);

%Matrix de rotação do sistema i-1 para i em relacao ao eixo Z
R = cell(dim, 1);
R{1} = eye(3);  %not used
R{5} = eye(3);
for i=2:4
    R{i} = [cos(THETA(i)) -sin(THETA(i)) 0; cos(THETA(i)) -sin(THETA(i)) 0; 0 0 1];
end

torque = cell(dim, 1); %resultado final


%%%%%constantes%%%%%
%gravidade
g = [ 0 -9.8 0]';
G = -g;

%Vetor direção do eixo da junta i
Z = cell(dim, 1); 
for i=1:dim
    Z{i}= [0 0 1]';
end

%posicao da junta i em relação a junta i-1
P = cell(dim, 1);
P{1} = [0 0 0]'; %not used
P{2} = [0 0 0]'; %da origem pra junta 1
for i=3:dim
    P{i} = [0.2 0 0]';
end

%posicao Pi do centro de massa
PC = cell(dim, 1);
PC{1} = [0 0 0]'; %not used
PC{5} = [0 0 0]'; %not used
for i=2:4
    PC{i} = [0.2/2 0 0]';
end

%massa do elo das juntas 1, 2, 3 (no vetor posicoes 2, 3, 4)
m = zeros(dim,1);
for i=2:4
    m(i) = 1;
end

%tensor de inercia da junta i
IC = cell(dim, 1);
IC{1} = eye(3); %not used
IC{5} = eye(3); %not used
for i=2:4
    IC{i} = [5e-5 0 0; 0 3.36e-3 0; 0 0 3.36e-3];
end


%%%%%condicoes iniciais%%%%%
%acao da gravidade
v1{1} = G;
%referencial origem em repouso
w{1} = [0 0 0]';
w1{1} = [0 0 0]';
%sem forças externas no efetuador
f{5} = [0 0 0]';
n{5} = [0 0 0]';

%%%%%Calculos iniciais%%%%%

%propagação para frente
for i=2:4
    %calculo velocidade angular
    w{i} = R{i}*w{i-1}+THETA1(i)*Z{i};
    %calculo aceleração angular
    w1{i} =  R{i}*w1{i-1} + cross(  R{i}*w{i-1}, THETA1(i)*Z{i}) + THETA2(i)*Z{i};
    %calculo aceleração linear
    v1{i} =  R{i}*(cross( w1{i-1}, P{i}) + cross( w{i-1}, cross(w{i-1},P{i})) + v1{i-1});
    %calculo aceleração linear do centro de massa
    v1C{i} = cross( w1{i}, PC{i}) + cross( w{i}, cross(w{i},PC{i})) + v1{i};
    
    %calculo forcas e torques inerciais agindo no centro de massa de cada
    %elo
    F{i} = m(i)*v1C{i};
    N{i} = IC{i}*w1{i} + cross(w{i}, IC{i}*w{i});
end

%propagação para tras
for i=4:-1:2
    f{i} = R{i+1}'*f{i+1} + F{i};
    n{i} = R{i+1}'*n{i+1} + N{i} + cross( PC{i}, F{i}) + cross(P{i+1}, R{i+1}*f{i+1});
    torque{i} = n{i}'*Z{i};
end


%%%%%simulação%%%%%
%tempo simulação
delta=0.1;
tTotal=10;
time=0:delta:tTotal;

%constantes
q0 = 0;
c0 = q0;
c1 = 0;
c2 = 0;
Theta0 = zeros(dim,1);
Thetaf = zeros(dim,1);
Thetaf(2) = deg2rad(15);
Thetaf(3) = deg2rad(30);
Thetaf(4) = deg2rad(45);

%equacoes de theta
t = sym('t');
thetaeq = cell(dim, 1);
theta1eq = cell(dim, 1);
theta2eq = cell(dim, 1);
for i=2:4    
    thetaeq{i} = c0 + c1*t + c2*t^2 + (10*(Thetaf(i) - Theta0(i))/tTotal^3)*t^3 + (15*(Theta0(i) - Thetaf(i))/tTotal^4)*t^4 + (6*(Thetaf(i) - Theta0(i))/tTotal^5)*t^5;
    theta1eq{i} = diff(thetaeq{i});
    theta2eq{i} = diff(theta1eq{i});
end

%substituicoes e calculos
thetaval = zeros(dim,length(time));
theta1val = zeros(dim,length(time));
theta2val = zeros(dim,length(time));


torqueval = zeros(dim,length(time));
velangval = zeros(dim,length(time));
count = 0;
for count=1:length(time)
    
    temporaryTorque = cell(dim, 1);
    temporaryW = cell(dim, 1);
    for i=2:4
        thetaval(i, count) = subs(thetaeq{i}, t, time(count));
        theta1val(i, count) = subs(theta1eq{i}, t, time(count));
        theta2val(i, count) = subs(theta2eq{i}, t, time(count));
        
        temporaryW{i} = w{i};
        for ii =2:4
            temporaryW{i} = subs(temporaryW{i}, {THETA(ii), THETA1(ii), THETA2(ii)}, {thetaval(ii, count), theta1val(ii, count), theta2val(ii, count)});
        end
        velangval(i,count) = temporaryW{i}'*Z{i};
        
        temporaryTorque{i} = torque{i};
        for ii =2:4
            temporaryTorque{i} = subs(temporaryTorque{i}, {THETA(ii), THETA1(ii), THETA2(ii)}, {thetaval(ii, count), theta1val(ii, count), theta2val(ii, count)});
        end
        torqueval(i,count) = temporaryTorque{i};
    end
end

%%%%%plot%%%%%
lstyle = cell(dim, 1);
lstyle{2} = ':';
lstyle{3} = '--';
lstyle{4} = '-';

lcolor = cell(dim, 1);
lcolor{2} = 'b';
lcolor{3} = 'm';
lcolor{4} = 'g';
%velocidade w{i}

%posicao
figure(1)
hold off
for i=2:4
    p = plot(time, rad2deg(thetaval(i,:)));
    p.LineStyle = lstyle{i};
    p.Color = lcolor{i};
    p.LineWidth = 2;
    p.DisplayName = sprintf('Junta %d',i-1);
    hold on
end
grid on
l = legend('show');
l.Location = 'northwest';
l.FontSize = 16;
title('Posição das Juntas X Tempo');
xlabel('Tempo (s)');
ylabel('Posição da Junta (graus)');

%velocidade w dos elos
figure(2)
hold off
for i=2:4
    p = plot(time, velangval(i,:));
    p.LineStyle = lstyle{i};
    p.Color = lcolor{i};
    p.LineWidth = 2;
    p.DisplayName = sprintf('Elo %d',i-1);
    hold on
end
grid on
l = legend('show');
l.Location = 'northwest';
l.FontSize = 16;
title('Velocidade angular dos elos X Tempo');
xlabel('Tempo (s)');
ylabel('Velocidade angular dos elos (rad/s)');

%velocidade w das juntas
figure(3)
hold off
for i=2:4
    p = plot(time, theta1val(i,:));
    p.LineStyle = lstyle{i};
    p.Color = lcolor{i};
    p.LineWidth = 2;
    p.DisplayName = sprintf('Junta %d',i-1);
    hold on
end
grid on
l = legend('show');
l.Location = 'northwest';
l.FontSize = 16;
title('Velocidade angular das juntas X Tempo');
xlabel('Tempo (s)');
ylabel('Velocidade angular das juntas (rad/s)');

%Torque nas juntas
figure(4)
hold off
for i=2:4
    p = plot(time, torqueval(i,:));
    p.LineStyle = lstyle{i};
    p.Color = lcolor{i};
    p.LineWidth = 2;
    p.DisplayName = sprintf('Junta %d',i-1);
    hold on
end
grid on
l = legend('show');
l.Location = 'southwest';
l.FontSize = 16;
title('Torque nas juntas X Tempo');
xlabel('Tempo (s)');
ylabel('Torque nas juntas (Nm)');