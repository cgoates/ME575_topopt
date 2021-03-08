function [compliance] = runOptStep( x, fem )

E = 1e-3 + x.^3*(1 - 1e-3);

% Assemble K
n_qpts = 2^fem.dim;
K = sparse( fem.n_eq, fem.n_eq );
Imat = zeros( 1, fem.n_eq^2 );
Jmat = zeros( 1, fem.n_eq^2 );
Xmat = zeros( 1, fem.n_eq^2 );
ntriplets = 0;
for e = 1:fem.n_el
    D = getD( 10*E(e), fem.nu );
    for i = 1:n_qpts
        N_ind = (i-1)*(fem.dim+1)+1:i*(fem.dim+1);
        N_x = fem.N(:,N_ind(2:end))*fem.JacInv;
        
        for a = 1:2^fem.dim
            B_A = getB(a,N_x);
            for b = 1:2^fem.dim
                B_B = getB(b,N_x);
                
                ke_ab = ( B_A'*D*B_B ) * fem.J * fem.quad(i,3);
                
                for j = 1:fem.dim
                    if fem.ID(j,fem.IEN(e,a)) == -1
                        continue;
                    end
                    
                    for k = 1:fem.dim
                        if fem.ID(k,fem.IEN(e,b)) == -1
                            continue;
                        end
                        ntriplets = ntriplets + 1;
                        Imat(ntriplets) = fem.ID(j,fem.IEN(e,a));
                        Jmat(ntriplets) = fem.ID(k,fem.IEN(e,b));
                        Xmat(ntriplets) = ke_ab(j,k);
                    end
                end
            end
        end
    end
end

K = sparse( Imat(1:ntriplets), Jmat(1:ntriplets), Xmat(1:ntriplets), fem.n_eq, fem.n_eq );

du = K\fem.F;
compliance = transpose( du )*fem.F;