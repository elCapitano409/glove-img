%{
% GLOVETRACK.m
% Kyle Inzunza
%}

tic;

pos1 = birdtrack('IONX0051'); %get data from first camera
pos3 = cordtrack('IONX0054'); %get data from third camera

toc;
