%Recognition Using Nearest Neighbours

%Recognition using MHI
%Obtain model for each action
clear all; close all; clc;

readerobjA1 = VideoReader('input/PS7A1P1T1.avi');
tA1 = 60;
actionStopA1 = 100;
[modelA1_CM, modelA1_SI] = MHIdesc(readerobjA1,tA1,actionStopA1);

readerobjA2 = VideoReader('input/PS7A2P1T1.avi');
tA2 = 50;
actionStopA2 = 70;
[modelA2_CM, modelA2_SI] = MHIdesc(readerobjA2,tA2,actionStopA2);

readerobjA3 = VideoReader('input/PS7A3P1T1.avi');
tA3 = 80;
actionStopA3 = 100;
[modelA3_CM, modelA3_SI] = MHIdesc(readerobjA3,tA3,actionStopA3);

%Obtain Descriptors for all the videos of each action
%Action 1
videoFiles = dir('input/ps7A1*');
[CM_dataA1, SI_dataA1] = dataDescriptors(videoFiles);

%Action 2
videoFiles = dir('input/ps7A2*');
[CM_dataA2, SI_dataA2] = dataDescriptors(videoFiles);

%Action 3
videoFiles = dir('input/ps7A3*');
[CM_dataA3, SI_dataA3] = dataDescriptors(videoFiles);