%% P(X>Y) for 2 Beta Distributions
% This helper function calculates P(X>Y) by using recurrent values.

function prob = betaGreater(t1,t2)
    
    persistent lookup;
   
    %initialize lookuptable
    if isempty(lookup)
       disp('Start initializing table...')
       lookup = add_slow(t1,t2,lookup);
       disp('finished...')
    end
    

    prob = g(t1(1),t1(2),t2(1),t2(2),lookup);
    
    %if the propability could not be found
    if isempty(prob)
       lookup = add_slow(t1,t2,lookup);
       prob = g(t1(1),t1(2),t2(1),t2(2),lookup);
    end
    
end

%% Init the old way without symmetries.
function lookup = add_slow(t1,t2,lookup)
   %fprintf('Calc missing probability for  TestA %d %d, TestB %d %d \n\n',t1(1),t1(2),t2(1),t2(2));
   lookup = [lookup; add_table(t1, t2)];
end

function lookup = add_table(t1,t2)
    t1c = num2cell(t1);
    t2c = num2cell(t2);
    fun = @(x) betapdf(x,t1c{:}) .* betacdf(x,t2c{:});
    prob = integral(fun,0,1);
    P = prob;
    lookup = table(t1, t2, P);
end

%% LookUp in the table 
function prob = g(a,b,c,d,lookup)
    % using existing probability
    rows = ...
        bsxfun(@and, ...
            bsxfun(@and, lookup.t1(:,1) == a, lookup.t1(:,2) == b),...
            bsxfun(@and, lookup.t2(:,1) == c, lookup.t2(:,2) == d)...
        );
    prob = lookup.P(rows);
    %fprintf('Prob from table  = %d for %d,%d,%d,%d\n',prob,a,b,c,d);
end

%% Algorithms form the Cook paper
function h = H(a,b,c,d)
    %TODO: implement
    h = 0;
end

function init(r,lookup)
     % init columns - maybe store values?
     disp('Init lookup table for <r> assignments');
     a = 1;
     b = 1;
     c = 1;
     d = 1;
     t1 = [a,b];
     t2 = [c,d];
     P = 0.5;
     lookup = table(t1,t2,P);
     %  g(a, b, c, d) = 1 – g(c, d, a, b)
     %  g(a, b, c, d) = g(d, c, b, a)
     %  g(a, b, c, d) = g(d, b, c, a)
     for i = 1:r
        ai = a + 1;
        bi = b + 1;
        ci = c + 1;
        di = d + 1;
        
        t1 = [ai,b];
        t2 = [c,d];
        
        %calc with symmetry
        gABCD = g(a,b,c,d,lookup);
        hABCD = h(a,b,c,d);
        
        val = gABCD + hABCD/a;
        lookup = [lookup; table(t1, t2, val)];
        
        t1 = [a,bi];
        
        val = gABCD + hABCD/b;
        lookup = [lookup; table(t1, t2, val)];
        
        t1 = [a,b];
        t2 = [ci,d];
        
        val = gABCD + hABCD/c;
        lookup = [lookup; table(t1, t2, val)];
        
        t2 = [c,di];
        
        val = gABCD + hABCD/d;
        lookup = [lookup; table(t1, t2, val)];
        
        a = a + 1;
        b = b + 1;
     end
    
     disp('Table created.');
end