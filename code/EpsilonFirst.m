%% Script for testing Bandits
% Implementation of epsilon first algorithm. Epsi is the fractions 
% or runs we explore and runs the number of over all runs.
function avgReward = EpsilonFirst(epsi,runs,b1,b2)


avgReward = zeros(1,runs);
totalReward = zeros(1,runs);
choices = zeros(1,runs);

%create rewards for the machines
m = zeros(2,runs);
m(1,:) = betarnd(b1(1),b1(2),runs,1);
m(2,:) = betarnd(b2(1),b2(2),runs,1);


for i=1:runs
    
    %determin if exploration or exploitation
    indBef = 1;
    
    if i < epsi*runs
        %explore!
        choice = round(rand+1);
        reward = m(choice,i);
    else
        %exploit!
        if mean(m(1,1:i)) > mean(m(2,1:i))
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
    choices(i) = choice;
end

end
