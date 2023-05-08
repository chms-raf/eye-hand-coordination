% This code demonstrates the CUMSUM algorithm.
% Based on Pontus Olsson paper (2007).
% Created by Jack Schultz, March 27th 2020

clear; clc; close all

f = 50;

% Time vector
t = (.01:1/f:5)';

% Signal mean changes
n = 5;
a = 0;
b = 10;
c = 20;
d = 10;
e = 0;

% Initialize signal means
%mu = zeros(size(t));
mu = [a*ones(length(t)/n,1); b*ones(length(t)/n,1); c*ones(length(t)/n,1); d*ones(length(t)/n,1); e*ones(length(t)/n,1)];

% % First signal mean
% temp = t <= .95;
% mu(temp) = a;
% 
% % First signal mean change
% temp = t > .95 & t <= 1;
% mu(temp) = linspace(a,b,length(find(temp == 1)));
% 
% % Second signal mean
% temp = t > 1 & t <= 1.95;
% mu(temp) = b;
% 
% % Second signal mean change
% temp = t > 1.95 & t <= 2;
% mu(temp) = linspace(b,c,length(find(temp == 1)));
% 
% % Third signal mean
% temp = t > 2;
% mu(temp) = c;

% Create signal with noise
sigma = 5;
y = mu + sigma*randn(length(t),1);

% Cumulative Sum Algorithm
lambda = .85;
v = 2.3;
h = 32;
theta = y(1,1);
e = zeros(size(t));
g1 = zeros(size(t));
g2 = zeros(size(t));
fnum = 0;

for i = 2:1:length(t)
    theta(i,1) = lambda*theta(i-1) + (1-lambda)*y(i);
    e(i,1) = y(i) - theta(i-1);
    g1(i,1) = max([g1(i-1) + e(i) - v, 0]);
    if g1(i,1) > h
        fnum = fnum + 1;
        flag(fnum,1) = t(i,1);
        fprintf('Positive (g1) change detected at t = %f\n', t(i,1))
        g1(i,1) = 0;
    end
    g2(i,1) = max([g2(i-1) - e(i) - v, 0]);
    if g2(i,1) > h
        fnum = fnum + 1;
        flag(fnum,1) = t(i,1);
        fprintf('Negative (g2) change detected at t = %f\n', t(i,1))
        g2(i,1) = 0;
    end
end

for i = 1:1:fnum
    temp(i,1) = find(t == flag(i));
end


plot(t,mu,'b','LineWidth',2)
hold on
plot(t,theta,'g','LineWidth',2)
plot(t,y,'r')
plot(flag,mu(temp),'ko','MarkerSize',10, 'LineWidth',2)
axis([0 n -12.5 37.5])
grid on
legend('Signal','Signal Estimate','Measurement','Estimated Jumptimes')
xlabel('Time (s)')
ylabel('Signal')
title('CUMSUM Test (Synthetic Data)')