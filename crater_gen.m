function [crat] = crater_gen(A,c,minD)
    crat=crater; % Generate a new crater of class 'crater'.
    Z=randi([0 uint32(A)],1,1); % We choose a completely random area Z that is a subset of A (A being the integral of the size frequency distribution from the minimum possible crater diameter to the maximum.
    % Now, through analytic integration, we find a crater diameter D1 such 
    % that Z=integral(n_cum) from D=minD to D=D1.
    %crat.D=-c/(Z-(c/minD)); % The analytic solution to the integration of the size frequency distribution, algebraically solved for the upper limit of integration, crater diameter D.
    crat.D=1e4;
    crat.R=crat.D/2; % The radius of the crater.
    crat.x_center=randi([0 5e5],1,1); % A random x coordinate at which to place the crater.
    crat.y_center=randi([0 5e5],1,1); % A random y coordinate at which to place the crater.
    crat.exist=1; % The crater is initially flagged as existing.
    crat.area_i=pi*(crat.R^2); % The initial area of the crater.
    crat.area_r=crat.area_i; % The remaining area of the crater, at first set as the crater's initial area.  To be whittled down as other craters land on top.
end