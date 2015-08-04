%% Bandit Algorithm UCB
% This function implements the Uniform Confidence Bounds algorithm
% for the Assignment strategy of an A/B-Test
function [avgReward,rewards,choices] = UCB(r,b1,b2)

%default the number of rounds to 1000
if nargin < 1 || r < 0
    r =   1000;
end

%% Running the test
rewards = zeros(2,r);
machPlays = [0,0];
cumReward = 0;

avgReward = zeros(1,r);
totalReward = zeros(1,r);
choices = zeros(1,r);

%Play the machines
indMin1 = 1;
for i = 1:r
    meanEst1 = mean(rewards(1,1:i)) + sqrt(2*log(i)/machPlays(1)); 
    meanEst2 = mean(rewards(2,1:i)) + sqrt(2*log(i)/machPlays(2));
    
    if meanEst1 > meanEst2
        machPlays(1) = machPlays(1) + 1;
        rew = betarnd(b1(1),b1(2));
        rewards(1,i) = rew;
        choice = 1;
    else
        machPlays(2) = machPlays(2) + 1;
        rew = betarnd(b2(1),b2(2));
        rewards(2,i) = rew;
        choice = 2;
    end
    
    cumReward = cumReward + rew;
    
    %get previous reward if applicable
    if i > 1
        indMin1 = i - 1;
    end
    
    totalReward(i) = totalReward(indMin1) + rew;
    avgReward(i) = 1/i*(rew + indMin1*avgReward(indMin1));
    choices(i) = choice;
    
end



end