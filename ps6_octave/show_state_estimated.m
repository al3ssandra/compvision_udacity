function show_state_estimated(particles,weights,frame,windowSize)

estimatedState1 = particles(:,1).*weights;
estimatedState2 = particles(:,2).*weights;
estimatedState = [sum(estimatedState1(:)) sum(estimatedState2(:))];

x = round(estimatedState(1)) - floor(windowSize(1)/2);
y = round(estimatedState(2)) - floor(windowSize(2)/2);

figure(1)
image(frame)

hold on
rectangle('position',[x y windowSize(1) windowSize(2)],'EdgeColor','g')
hold off

drawnow

