%% Thompson sampling Algorithm
% This function implements Thompson Sampling. r is used to determine
% the number of rounds to be played and b1 and b2 are the real
% Bucket distributions for the test.
function avgReward = Thompson(r,b1,b2)

estB1 = [1,1];
estB2 = [1,1];

avgReward = zeros(1,r);
totalReward = zeros(1,r);

indMin1 = 1;
for i=1:r
    %use our estimate for draw
    draw1 = betarnd(estB1(1),estB1(2));
    draw2 = betarnd(estB2(1),estB2(2));
    
    if draw1 > draw2
        %pull lever 1 with b1 distribution
        rew = betarnd(b1(1),b1(2)); %reward bounded by 1!
        if round(rew) == 1
            estB1(1) = estB1(1) + 1;
        else
            estB1(2) = estB1(2) + 1;
        end
            
    else
        %pull lever 2 with b2 distribution
        rew = betarnd(b2(1),b2(2)); %rew bounded by 1!
        if round(rew) == 1
            estB2(1) = estB2(1) + 1;
        else
            estB2(2) = estB2(2) + 1;
        end
    end
    
    if i > 1
        indMin1 = i - 1;
    end
    
    %record reward of draw
    totalReward(i) = totalReward(indMin1) + rew;
    avgReward(i) = 1/i*(rew + indMin1*avgReward(indMin1));
end

end