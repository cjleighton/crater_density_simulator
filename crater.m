classdef crater
    properties
        D; % The diameter of the crater.
        R; % The radius of the crater.
        x_center; % The random x position where the center of the crater will be placed.
        y_center; % The random y position where the center of the crater will be placed.
        area_i; % The initial area of the crater, as calculated from the radius, R.
        area_r; % The remaining area of the crater.  At first, it will be set equal to the crater's initial area, and as the crater is covered up by other craters, it will be subtracted from.  When it equals less than half of the initial area, the crater will be marked as erased.
        x_erased=[]; % A matrix of x positions within the crater that have been erased.
        y_erased=[]; % A corresponding matrix of y positions within the crater that have been erased.
        exist; % A flag that denotes whether the crater exists.  exist=1 denotes that the crater exists, exist=0 denotes that it has been erased.
    end
end