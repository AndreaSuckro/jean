%% Bandit Algorithm UCB
% This function implements the Uniform Confidence Bounds algorithm
% for the Assignment strategy of an A/B-Test
function [sConf,pGreater,ent,T1,T2] = UCB(r,b1,b2)

%default the number of rounds to 1000
if nargin < 1 || r < 0
    r =   1000;
end

%% Running the test
%Chernoff-Hoeffding Bound:
P( estimate > trueB + a) <= 1 / exp(2 * a^(2*r))
true_mean(bucket) <= avg[bucket] + sqrt( 2 ln(r) / num_plays[bucket] )

Play each machine once.

while True:
    best_possible_true_mean = { m -> avg[m] + sqrt( 2 ln(N) / num_plays[m] ) }
        // This is pseudocode for a "dict comprehension"
        // I.e. best_possible_true_mean[m] = avg[m] + ...
        to_play = argmax(best_possible_true_mean)
        reward <- play_machine(to_play)

        update avg[to_play], num_plays[m], N

end