
%% Script for testing the other code
clc;
close all;
clear variables;
%clear betaGreater;


%parpool open 4
%parpool close

runs = 100;
assignments = 150;

fprintf('Run Tests %d times with %d assignments...\n',runs,assignments);
%% Calculation
uniformData = zeros(assignments,runs);
randomData = zeros(assignments,runs);
entropyData = zeros(assignments,runs);
differenceData = zeros(assignments,runs);

parfor n = 1:runs
    
    b1 = rand;
    b2 = rand;
    
    [sConf,pGreater] = ABTest(2,assignments,1,b1,b2);
    uniformData(:,n) = pGreater;

    [sConf2,pGreater2] = ABTest(2,assignments,2,b1,b2);
    randomData(:,n) = pGreater2;
    
    [sConf3,pGreater3] = ABTest(2,assignments,3,b1,b2);
    entropyData(:,n) = pGreater3;
    
    [sConf4,pGreater4] = ABTest(2,assignments,4,b1,b2);
    differenceData(:,n) = pGreater4;
end

%% Plot the different assignment methods
disp('Start plotting ...')
figure('name','Comparison of Assignment Strategies')
%hold on;
x = 1:1:assignments;
X = [x,fliplr(x)];

ax1 = subplot(2,2,1);
hold on
% plot the uniform Data
stdU =  std(uniformData,0,2);
mU = mean(uniformData,2);
y1 = (mU + stdU)';
y2 = (mU - stdU)';

Ym = [y1,fliplr(y2)];
fill(X,Ym,[.93 .69 .13]);
%set(h,'facealpha',.5)
plot(mU);
hold off;
title('Equal Assignment')
legend({'std interval','avg'},'Location','SouthEast');
xlabel('Assignments');
ylabel('P(Bucket1>Bucket2)')


%plot the random Data
ax2 = subplot(2,2,2);
hold on
stdR =  std(randomData,0,2);
mR = mean(randomData,2);
y1 = (mR + stdR)';
y2 = (mR - stdR)';

Ym = [y1,fliplr(y2)];
h = fill(X,Ym,[.68 .92 1]);
set(h,'facealpha',.5)
plot(mR);
hold off;
title('Random Assignment')
legend({'std interval','avg'},'Location','SouthEast');
xlabel('Assignments');
ylabel('P(Bucket1>Bucket2)')

%plot the entropy Data
ax3 = subplot(2,2,3);
hold on
stdR =  std(entropyData,0,2);
mR = mean(entropyData,2);
y1 = (mR + stdR)';
y2 = (mR - stdR)';

Ym = [y1,fliplr(y2)];
h = fill(X,Ym,[.47 .69 .19]);
set(h,'facealpha',.5)
plot(mR);
hold off;
title('Entropy Assignment')
legend({'std interval','avg'},'Location','SouthEast');
xlabel('Assignments');
ylabel('P(Bucket1>Bucket2)')

%plot the entropy Data
ax4 = subplot(2,2,4);
hold on
stdR =  std(differenceData,0,2);
mR = mean(differenceData,2);
y1 = (mR + stdR)';
y2 = (mR - stdR)';

Ym = [y1,fliplr(y2)];
h = fill(X,Ym,[.47 .69 .19]);
set(h,'facealpha',.5)
plot(mR);
hold off;
title('Difference Assignment')
legend({'std interval','avg'},'Location','SouthEast');
xlabel('Assignments');
ylabel('P(Bucket1>Bucket2)')



linkaxes([ax1,ax2,ax3,ax4],'xy')
ylim([0 1])



