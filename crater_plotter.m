function [] = crater_plotter(crat,t,sim_timespan)
    theta=linspace(0,2*pi);
    plot(crat.x_center+crat.R*cos(theta),crat.y_center+crat.R*sin(theta)); % Plot the newly created crater, crat.
    xlabel('X position (m)'); % Label the x axis.
    ylabel('Y position (m)'); % label the y axis.
    title(['Crater field after ' num2str(uint32(t)) ' years']); % Set a title.
    hold on; % We'll keep the same figure throughout the entire simulation and just add a new crater to it as each iteration is executed (rather than redrawing the entire field every time a crater is added).
    axis([0 5e5 0 5e5]); % Set the axis to 500 km by 500 km.
    % Save a few snapshots of the crater field after the simulation is 1/4,
    % 1/2, 3/4, and 1/1 complete.
    if (t==sim_timespan*0.25 | t==sim_timespan*0.5 | t==sim_timespan*0.75 | t==sim_timespan)
        saveas(gcf,[num2str(t) '_years.png']);
    end
end