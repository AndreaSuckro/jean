%% Script for testing sampling
% This is described in chapter 2.2.3
close all;
clear variables;

%% Setting up 2 buckets
X = 0:0.01:1;
assign = 200;
success1 = randi(10);
failure1 = assign - success1;

success2 = randi(10);
failure2 = assign - success2;

bucket1 = betapdf(X,success1,failure1);
bucket2 = betapdf(X,success2,failure2);

disp(['Bucket1 values: ' mat2str([success1,failure1])])
disp(['Bucket2 values: ' mat2str([success2,failure2])])

%% Simulation
numSamp = 20000;
sampRes = zeros(1,2);
for i = 1:numSamp
    if betarnd(success1,failure1) > betarnd(success2,failure2)
        sampRes = sampRes + [1,0];
    else
        sampRes = sampRes + [0,1];
    end
end

b1 = sampRes(1)/numSamp;
b2 = sampRes(2)/numSamp;
disp(['Probability that bucket 1 is better: ' num2str(b1)])
disp(['Analytic Probability for that: ' num2str(betaGreater([success1,failure1],[success2,failure2]))])

disp(['Probability that bucket 2 is better: ' num2str(b2)])
disp(['Analytic Probability for that: ' num2str(betaGreater([success2,failure2],[success1,failure1]))])

%% Plot the Buckets Distribution
figure
hold on
plot(X,bucket1);
plot(X,bucket2);
hold off