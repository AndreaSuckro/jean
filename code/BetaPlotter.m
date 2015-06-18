%% Script for plotting beta distributions
close all;
clear variables;

X = 0:0.01:1;
t = betapdf(X,10,20);

figure
plot(X,t)