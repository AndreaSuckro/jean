%% Script for testing Bandits
% Implementation of epsilon greedy algorithm. Epsi is the fractions 
% or runs we explore and runs the number of over all runs.
function avgReward = EpsilonGreedy(epsi,runs,b1,b2)


avgReward = zeros(1,runs);
totalReward = zeros(1,runs);
choices = zeros(2,1);

%create rewards for the machines
m = zeros(2,runs);
m(1,:) = betarnd(b1(1),b1(2),runs,1);
m(2,:) = betarnd(b2(1),b2(2),runs,1);

pickedRewards = zeros(2,1);

for i=1:runs
    
    %determine if exploration or exploitation
    x = rand;
    indBef = 1;
    
    if x < epsi
        %explore!
        choice = round(rand+1);
        reward = m(choice,i);
    else
        %exploit!
        %if mean(m(1,1:i)) > mean(m(2,1:i))
        if pickedRewards(1)/choices(1) >= pickedRewards(2)/choices(2)
            reward = m(1,i);
            choice = 1;
        else
            reward = m(2,i);
            choice = 2;
        end
        
    end
    
    %get previous reward if applicable
    if i > 1
        indBef = i - 1;
    end
    
    totalReward(i) = totalReward(indBef) + reward;
    avgReward(i) = 1/i*(reward + indBef*avgReward(indBef));
    pickedRewards(choice) = pickedRewards(choice) + reward;
    choices(choice) = choices(choice) + 1;
end

end
