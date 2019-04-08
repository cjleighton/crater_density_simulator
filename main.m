minD=1e4; % The minimum diameter with which craters can be generated (m)
maxD=5e4; % The maximum diameter with which craters can be generated (m)
c=1e8; % A constant value used to determine the size frequency distribution
b=2; % A constant value used to determine the size frequency distribution
n=@(D_symbolic) c.*D_symbolic.^(-b); % The size frequency distribution of craters
A=double(integral(n,minD,maxD)); % The integrated area under the size frequency distribution from the minimum to maximum crater diameters.  This will be used in crater_gen.m to weight the creation of craters toward smaller craters.

t_arr=[]; % An array of times, the final entry of which always describes how much time has passed since the simulation began.  For example, on the first iteration of the program, t_arr=[0]. On the second, t_arr=[0 1000], and so on.
n_arr=[]; % An array that describes the cumulative number of craters at a time, i.e. n_arr(i) describes the number of craters after t_arr(i) years where i is an arbitrary number less than or equal to the length of t_arr[].
crat_arr=[]; % An array which will contain every crater that impacts the surface, where 'crater' is a used-defined class that can record a crater's relevant properties.

t=0; % The current time.  Each iteration of the while() loop below increases t until it reaches sim_timespan.
sim_timespan=1E4; % The desired length of our simulation measured in years.
while(t<=sim_timespan+1) % Run this loop while we're within the desired range.
    %% Crater generation
    crat=crater_gen(A,c,minD); % Create a crater, crat, which now contains the properties dsecribed in crater.m.
    crater_plotter(crat,t,sim_timespan); % Plot the crater field at this moment in time, t.
    crat_arr=[crat_arr; crat]; % Add the crater we just created to the array of all craters.
    t_arr=[t_arr; t]; % Add the current time to the list of elapsed times.
    
    %% Overlap analysis
    % The next goal is to consider every crater surrounding the crater we
    % just created (i.e. we must compare crat to every other crater in
    % crat_arr).  At each crater, crat_arr(i), we must determine if it
    % overlaps with our new crater, crat.  If so, we must THEN consider
    % whether the region of crat_arr(i) that is being occluded by crat has
    % already been erased.  The parts that have not already been erased
    % should now be erased by the overlapping region with crat.  The parts
    % that were previously erased should be ignored.
    for i=1:length(crat_arr)-1 % Our new crater, crat, is now the final entry of crat_arr, so we must consider every crater except for the last one.
        R1=crat.R;
        R2=crat_arr(i).R;
        d_x=crat.x_center-crat_arr(i).x_center; % Calculate the distance between the centers of crat and crat_arr(i) in the x direction.
        d_y=crat.y_center-crat_arr(i).y_center; % Calculate the distance between the centers of crat and crat_arr(i) in the y direction.
        d_mag=sqrt(d_x^2+d_y^2); % Calculate the magitude of distance between the centers of crat and crat_arr(i).
        A_intersect=real((R1^2)*acos((d_mag^2+R1^2-R2^2)/(2*d_mag*R1))+(R2^2)*acos((d_mag^2+R2^2-R1^2)/(2*d_mag*R2))-0.5*sqrt((-d_mag+R1+R2)*(d_mag+R1-R2)*(d_mag-R1+R2)*(d_mag+R1+R2)));
        % A_intersect calculates the overlapping are between crat and
        % crat_arr(i).  If crat and crat_arr(i) are not overlapping,
        % A_intersect goes to 0.  If crat is smaller than crat_arr(i) and
        % lands entirely within crat_arr(i)'s area, A_intersect will equal
        % crat's area.
        
        % Below, we will determine whether the region of crat_arr(i) being
        % occluded by crat was previously erased.  If it was, we will
        % ignore it.  If it wasn't, we will mark that region to be erased.
        % Ideally, this process would be carried out by recording every
        % (x,y) pair in the region to be erased and associating every one
        % of those pairs with crat_arr(i), i.e. crat_arr(i).x_erased and
        % crat_arr(i).y_erased would store an enormous number of (x,y)
        % pairs that would denote 1 m^2 regions within crat_arr(i) that
        % have been erased (and at the end of the day, we would sum up the
        % areas described by those pairs and subtract that area from
        % crat_arr(i)'s area before the operation.
        % The implementation below is essentially the process that is
        % described above, though with one modification made for the sake
        % of efficiency: Instead of examining every single (x,y) point in
        % the overlapping region, I only examine one in every few hundred
        % (x,y) points.  The number of points that we skip over is defined
        % by the constant accu_fact, which I have set to 500 for part 1 and
        % 1000 for part 2. To calculate the area to be erased, we will
        % multiply the number of points we just counted by accu_factor^2.
        % Throughout the rest of this documentation, I will refer to number
        % of pixels over which we skip as accu_fact; keep in mind that it
        % typically denotes either 500 meters or 800 meters.
        dots=0; % The number of accu_fact m^2 regions that crat has just erased from crat_arr(i).
        accu_fact=500; % The number of 1 m^2 regions over which to skip during our analysis.
        if (A_intersect>0 & crat_arr(i).exist==1) % We only consider nonzero overlaps between craters, and we additionally make sure that crat_arr(i) has not already been erased.
        %% Point counting
        % We will now consider every few hundred (accu_fact) points in
        % crat_arr(i) and a) determine which one of these points are within
        % the overlapping region with crat and b) exclude regions in
        % crat_arr(i) that have already been erased.
            for y=crat_arr(i).y_center-crat_arr(i).R:accu_fact:crat_arr(i).y_center+crat_arr(i).R % Loop through the rows in crat_arr(i).
                for x=crat_arr(i).x_center-crat_arr(i).R:accu_fact:crat_arr(i).x_center+crat_arr(i).R % Loop through the columns in a given row.
                    % Keep in mind that at this level, we're examining a
                    % single point (x,y) in crat_arr(i) and determining
                    % whether it should be erased.
                    already_erased=0; % The point (x,y) in question has not yet been erased.
                    d_mag_crat=sqrt((crat.x_center-x)^2+(crat.y_center-y)^2); % The distance between (x,y) and the center of crat.
                    d_mag_crat_i=sqrt((crat_arr(i).x_center-x)^2+(crat_arr(i).y_center-y)^2); % The distance between (x,y) and the center of crat_arr(i).
                    if (d_mag_crat<crat.R & d_mag_crat_i<crat_arr(i).R) % If the two magnitudal distances are less the radii of the respective craters, (x,y) is within the overlapping region.
                        % Because craters are assigned completely random
                        % coordinates on the plane and because how we're
                        % looping through all of the (x,y) pairs within
                        % those craters, we have to round the (x,y) pair
                        % we're examining to the nearest 'clean' number.
                        % This is required because part of this process is
                        % checking whether the (x,y) pair in crat_arr(i)
                        % that we're examining has already been erased.
                        x_pos=round(x/accu_fact)*accu_fact; % Round the x position in question to the nearest accu_fact
                        y_pos=round(y/accu_fact)*accu_fact; % Round the y position in question to the nearest accu_fact
                        for j=1:length(crat_arr(i).x_erased) % Check to see if (x_pos,y_pos) were already erased from crat_arr(i).
                            % Here, j refers to the jth item in the matrix
                            % of (x,y) pairs that have already been erased
                            % from crat_arr(i).
                            if (crat_arr(i).x_erased(j)==x_pos & crat_arr(i).y_erased(j)==y_pos)
                                % If we find that (x_pos,y_pos) already
                                % exist in the matrix of erased (x,y) pairs
                                % for crat_arr(i), we mark it as such so
                                % that we won't attempt to erase it again
                                % later.
                                already_erased=1;
                            end
                        end
                        if already_erased==0 % If (x_pos,y_pos) wasn't found in the matrix of (x,y) pairs erased from crat_arr(i), the point in question wasn't already erased.  We will now erase it.
                            crat_arr(i).x_erased=[crat_arr(i).x_erased x_pos]; % Add x_pos to the matrix of erased x positions.
                            crat_arr(i).y_erased=[crat_arr(i).y_erased y_pos]; % Add y_pos to the matrix of erased x positions.
                            dots=dots+1; % We have located a point that must be erased; 'dots' records this.
                        end
                    end
                end
            end
        end
        %% Erased area subtraction
        % If A_intersect between crat and crat_arr(i) equals zero, the
        % area to be erased below will also equal zero (because 'dots' will
        % equal zero, thereby causing no area to be subtracted from 
        % crat_arr(i). If A_intersect>0, then the erased area will not
        % equal zero and we will subtract a nonzero area from the remaining
        % area of crat_arr(i).
        area_erased=dots*(accu_fact^2); % The number of square meters that have just been erased from crat_arr(i).
        crat_arr(i).area_r=crat_arr(i).area_r-area_erased; % The remaining area in crat_arr(i).
        
        % If the remaining area of crat_arr(i) falls below half of its
        % initial area, we consider it to have been erased.
        if (crat_arr(i).area_r/crat_arr(i).area_i<0.5 & crat_arr(i).exist==1) % We also verify that the crater in question still exists.
            crat_arr(i).exist=0; % We mark crat_arr(i) as having been erased.
        end
    end
    
    %% Crater counting at time t
    % We're done comparing crat to all other craters in crat_arr. We must
    % now count the total number of craters at this iteration.  One has
    % been added from the previous iteration (in the form of crat), but one
    % (or more) may have been erased.
    n_temp=0; % Initial count of craters on this iteration.
    for i=1:length(crat_arr)
        if crat_arr(i).exist==1 % Only consider craters that haven't been erased.
            n_temp=n_temp+1; % Iterate upwards, resulting in the total number of craters at this moment.
        end
    end
    n_arr=[n_arr; n_temp]; % Append the latest crater count to the array of counts. Keep in mind that n_arr(i) corresponds to t_arr(i).
    
    disp([num2str(100*(t/sim_timespan)) '% done. Crater count: ' num2str(n_arr(length(n_arr)))]); % A simple progress indicator.
    t=t+1000; % At the end of each iteration of the while() loop, we step forward in time 1000 years.
end

%% Plot the cumulative number of craters vs. time.
figure;
hold on;
plot(t_arr,n_arr); % Plot the matrix of times against the matrix of corresponding crater counts.
title('Cumulative number of craters as a function of time');
xlabel('Time (years)'); % Label the x axis.
ylabel('Number of craters in the 500 km^2 region'); % Label the y axis.
saveas(gcf,['crater_count.png']); % Save a copy of the plot.