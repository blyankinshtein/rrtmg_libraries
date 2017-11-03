function field = read_ceres_var(filename, fieldname, lat, lon, first_day, last_day)
% reads the variable for the given day range over the given location
    [idx_lon, idx_lat] = pick_point(filename, lat, lon, 'ceres');
    time = ncread(filename, 'time'); % "days since 2000-03-01 00:00:00" ;
    [~, f_day] = min(abs((datenum(datetime([first_day 0 0 0]))-datenum(datetime([2000 03 01 0 0 0]))) - time));
    [~, l_day] = min(abs((datenum(datetime([last_day 21 0 0]))-datenum(datetime([2000 03 01 0 0 0]))) - time));
    field = squeeze(ncread(filename, fieldname, [idx_lon idx_lat f_day], [1 1 l_day-f_day+1], [1 1 1]));
end