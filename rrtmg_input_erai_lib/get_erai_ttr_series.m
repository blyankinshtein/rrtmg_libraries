function [time, ttr] = get_erai_ttr_series(erai_filename, lat, lon, first_day, last_day, varname)

    time = ncread(erai_filename, 'time');
    f_day = find((datenum(datetime([first_day 3 0 0]))-datenum(datetime([1900 01 01 0 0 0])))*24 == time);
    l_day = find((datenum(datetime([last_day 23 59 60]))-datenum(datetime([1900 01 01 0 0 0])))*24 == time);
    time = time(f_day : l_day);
    [idx_lon, idx_lat] = pick_point(erai_filename, lat, lon, 'erai');
    ttr = squeeze(ncread(erai_filename, varname, [idx_lon idx_lat f_day], [1 1 (l_day-f_day+1)], [1 1 1]));
    % accumulated amounts foor 3,4,9,12 hours -> 3 hours
    idx3 = 1:4:length(ttr);
    idx6 = 2:4:length(ttr);
    idx9 = 3:4:length(ttr);
    idx12 = 4:4:length(ttr);
    ttr(idx12) = ttr(idx12)-ttr(idx9);
    ttr(idx9) = ttr(idx9)-ttr(idx6);
    ttr(idx6) = ttr(idx6)-ttr(idx3);
    % J m^-2 - > W m^-2
    ttr = -ttr./(3*3600);
end