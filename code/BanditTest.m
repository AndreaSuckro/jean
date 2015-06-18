
%% Script for testing the other code
clc;
close all;
clear variables;

%parpool open 4
%parpool close

runs = 1000;
assignments = 1000;

epsGavg = zeros(assignments,runs);

fprintf('Run Bandit Algorithms %d times with %d assignments ',runs,assignments);
%% Calculation
epsGreed = zeros(1,runs);
mu_aSum = 0;
mu_bSum = 0;

parfor n = 1:runs
    mu_a = 2 + (randn);
    mu_aSum = mu_aSum+mu_a;
    mu_b = 2 + (randn);
    mu_bSum = mu_bSum+mu_b;
    epsGavg(:,n) = EpsilonGreedy(0.2,assignments,mu_a,mu_b);
    epsGavg2(:,n) = EpsilonGreedy(0.1,assignments,mu_a,mu_b);
    epsGavg3(:,n) = EpsilonGreedy(0.05,assignments,mu_a,mu_b);
    epsGavg4(:,n) = EpsilonGreedy(0.025,assignments,mu_a,mu_b);
end

%% Plot 
disp('Start plotting ...')
figure('name','Epsilon Greedy Algorithm')
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
title('Epsilon Greedy Strategy')
legend({'e = 0.2','e = 0.1','e = 0.05','e = 0.025'},'Location','SouthEast');
xlabel('Assignments');
ylabel('Average Reward')

%ylim([2.35 2.56])

fprintf('Average mean of Bucket A = %d and of Bucket B = %d \n',mu_aSum/runs,mu_bSum/runs)


