%% Thompson sampling Algorithm
% this function implements Thompson Sampling

function averageReward = Thompson(r,b1,b2)

fail1 = b1(1); 
succ1 = b1(2);

fail2 = b2(1);
succ2 = b2(2);

for i=1:r
    draw = betarnd([],[]);
end

end