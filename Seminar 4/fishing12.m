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
y = 550/max(y)*y;

figure(1)
plot(x,y)
xlabel('Percent of Maximum Fish Population')
ylabel('New Fish per Year')
title('Regeneration of Fish')
grid on

matlab2tikz('figures\regeneration_of_fish.tex','showInfo', false);

%% b) Ship Effectiveness
x = linspace(0,6,1000);
y = x./(1+x);

x = 100/6*x;
y = 25/max(y)*y;

figure(2)
plot(x,y)
ylim([0 30])
xlabel('Fish Density')
ylabel('Ship Effectiveness')
title('Ship Effectiveness')
pbaspect([2 1 1])
grid on

matlab2tikz('figures\ship_effectiveness.tex','showInfo', false);