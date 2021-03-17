function [compliance,dcompliance] = runOptStep( x, fem )

E = 1e-3 + x.^3*(1 - 1e-3);

% Assemble K
Imat = zeros( 1, fem.n_eq^2 );
Jmat = zeros( 1, fem.n_eq^2 );
Xmat = zeros( 1, fem.n_eq^2 );
ntriplets = 0;
for e = 1:fem.n_el
    Ke = fem.Ke*E(e);
    for a = 1:2^fem.dim
        for b = 1:2^fem.dim
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
                    Xmat(ntriplets) = Ke(fem.elem_ID(j,fem.elem_IEN(1,a)),fem.elem_ID(k,fem.elem_IEN(1,b)));
                end
            end
        end
    end
end

K = sparse( Imat(1:ntriplets), Jmat(1:ntriplets), Xmat(1:ntriplets), fem.n_eq, fem.n_eq );

u = K\fem.F;
compliance = transpose( u )*fem.F;

dcompliance = zeros(size(x));

dE = 3*x.^2*(1 - 1e-3);
for e = 1:fem.n_el
    indices = reshape( fem.ID(1:2,fem.IEN(e,1:2^fem.dim)), 1, [] );
    u_e = u( indices( indices ~= -1 ) );
    dcompliance( e ) = -dE(e)*transpose( u_e )*fem.Ke( indices ~= -1, indices ~= -1 )*u_e;
end