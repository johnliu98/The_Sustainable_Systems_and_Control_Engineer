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

%{
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
%}
    
fr = @(x) fr_max*x.^2.*(100-x);

%% b) Ship Effectiveness
x = linspace(0,6,1000);
y = x./(1+x);

x = 100/6*x;
fe_max = 25/max(y);
y = 25/max(y)*y;

%{
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
%}
    
fe = @(x) fe_max * 6*x./(100+6*x);

%% c) Dynamics of Fish Population
x_max = 2000;
fx = @(x,y) fr(100*x./x_max) - y.*fe(100*x./x_max);

%% d) Equilibrium points and region of attraction
%{
syms x

N = 41;
y_max = 40;
equi = zeros(4,N);
y = linspace(0.01,y_max,N);

ubs = zeros(1,N);
lbs = zeros(1,N);
for i=1:N
    equi(:,i) = double(solve(fx(x,y(i))));
    
    df = diff(sym(@(x)fx(x,y(i))));
    bounds = double(solve(df));
    bounds = bounds(abs(imag(bounds)) < 1e-6);
    ubs(i) = max(bounds);
    lbs(i) = min(bounds);
end
eq = equi;
equi = real(equi);
equi(2,:) = [equi(2,1:17) 785 equi(3,19:end)];
equi(3,:) = [];

figure, hold on
plot(1:N,equi(1,:),'Color',[1, 0, 0])
plot(1:25,equi(2,1:25),'Color',[0.9290, 0.6940, 0.1250])
plot(1:25,equi(3,1:25),'Color',[0, 0.5, 0])
ylim([0 x_max])
xlim([0 y_max])
grid on

x = 1:N;
xx = [x fliplr(x)];
yy1 = [equi(1,:) fliplr(equi(2,:))];
fill(xx,yy1,'r','FaceAlpha',0.1,'EdgeColor','none')

x = 1:25;
xx = [x fliplr(x)];
yy2 = [equi(2,1:25) fliplr(equi(3,1:25))];
yy3 = [equi(3,1:25) fliplr(2000*ones(1,25))];
fill(xx,yy2,'g','FaceAlpha',0.1,'EdgeColor','none')
fill(xx,yy3,'g','FaceAlpha',0.1,'EdgeColor','none')

x = 25:N;
xx = [x fliplr(x)];
yy4 = [equi(3,x) 2000*ones(size(equi(x)))];
fill(xx,yy4,'r','FaceAlpha',0.1,'EdgeColor','none')

xlabel('Fishing Boats')
ylabel('Fish')
legend('stable','unstable','stable','extinction zone','surviving zone')

if exist('matlab2tikz_path','var')
    matlab2tikz('figures\region_of_attraction.tex','showInfo', false);
end
%}

%% f) Dynamics number of fishing  boats
ky = [0.1 0.5 1];
c = [20 22 24];
[ky,c] = meshgrid(ky,c);
color = [0, 0.4470, 0.7410;
         0.8500, 0.3250, 0.0980;
         0.9290, 0.6940, 0.1250;
         0.4940, 0.1840, 0.5560;
         0.4660, 0.6740, 0.1880;
         0.3010, 0.7450, 0.9330];

 %{
fig = figure;
for i=1:numel(ky)
    
    fy = @(x,y) ky(i)*y.*(fe(100*x./x_max)-c(i));
    [X1,X2] = meshgrid(linspace(0,2000,10),linspace(0,200,10));
    F1 = fx(X1,X2);
    F2 = fy(X1,X2);
    
    subplot(3,3,i)
    streamslice(X1,X2,F1,F2,0.2,'noarrows');
    
    if i==8
        xlabel('Fish')
    end
    if i==4
        ylabel('Fishing Boats')
    end
    
    title(sprintf('ky=%.1f, c=%.0f', [ky(i),c(i)]))
    
    xticks([0 1000 2000])
    xticklabels({'0','1000','2000'})
    
    axis([0 2000 0 200])
    grid on
end


if exist('matlab2tikz_path','var')
    matlab2tikz('figures\dynamic_ships.tex','showInfo', false);
end
%}
