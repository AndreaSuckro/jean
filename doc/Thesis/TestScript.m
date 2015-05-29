
%%
close all;
clear all;
% reeinforcement learning sutton ,barto
% michael littman 

%plot the different assignment methods
figure

[sConf,pGreater] = ABTest(2,300,1);
[sConf2,pGreater2] = ABTest(2,300,2);
[sConf3,pGreater3] = ABTest(2,300,3);
plot(pGreater);
hold on;
plot(pGreater2);
plot(pGreater3);
hold off;

title('Bucket Assignments');
xlabel('Assignments');
ylabel('P(Bucket1>Bucket2)')
legend({'uniform','random','entropy'},'Location','NorthEast');
