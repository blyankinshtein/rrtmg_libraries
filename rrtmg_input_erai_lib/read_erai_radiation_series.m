function [time, rad] = read_erai_radiation_series(erai_filename, lat, lon, first_day, last_day, varname)
    time = ncread(erai_filename, 'time');
    f_day = find((datenum(datetime([first_day 3 0 0]))-datenum(datetime([1900 01 01 0 0 0])))*24 == time);
    l_day = find((datenum(datetime([last_day 23 59 60]))-datenum(datetime([1900 01 01 0 0 0])))*24 == time);
    time = time(f_day : l_day);
    rad = read_erai_forecast_var(erai_filename, varname, lat, lon, first_day, last_day);
    % accumulated amounts foor 3,4,9,12 hours -> 3 hours
    idx3 = 1:4:length(rad);
    idx6 = 2:4:length(rad);
    idx9 = 3:4:length(rad);
    idx12 = 4:4:length(rad);
    rad(idx12) = rad(idx12)-rad(idx9);
    rad(idx9) = rad(idx9)-rad(idx6);
    rad(idx6) = rad(idx6)-rad(idx3);
    % J m^-2 - > W m^-2
    rad = -rad./(3*3600);
end