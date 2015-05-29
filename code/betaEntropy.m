%% Entropy for a Beta Distribution
% This is the helper function for the Bucket assignment case with minimized
% entropy.
function ent = betaEntropy(k,N)
    ent = log(beta(k,N)) - (k-1)*psi(k)-(N-1)*psi(N) + (k+N-2)*psi(k+N);
end