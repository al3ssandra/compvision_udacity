function show_particles(particles,frame)

figure(1)
image(frame)

hold on
plot(particles(:,1), particles(:,2), '.')
hold off

drawnow