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

% figure(1)
% plot(x,y)
% xlabel('Percent of Maximum Fish Population')
% ylabel('New Fish per Year')
% title('Regeneration of Fish')
% pbaspect([1.5 1 1])
% grid on
% 
% if exist('matlab2tikz_path','var')
%     matlab2tikz('figures\regeneration_of_fish.tex','showInfo', false);
% end
    
fr = @(x) fr_max*x.^2.*(100-x);

%% b) Ship Effectiveness
x = linspace(0,6,1000);
y = x./(1+x);

x = 100/6*x;
fe_max = 25/max(y);
y = 25/max(y)*y;

% figure(2)
% plot(x,y)
% ylim([0 30])
% xlabel('Fish Density')
% ylabel('Ship Effectiveness')
% title('Ship Effectiveness')
% pbaspect([2 1 1])
% grid on
% 
% if exist('matlab2tikz_path','var')
%     matlab2tikz('figures\ship_effectiveness.tex','showInfo', false);
% end
    
fe = @(x) fe_max * 6*x./(100+6*x);

%% c) Dynamics of Fish Population
x_max = 2000;
f = @(x,y) fr(100*x./x_max) - y.*fe(100*x./x_max);

%% d) Equilibrium points and region of attraction
syms x

N = 41;
y_max = 40;
equi = zeros(4,N);
y = linspace(0.01,y_max,N);

ubs = zeros(1,N);
lbs = zeros(1,N);
for i=1:N
    equi(:,i) = double(solve(f(x,y(i))));
    
    df = diff(sym(@(x)f(x,y(i))));
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
legend('stable','unstable','stable','survining zone', 'extinction zone')

if exist('matlab2tikz_path','var')
    matlab2tikz('figures\region_of_attraction.tex','showInfo', false);
end


