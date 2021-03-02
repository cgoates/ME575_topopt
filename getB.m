function B = getB( a, N_x )
B = [ N_x(a,1), 0; 0, N_x(a,2); N_x(a,2), N_x(a,1) ];
end