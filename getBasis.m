function B = getBasis

quad = getQuadPoints;
dim = 2;
n_qpts = size(quad,1);
n_basisfuncs = 2^dim;
n_evals = ( 1 + dim );
B = zeros( n_basisfuncs, n_evals * n_qpts );

for i = 1:n_qpts
    B( :, n_evals*(i-1)+1:n_evals*i ) = ...
        [1/4*(1-quad(i,1))*(1-quad(i,2)),-1/4*(1-quad(i,2)),-1/4*(1-quad(i,1))
		 1/4*(1+quad(i,1))*(1-quad(i,2)),1/4*(1-quad(i,2)),-1/4*(1+quad(i,1))
		 1/4*(1-quad(i,1))*(1+quad(i,2)),-1/4*(1+quad(i,2)),1/4*(1-quad(i,1))
         1/4*(1+quad(i,1))*(1+quad(i,2)),1/4*(1+quad(i,2)),1/4*(1+quad(i,1))];
end
