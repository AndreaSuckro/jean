%%AB-Testing 
% This script will contain the basics for a 2 cases test. The function
% can later on work with up to n test cases. r specifies the number of
% trials that should be used. ass can take the values 1,2,3 and determines
% the bucket allocation method.
function [sConf,pGreater] = ABTest(n,r,ass)

%default the number of rounds to 1000
if nargin < 3 || ass < 0 || ass > 4
    ass = 1;
end
%default the number of rounds to 1000
if nargin < 2 || r < 0
    r =   1000;
end
%if there are no buckets given default to 2
if nargin < 1 || n < 2
    n =   2;
end

%% Setting up the Buckets
%The interval to sample from
pGreater = zeros(r,1);

%The buckets begin with a flat prior
t1 = [1,1];
t2 = [1,1];


%% Nested Functions for determining the new Bucket
    %This function iterates between the two buckets
    function bucket = uniformAssign
        if t1(2) > t2(2)
            t2(2) = t2(2) + 1;
            bucket = 2;
        else
            t1(2) = t1(2) + 1;
            bucket = 1;
        end
    end

    %This function uses randi to determine the next Assignment
    function bucket = randomAssign
        if round(rand) == 0
            t2(2) = t2(2) + 1;
            bucket = 2;
        else
            t1(2) = t1(2) + 1;
            bucket = 1;
        end
    end

    function bucket = minEntropyAssign
        %calculate entropy difference for both buckets
        t1m = t1;
        t1m(1) = t1m(1) + 1;
        t1m(2) = t1m(2) + 1;
        
        %leave t2 as it is
        ent1 =  -betaGreater(t1m,t2)*log2(betaGreater(t1m,t2))-betaGreater(t2,t1m)*log2(betaGreater(t2,t1m));
        
        t2m = t2;
        t2m(1) = t2m(1) + 1;
        t2m(2) = t2m(2) + 1;
        
        ent2 = - betaGreater(t1,t2m) * log2(betaGreater(t1,t2m))- betaGreater(t2m,t1) * log2(betaGreater(t2m,t1));
        
        %weight entropy by click probability
        c1 = t1(1)/t1(2);
        c2 = t2(1)/t2(2);
        
        %if c1*ent1 < c2*ent2
        if ent1 < ent2
            t1(2) = t1(2) + 1;
            bucket = 1;
        else
            t2(2) = t2(2) + 1;
            bucket = 2;
        end
        
    end

    function bucket = maxDifferenceAssign
        %calculate entropy difference for both buckets
        t1m = t1;
        t1m(1) = t1m(1) + 1;
        t1m(2) = t1m(2) + 1;
        
        %leave t2 as it is
        bigger1 =  betaGreater(t1m,t2);
        
        t2m = t2;
        t2m(1) = t2m(1) + 1;
        t2m(2) = t2m(2) + 1;
        
        bigger2 = betaGreater(t2m,t1);
        
        c1 = t1(1)/t1(2);
        c2 = t2(1)/t2(2);
        
        %if c1*ent1 < c2*ent2
        if abs(bigger1-0.5) > abs(bigger2-0.5)
            t1(2) = t1(2) + 1;
            bucket = 1;
        else
            t2(2) = t2(2) + 1;
            bucket = 2;
        end
        
    end

%% Run the Test r times
%run the test n times
sConf = 0;
for i=1:r
    
    %calculate P(t1>t2) 
    q = betaGreater(t1,t2);
    pGreater(i) = q;
    
    if (sConf == 0 && (q > 0.95 || q < 0.05))
        sConf = i;
    end
    
    %decide what bucket to take
    switch ass
        case 1
            b = uniformAssign;
        case 2
            b = randomAssign;
        case 3
            b = minEntropyAssign;
        case 4
            b = maxDifferenceAssign;
    end
    
    %decide if there is a success
    if(b == 1) 
        if(binornd(1,0.55) > binornd(1,0.25))      
            t1(1) = t1(1) + 1;
        end
    else
        if(binornd(1,0.25) > binornd(1,0.55))
            t2(1) = t2(1) + 1;
        end
    end
  
end

end
