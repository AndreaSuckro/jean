
%% Script for testing Epsilon Greedy Algorithm

clc;
close all;
clear variables;

%parpool open 4
%parpool close

runs = 2000;
assignments = 2000;

epsGavg = zeros(assignments,runs);

fprintf('Run Bandit Algorithms %d times with %d assignments ',runs,assignments);
%% Calculation
epsGreed = zeros(1,runs);
mu_aSum = 0;
mu_bSum = 0;

parfor n = 1:runs
    params = randi(50,2)
    b1 = [params(1), params(3)];
    b2 = [params(2),params(4)];
    epsGavg(:,n) = EpsilonGreedy(0.2,assignments,b1,b2);
    epsGavg2(:,n) = EpsilonGreedy(0.1,assignments,b1,b2);
    epsGavg3(:,n) = EpsilonGreedy(0.05,assignments,b1,b2);
    epsGavg4(:,n) = EpsilonGreedy(0.025,assignments,b1,b2);
end

%% Plot 
disp('Start plotting ...')
figure('name','Epsilon Greedy Algorithm')
set(gca,'FontSize',11)
%hold on;
x = 1:1:assignments;
hold on
% plot the uniform Data
mU = mean(epsGavg,2);
mU2 = mean(epsGavg2,2);
mU3 = mean(epsGavg3,2);
mU4 = mean(epsGavg4,2);

plot(mU);
plot(mU2);
plot(mU3);
plot(mU4);
hold off;
title('Epsilon Greedy Strategy','FontSize',14)
legend({'e = 0.2','e = 0.1','e = 0.05','e = 0.025'},'Location','SouthEast','FontSize',11);
xlabel('Assignments','FontSize',14);
ylabel('Average Reward','FontSize',14)



