function fem = initializeTopOpt( nx, ny, Lx, Ly )
fem.n_el = nx * ny;
n_nodes = (nx + 1) * (ny + 1);

fem.nu = 0.3;
fem.dim = 2;


fem.Nodes = getNodePositions( Lx, Ly, nx, ny );
%inspectNodes( fem.Nodes );
fem.IEN = getIEN( fem.n_el, nx );

fem.quad = getQuadPoints;

fem.N = getBasis;

[has_constr, ~] = cantileverConstraints( nx, ny );
[has_loads, loads] = cantileverLoads( nx, ny );

fem.ID = getID( has_constr );

fem.n_eq = max( max( fem.ID ) );

% Assuming linear parameterization
xe = fem.Nodes( :, fem.IEN( 1, : ) );
i = 1;
N_ind = (i-1)*(fem.dim+1)+1:i*(fem.dim+1);
[~,Jac] = getGeom( fem.N(:,N_ind), xe );
fem.J = det( Jac );
fem.JacInv = Jac^(-1);

fem = getElementStiffness( fem );

% Assemble F
fem.F = zeros( fem.n_eq, 1 );
for i = 1:fem.dim
    for j = 1:n_nodes
        if fem.ID(i,j) == -1 || ~has_loads(i,j)
            continue;
        end
        fem.F( fem.ID(i,j) ) = loads(i,j);
    end
end