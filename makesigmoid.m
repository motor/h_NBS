function v = sigmoid(params,range)

% Sigmoid creates a Sigmoid function using parameters in PARAMS and the 
% variable range.
% 
% V = SIGMOID(PARAMS,RANGE)
%
% PARAMS: a 3-vector, the entries of which are (in this order):
% amplitude value 
% 
% phase
% slope

amplitude = params(1);
Phase=params(2);
Slope=params(3);
%a=params(4);



v=1./(1+Phase*exp(-Slope*(range)));
