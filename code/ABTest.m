%%AB-Testing 
% This script will contain the basics for a 2 cases test. The function
% can later on work with up to n test cases. r specifies the number of
% trials that should be used. ass can take the values 1,2,3 and determines
% the bucket allocation method.
function [sConf,pGreater,ent,T1,T2] = ABTest(n,r,ass,b1,b2)

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

T1 = zeros(2,r);
T2 = zeros(2,r);


%% Nested Functions for determining the new Bucket
    %This function iterates between the two buckets
    function bucket = uniformAssign
        if t1(2) > t2(2)
            bucket = 2;
        else
            bucket = 1;
        end
    end

    %This function uses randi to determine the next Assignment
    function bucket = randomAssign
        if round(rand) == 0
            %t2(2) = t2(2) + 1;
            bucket = 2;
        else
            %t1(2) = t1(2) + 1;
            bucket = 1;
        end
    end

    function ent = entropy(b1,b2)
        pB1 =betaGreater(b1,b2);
        pB2 = 1-pB1;
        ent =  -pB1*log2(pB1)-pB2*log2(pB2);
        
    end

    function bucket = minEntropyAssign()
        
        
        c1 = (t1 + [1 , 0])/(t1(1)+t1(2)+2);
        c2 = 1-c1;
        
        %leave t2 as it is
        exp1 =  c1*entropy(t1+[1 , 0],t2) + c2*entropy(t1+[0, 1],t2);

        
        c1 = (t2 + [1 , 0])/(t2(1)+t2(2)+2);
        c2 = 1-c1;
        
        exp2 =  c1*entropy(t1,t2+[1 , 0]) + c2*entropy(t1,t2+[0, 1]);
        
        if exp1 < exp2
            %t1(2) = t1(2) + 1;
            bucket = 1;
        else
            %t2(2) = t2(2) + 1;
            bucket = 2;
        end
        
    end

    function bucket = softEntropyAssign
        
        c1 = (t1 + [1 , 0])/(t1(1)+t1(2)+2);
        c2 = 1-c1;
        
        %leave t2 as it is
        exp1 =  c1*entropy(t1+[1 , 0],t2) + c2*entropy(t1+[0, 1],t2);
        %exp1 = entro-exp1;
        
        c1 = (t2 + [1 , 0])/(t2(1)+t2(2)+2);
        c2 = 1-c1;
        
        exp2 =  c1*entropy(t1,t2+[1 , 0]) + c2*entropy(t1,t2+[0, 1]);
        %exp2 = entro-exp2;

        T=500;
        p = exp(T*exp1)/(exp(T*exp1)+exp(T*exp2));
        if rand > p
           bucket = 1;
        else
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
    
    ent(i) =  -betaGreater(t1,t2)*log2(betaGreater(t1,t2))-betaGreater(t2,t1)*log2(betaGreater(t2,t1));
        
    
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
            b = minEntropyAssign(i);
        case 4
            b = softEntropyAssign;
    end
    
    %decide if there is a success
    if(b == 1) 
        if(rand < b1)      
            t1 = t1 + [1 , 0];
        else
            t1 = t1 + [0 , 1];
        end
    else
        if(rand < b2)
            t2 = t2 + [1 , 0];
        else
            t2 = t2 + [0 , 1];
        end
    end
    
    T1(:,i)= t1;
    T2(:,i)= t2;
  
end

end
