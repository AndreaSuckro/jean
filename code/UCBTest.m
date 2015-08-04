
%% Script for testing UCB Algorithm

clc;
close all;
clear variables;

%parpool open 4
%parpool close

runs = 500;
assignments = 1000;


fprintf('Run Bandit Algorithms %d times with %d assignments ',runs,assignments);
%% Calculation
epsGreed = zeros(1,runs);
mu_aSum = 0;
mu_bSum = 0;
avgReward = zeros(assignments,runs);
choices = zeros(assignments,runs);
params = randi(50,2)

parfor n = 1:runs
    b1 = [params(1), params(3)];
    b2 = [params(2),params(4)];
    [avgReward(:,n),~,~] = UCB(assignments,b1,b2);
end
%% Plot 
disp('Start plotting ...')
figure('name','UCB Algorithm')
%hold on;
x = 1:1:assignments;
hold on
% plot the uniform Data
mU = mean(avgReward,2);

plot(mU);
hold off;
title('UCB Strategy')
%legend({['Bucket1: ', num2str(params(1)),num2str(params(2)),'Bucket2: ',num2str(params(3)),num2str(params(4))]},'Location','SouthEast');
xlabel('Assignments');
ylabel('Average Reward')

%ylim([2.35 2.56])

%fprintf('Average mean of Bucket A = %d and of Bucket B = %d \n',mu_aSum/runs,mu_bSum/runs)


