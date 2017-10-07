% Particle filter
clear all; close all; clc

% Initial state of the object (image patch) parameters
load('input/pres_debate.txt')
w = pres_debate(2,1); h = pres_debate(2,2); x = pres_debate(1,1); y = pres_debate(1,2);

% Initial prior distribution
mu = [x+floor(w/2),y+floor(h/2)];
sigma = 10*eye(2);
Particles = mvnrnd(mu,sigma,100); 
Weights = mvnpdf(Particles,mu,sigma);

% Get video information
readerobj = VideoReader('input/pres_debate.avi', 'tag', 'myreader1');
vidFrames = read(readerobj);
numFrames = get(readerobj, 'NumberOfFrames');

% Object tracking by particle filter
processNoise_std = 10;
measurementNoise_std = 100;
model = vidFrames(y:y+h-1,x:x+w-1,:,1);
windowSize = [w h];

for k = 1:numFrames
    
    % Read current frame
    frame = vidFrames(:,:,:,k);
    
    % Random sampling according to weight
    Particles = randomSample(Particles,Weights);
    
    % Predict using dynamics
    Particles = predict(Particles,processNoise_std);
    
    % Calculate weights using sensor measurement
    Weights = measurementCorrection(Particles,measurementNoise_std,frame,model);
    Weights = Weights/sum(Weights(:));
    
    % Show particles and estimated state
    show_particles(Particles,frame); 
    show_state_estimated(Particles,Weights,frame,windowSize);
    M(k) = getframe;
    
end
  v = VideoWriter('romneytrack.avi');
  open(v)
  writeVideo(v,M);
  close(v)