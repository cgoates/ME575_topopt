function D = getD( E, nu )

G = E / ( 2 * ( 1 + nu ) );
lambda = E * nu / ( ( 1 + nu ) * ( 1 - 2 * nu ) );

D = [ lambda + 2 * G, lambda, 0
    lambda, lambda + 2 * G, 0
    0, 0, G];
end