function xstar = FEM_Main

% Parameters to set:
num_elems_x = 20;
num_elems_y = 4;
Lx = 1;
Ly = 0.1;
volfrac = 0.5; % Fraction of the volume to fill

fem = initializeTopOpt( num_elems_x, num_elems_y, Lx, Ly );

% The constraint is that the sum of x is volfrac*n_el.  This is an easy
% starting place that satisfies the constraints.
x0 = volfrac*ones(1,fem.n_el);

function o = objective( x )
    o = runOptStep( x, fem )/3e5;
end

objective( x0 )

options = optimoptions('fmincon', ...
        'Display', 'iter-detailed', ...  % display more information
        'MaxIterations', 1000, ...  % maximum number of iterations
        'MaxFunctionEvaluations', 10000, ...  % maximum number of function calls
        'OptimalityTolerance', 1e-6, ...  % convergence tolerance on first order optimality
        'ConstraintTolerance', 1e-6, ...  % convergence tolerance on constraints
        'StepTolerance', 1e-12, ...
        'SpecifyObjectiveGradient', false, ...  % supply gradients of objective
        'SpecifyConstraintGradient', false, ...  % supply gradients of constraints
        'CheckGradients', false, ...  % true if you want to check your supplied gradients against finite differencing
        'OutputFcn', @outfun );  % display diagnotic information

figure;
c = gray;
c = flipud( c );
function stop = outfun( x, ~, ~ )
    x_p = reshape( x, num_elems_x, num_elems_y )';
    imagesc( x_p );
    axis equal
    colormap(c)
    caxis([0 1])
    set(gca,'YDir','normal')
    drawnow
    stop = false;
end

xstar = fmincon( @objective, x0,...
    [], [],... % Inequality constraints: none
    ones(1,length(x0)), volfrac*fem.n_el,... % Equality constraints: sum( E ) = volfrac*n_el
    0.01*ones( size(x0) ), ones( size(x0) ),... % bounds : 0 < E_i < 1
    [], options )

end