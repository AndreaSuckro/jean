%%AB-Testing 
% This script will contain the basics for a 2 cases test. The function
% can later on work with up to n test cases. r specifies the number of
% trials that should be used. ass can take the values 1,2,3 and determines
% the bucket allocation method.
function [sConf,pGreater] = ABTest(n,r,ass)

%default the number of rounds to 1000
if nargin < 3 || ass < 0 || ass > 3
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
X = 0:.01:1;
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
        t1EntDiff = abs(betaEntropy(t1(1),t1(2)) - betaEntropy(t1(1),t1(2)+1));
        t2EntDiff = abs(betaEntropy(t2(1),t2(2)) - betaEntropy(t2(1),t2(2)+1));
        
        if t1EntDiff > t2EntDiff
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
    t1c = num2cell(t1);
    t2c = num2cell(t2);
    fun = @(x) betapdf(x,t1c{:}) .* betacdf(x,t2c{:});
    q = integral(fun,0,1);
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
    end
    
    %decide if there is a success
    if(b == 1) && (binornd(1,0.25) > 0.5)      
        t1(1) = t1(1) + 1;
        
    else
        if(binornd(1,0.35) > 0.5)
            t2(1) = t2(1) + 1;
 
        end
    end
  
end
%% plot the created distributions
X = 0:.01:1;
t1c = num2cell(t1);
t2c = num2cell(t2);
y1 = betapdf(X,t1c{:});
y2 = betapdf(X,t2c{:});
figure
hold on
plot(X,y1,'Color','r','LineWidth',2)
plot(X,y2,'LineStyle','-.','Color','b','LineWidth',2)
legend({'red is t1','blue is t2'},'Location','NorthEast');
hold off
end
