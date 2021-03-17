function [fem] = getElementStiffness( fem )
D = getD( 10, fem.nu );
n_qpts = 2^fem.dim;
n_nodes = 4;
IEN = getIEN( 1, 1 );
has_constr = ( zeros( fem.dim, n_nodes ) == 1 );
ID = getID( has_constr );
n_eq = max( max( ID ) );
Imat = zeros( 1, n_eq^2 );
Jmat = zeros( 1, n_eq^2 );
Xmat = zeros( 1, n_eq^2 );
ntriplets = 0;
e = 1;
for i = 1:n_qpts
    N_ind = (i-1)*(fem.dim+1)+1:i*(fem.dim+1);
    N_x = fem.N(:,N_ind(2:end))*fem.JacInv;

    for a = 1:2^fem.dim
        B_A = getB(a,N_x);
        for b = 1:2^fem.dim
            B_B = getB(b,N_x);

            ke_ab = ( B_A'*D*B_B ) * fem.J * fem.quad(i,3);

            for j = 1:fem.dim
                for k = 1:fem.dim
                    ntriplets = ntriplets + 1;
                    Imat(ntriplets) = ID(j,IEN(e,a));
                    Jmat(ntriplets) = ID(k,IEN(e,b));
                    Xmat(ntriplets) = ke_ab(j,k);
                end
            end
        end
    end
end
fem.Ke = sparse( Imat(1:ntriplets), Jmat(1:ntriplets), Xmat(1:ntriplets), n_eq, n_eq );
fem.elem_ID = ID;
fem.elem_IEN = IEN;
end