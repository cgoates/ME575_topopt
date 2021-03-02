function [x,Jac] = getGeom(N,xe)

x = xe*N(:,1);
Jac = xe*N(:,2:end);

end