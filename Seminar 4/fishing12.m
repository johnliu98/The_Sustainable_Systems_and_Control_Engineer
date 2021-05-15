%{
   1.2 Modeling a fishing scenario 
%}

close all;
clear all;
clc;

paths = split(path,';');
expr = 'plottools$';
for i=1:numel(paths)
    if ~isempty(regexp(paths{i},expr,'once'))
        matlab2tikz_path = paths{i};
    end
end

if exist('matlab2tikz_path','var')
    matlab2tikz_path = strcat(matlab2tikz_path,...
        '\matlab2tikz\src');
    
    addpath(matlab2tikz_path,'-end')
end

%% a) Regeneration of Fish
x = linspace(0,100,100);
y = x.^2.*(100-x);

fr_max = 550/max(y);
y = 550/max(y)*y;

figure(1)
plot(x,y)
xlabel('Percent of Maximum Fish Population')
ylabel('New Fish per Year')
title('Regeneration of Fish')
pbaspect([1.5 1 1])
grid on

if exist('matlab2tikz_path','var')
    matlab2tikz('figures\regeneration_of_fish.tex','showInfo', false);
end
    
fr = @(x) fr_max*x.^2.*(100-x);

%% b) Ship Effectiveness
x = linspace(0,6,1000);
y = x./(1+x);

x = 100/6*x;
fe_max = 25/max(y);
y = 25/max(y)*y;

figure(2)
plot(x,y)
ylim([0 30])
xlabel('Fish Density')
ylabel('Ship Effectiveness')
title('Ship Effectiveness')
pbaspect([2 1 1])
grid on

if exist('matlab2tikz_path','var')
    matlab2tikz('figures\ship_effectiveness.tex','showInfo', false);
end
    
fe = @(x) fe_max * 6*x./(100+6*x);

%% c) Dynamics of Fish Population
x_max = 2000;
f = @(x,y) fr(x./x_max) - y.*fe(x./x_max);

%% d) Equilibrium points and region of attraction
N = 1000;
ymax = 100;
equi = zeros(4,N);
y = linspace(0,ymax,N);
for i=1:N
    poly = fr_max*[-6 500 10000];
    poly = [poly -175*y(i) 0];
    equi(:,i) = roots(poly);
end
equi = real(equi);

figure
for i=1:4
    subplot(4,1,i)
    plot(ymax/N*(1:N),equi(i,:))
    grid on
end














