function [p, cc, ciwc, clwc] = read_erai_clouds(filename, lat, lon, first_day, last_day)
% reads cloud cover, ice/liquid water content profiles form ERA Interim for 
% the given day range over the given location
    p = double(ncread(filename, 'level'))'; % "millibars" ; "pressure_level" ;
    p = flip(p);
    cc = read_erai_levels(filename, 'cc', lat, lon, first_day, last_day); % (0 - 1) Fraction of cloud cover
    ciwc =  read_erai_levels(filename, 'ciwc', lat, lon, first_day, last_day); % kg kg**-1 Specific cloud ice water content
    clwc =  read_erai_levels(filename, 'clwc', lat, lon, first_day, last_day); % kg kg**-1 Specific cloud liquid water content
end