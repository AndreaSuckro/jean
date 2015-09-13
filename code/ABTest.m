%% Classical A/B Testing 
% This script will contain the basics for a 2 bucket test. 
% r specifies the number of trials that should be used. ass can 
% take the values 1,2,3,4 and determines the bucket allocation method.
% b1 and b2 are the probabilities to generate an action.
function [sConf,pGreater,ent,T1,T2] = ABTest(r,ass,b1,b2)

%default the assignment method to uniform
if nargin < 2 || ass < 0 || ass > 4
    ass = 1;
end

%default the number of rounds to 1000
if nargin < 1 || r < 0
    r =   1000;
end


%% Setting up the Buckets
%this stores the probability that one bucket outperforms the
%other through the runs
pGreater = zeros(r,1);
%allocate same space for the entopy values throughout the test
ent = zeros(r,1);
%the buckets begin with an uninformative prior
t1 = [1,1];
t2 = [1,1];

%this stores the events and non-events per trial per bucket
T1 = zeros(2,r);
T2 = zeros(2,r);


%% Nested Functions for determining the new Bucket
    %this function iterates between the two buckets
    function bucket = uniformAssign
        if t1(2) > t2(2) %take the bucket that was not chosen last time
            bucket = 2;
        else
            bucket = 1;
        end
    end

    %this function uses randi to determine the next assignment
    function bucket = randomAssign
        if round(rand) == 0
            bucket = 2;
        else
            bucket = 1;
        end
    end

    %helper function to determine the entropy between
    %2 beta distributions represented by b1 and b2
    function ent = entropy(b1,b2)
        pB1 = betaGreater(b1,b2);
        pB2 = 1-pB1;
        ent = -pB1*log2(pB1)-pB2*log2(pB2);
    end
    
    %function to get the assignment based on the expected
    %minimization in entropy across the two buckets
    function bucket = minEntropyAssign
        %calculate the case that t1 gets the assignment
        c1 = (t1 + [1 , 0])/(t1(1)+t1(2)+1);
        c2 = 1-c1;
        
        exp1 = c1*entropy(t1+[1 , 0],t2) + c2*entropy(t1+[0 , 1],t2);

        %calculate the case that t2 gets the assignment
        c1 = (t2 + [1 , 0])/(t2(1)+t2(2)+1);
        c2 = 1-c1;
        
        exp2 = c1*entropy(t1,t2+[1 , 0]) + c2*entropy(t1,t2+[0 , 1]);
        
        %takes greedily the better bucket
        if exp1 < exp2
            bucket = 1;
        else
            bucket = 2;
        end
        
    end
    
    %this function workes similar to the entropy assignment but
    %does not always take the better option regulated through a
    %softmax term
    function bucket = softEntropyAssign
        
        %calculate the case that t1 gets the assignment
        c1 = (t1 + [1 , 0])/(t1(1)+t1(2)+1);
        c2 = 1-c1;
        
        exp1 = c1*entropy(t1+[1 , 0],t2) + c2*entropy(t1+[0 , 1],t2);
        
        %calculate the case that t2 gets the assignment
        c1 = (t2 + [1 , 0])/(t2(1)+t2(2)+1);
        c2 = 1-c1;
        
        exp2 = c1*entropy(t1,t2+[1 , 0]) + c2*entropy(t1,t2+[0 , 1]);
        

        T = 500;
        %smooth the decision
        p = exp(exp1/T)/(exp(exp1/T)+exp(exp2/T));
        if rand > p
           bucket = 1;
        else
           bucket = 2;
        end
        
    end

%% Run the Test r times
sConf = 0;

for i=1:r
    %calculate p(t1>t2) 
    q = betaGreater(t1,t2);
    
    % save entropy and p(t1>t2)
    pGreater(i) = q;
    ent(i) =  -q*log2(q)-betaGreater(t2,t1)*log2(betaGreater(t2,t1));    
    
    %check if confidence is reached in this trial
    if (sConf == 0 && (q > 0.95 || q < 0.05))
        sConf = i;
    end
    
    %decide what bucket to take dependent on the assignment value
    switch ass
        case 1
            b = uniformAssign;
        case 2
            b = randomAssign;
        case 3
            b = minEntropyAssign;
        case 4
            b = softEntropyAssign;
    end
    
    %decide if there is a success
    if(b == 1)
        if(rand < b1)
            t1 = t1 + [1 , 0]; %record event
        else
            t1 = t1 + [0 , 1]; %record failure
        end
    else
        if(rand < b2)
            t2 = t2 + [1 , 0]; %record event
        else
            t2 = t2 + [0 , 1]; %record failure
        end
    end
    
    %save the bucket state
    T1(:,i)= t1;
    T2(:,i)= t2;
  
end

end
