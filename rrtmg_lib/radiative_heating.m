function [heatrate, surfaceflux] = radiative_heating(rrtmg_folder, day_time, lat, lon, albedo, pz1, tz1, pavg, tavg, wkl, cc, clwc, ciwc, rie, rle)
    %heating due to solar and thermal radiation
    %day_time - date and time in datetime format
    %lat - latitude from -90 to 90, N positive
    %lon - longitude from -180 to 180 or from 0 to 360
    %albedo - surface albedo
    %pz1 - pressure at levels in hPa
    %pavg - pressure in layers in hPa
    %tz1 - temperature at levels in K
    %tavg - temperature in layers in K
    %wkl - matrix with greenhouse species
    %cc - cloud cover, fraction
    %clwc - cloud liquid water content
    %ciwc - cloud ice water content
    %rie - effective radius of ice particles
    %rle - effective radius of liquid particles
    %heatrate - heating rate at levels in K/day
    %surfaceflux - net surface radiation flux in W/m^2, positive downwards
    sza_averaging_range = 1.5;
    sza_averaging_step = 0.1;
    
    juldat = day(day_time,'dayofyear');
    sza = average_solar_zenith_angle(day_time, sza_averaging_range, sza_averaging_step, lat, lon);
    [heatrate_sw, ~, surfaceflux_sw, ~, ~] = rrtmg_sw_run(rrtmg_folder, pz1, tz1, pavg, tavg, wkl, cc, clwc, ciwc, rie, rle, juldat, sza, albedo);
    [heatrate_lw, ~, surfaceflux_lw] = rrtmg_lw_run(rrtmg_folder, pz1, tz1, pavg, tavg, wkl, cc, clwc, ciwc, rie, rle);    
    
    heatrate = heatrate_lw + heatrate_sw;
    surfaceflux = - surfaceflux_lw + surfaceflux_sw;
end