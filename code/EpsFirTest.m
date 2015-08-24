
%% Script for testing the Epsilon First Algorithm
clc;
close all;
clear variables;

runs = 1000;
assignments = 1000;

epsFavg = zeros(assignments,runs);


fprintf('Run Bandit Algorithms %d times with %d assignments ',runs,assignments);
%% Calculation

parfor n = 1:runs
    params = randi(50,2);
    b1 = [params(1), params(3)];
    b2 = [params(2), params(4)];
    epsFavg(:,n) = EpsilonFirst(0.05,assignments,b1,b2);
    epsFavg2(:,n) = EpsilonFirst(0.1,assignments,b1,b2);
    epsFavg3(:,n) = EpsilonFirst(0.2,assignments,b1,b2);
    epsFavg4(:,n) = EpsilonFirst(0.5,assignments,b1,b2);
end

%% Plot 
disp('Start plotting ...')
figure('name','Epsilon Greedy Algorithm')
set(gca,'FontSize',11)

%hold on;
x = 1:1:assignments;
hold on
% plot the uniform Data
mU = mean(epsFavg,2);
mU2 = mean(epsFavg2,2);
mU3 = mean(epsFavg3,2);
mU4 = mean(epsFavg4,2);

plot(mU);
plot(mU2);
plot(mU3);
plot(mU4);
hold off;
title('Epsilon First Strategy','FontSize',14)
legend({'e = 0.1','e = 0.2','e = 0.5','e = 0.8'},'Location','SouthEast','FontSize',11);
xlabel('Assignments','FontSize',14);
ylabel('Average Reward','FontSize',14);



