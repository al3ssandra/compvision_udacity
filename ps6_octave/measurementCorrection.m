function Weights = measurementCorrection(particles,MSEstd,frame,model)

    X = round(particles);
    N = size(particles,1);
    width = size(model,2);
    height = size(model,1);
    std2 = MSEstd^2;
    
    for i = 1:N
        
        row = X(i,2); col = X(i,1);
        window = frame(row-floor(height/2):row+floor(height/2)-mod(height-1,2),col-floor(width/2):col+floor(width/2)-mod(width-1,2),:);
        MSE = (model - window).^2;
        MSE = sum(MSE(:));
        Weights(i) = exp(-MSE/(2*std2));
        
    end
    Weights = Weights';
end