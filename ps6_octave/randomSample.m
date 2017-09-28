function S = randomSample(particlesLocation, weights)

% Sample with replacement
N = numel(weights);
indexSamples = randsample(N,N,true,weights);
S = particlesLocation(indexSamples,:);

end