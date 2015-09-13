
%% Script for testing UCB vs Thompson Algorithm

%clearing workspace and assigning variables
clc;
close all;
clear variables;

runs = 100;
assignments = 4000;

fprintf('Run UCB vs. Thompson Algorithms %d times with %d assignments ',runs,assignments);
%% Calculation
epsGreed = zeros(1,runs);
mu_aSum = 0;
mu_bSum = 0;
avgReward = zeros(assignments,runs);
avgReward2 = zeros(assignments,runs);

choices = zeros(assignments,runs);

name = 'Thompson Sampling vs. UCB';


parfor n = 1:runs
    params = randi(50,2)
    b1 = [params(1), params(3)];
    b2 = [params(2), params(4)];
    [avgReward(:,n),~,~] = UCB(assignments,b1,b2);
    avgReward2(:,n) = Thompson(assignments,b1,b2);
end
%% Plot 
disp('Start plotting ...')
figure('name',name)
x = 1:1:assignments;
hold on

% plot UCB and Thompson generated data
mU_ucb = mean(avgReward,2);
mU_thom = mean(avgReward2,2);

plot(mU_ucb)
plot(mU_thom)
hold off;

title(name)
legend({'UCB','Thompson'},'Location','SouthEast');
xlabel('Assignments');
ylabel('Average Reward')



