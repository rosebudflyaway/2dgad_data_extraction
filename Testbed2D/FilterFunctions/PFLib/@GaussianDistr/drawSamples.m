function X = drawSamples(gDistr, totalNum)

switch nargin
 case 1,
  totalNum = 1;
 case 2,
 otherwise,
  error('wrong number of arguments');
end;

X = gDistr.UsqrtT * randn(gDistr.n, totalNum) + repmat(gDistr.mean, ...
						  1, totalNum);
