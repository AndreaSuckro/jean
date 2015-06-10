
%% Script for testing the other code
close all;
clear variables;

runs = 30;
assignments = 200;
%calculate r times


%plot the different assignment methods
figure
hold on;

uniformData = zeros(assignments,runs);
randomData = zeros(assignments,runs);

for n = 1:runs
    [sConf,pGreater] = ABTest(2,assignments,1);
    uniformData(:,n) = pGreater;


    [sConf2,pGreater2] = ABTest(2,assignments,2);
    randomData(:,n) = pGreater2;
end

plot(max(uniformData,2));
plot(min(uniformData,2));

%[sConf3,pGreater3] = ABTest(2,300,3);
plot(mean(uniformData,2));
plot(mean(randomData,2));
%plot(pGreater3);
hold off;

title('Bucket Assignments');
xlabel('Assignments');
ylabel('P(Bucket1>Bucket2)')
legend({'uniform','random','entropy'},'Location','NorthEast');
