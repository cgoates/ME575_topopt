function Nodes = getNodePositions( Lx, Ly, nx, ny )
dim = 2;
Nodes = zeros( dim, (nx+1)*(ny+1) ); 

s_x = Lx/(nx + 1);
s_y = Ly/(ny + 1);

for j = 0:ny
    for i = 0:nx
        Nodes(:,j*(nx+1)+i+1) = [i*s_x, j*s_y];
    end
end