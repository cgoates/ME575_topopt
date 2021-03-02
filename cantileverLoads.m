function [has_loads, loads] = cantileverLoads( nx, ny )

dim = 2;
n_nodes = (nx + 1) * (ny + 1);

allNodes = 0:n_nodes;
loads = zeros( dim, n_nodes );
has_loads = ( zeros( dim, n_nodes ) == 1 );

xLEdgeNodes = mod( allNodes, nx + 1 ) == nx;

has_loads(2,xLEdgeNodes) = true;
loads(2,xLEdgeNodes) = -1;

end