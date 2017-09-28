function update = predict(X,X_std)

% Predicted particles are just x_t-1 + noise
update = X + X_std*randn(size(X));

end