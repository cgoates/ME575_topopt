function [has_constr, constraints] = cantileverConstraints( nx, ny )

dim = 2;
n_nodes = (nx + 1) * (ny + 1);

allNodes = 0:n_nodes;
constraints = zeros( dim, n_nodes );
has_constr = ( zeros( dim, n_nodes ) == 1 );

x0EdgeNodes = (mod( allNodes, nx + 1 ) == 0) & ( allNodes <= nx + 1 );

has_constr(:,x0EdgeNodes) = true;

end