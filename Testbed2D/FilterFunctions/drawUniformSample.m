function r = drawUniformSample(vmin, vmax, n)
vmax = vmax(:);
vmin = vmin(:);

r = repmat(vmin, 1, n) + repmat((vmax - vmin), 1, n) .* rand(4, n);
end