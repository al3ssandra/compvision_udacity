%Recognition using MHI
%Obtain descriptors for all actions
clear all; close all; clc;

readerobjA1 = VideoReader('input/PS7A1P1T1.avi');
tA1 = 60;
actionStopA1 = 100;
descA1 = MHIdesc(readerobjA1,tA1,actionStopA1);

readerobjA2 = VideoReader('input/PS7A2P1T1.avi');
tA2 = 50;
actionStopA2 = 70;
descA2 = MHIdesc(readerobjA2,tA2,actionStopA2);

readerobjA3 = VideoReader('input/PS7A3P1T1.avi');
tA3 = 80;
actionStopA3 = 100;
descA3 = MHIdesc(readerobjA3,tA3,actionStopA3);