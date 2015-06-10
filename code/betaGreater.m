%% P(X>Y) for 2 Beta Distributions
% This helper function calculates P(X>Y) by using recurrent values.
function prob = betaGreater(t1,t2)
    
    persistent lookup;
    %initialize lookuptable
    if isempty(lookup)
        % init columns - maybe store values?
        disp('Init lookup table');
        t1c = num2cell(t1);
        t2c = num2cell(t2);
        fun = @(x) betapdf(x,t1c{:}) .* betacdf(x,t2c{:});
        prob = integral(fun,0,1);
        P = prob;
        lookup = table(t1,t2,P);
        disp('Table created.');
        return
    end
    
    % using existing probability
    rows = ...
        bsxfun(@and, ...
            bsxfun(@and, lookup.t1(1) == t1(1), lookup.t1(2) == t1(2)),...
            bsxfun(@and, lookup.t2(1) == t2(1), lookup.t2(2) == t2(2))...
        );
    prob = lookup.P(rows);
    
    %if the propability could not be found
    if isempty(prob)
        t1c = num2cell(t1);
        t2c = num2cell(t2);
        fun = @(x) betapdf(x,t1c{:}) .* betacdf(x,t2c{:});
        prob = integral(fun,0,1);
        P = prob;
        lookup = [lookup; table(t1, t2, P)];
    end
    
end