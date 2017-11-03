function field = read_erai_levels(filename, fieldname, lat, lon, first_day, last_day)
% reads the variable for the given day range over the given location
    time = ncread(filename, 'time'); % "hours since 1900-01-01 00:00:0.0" ;
    [idx_lon, idx_lat] = pick_point(filename, lat, lon, 'erai');
    f_day = find((datenum(datetime([first_day 0 0 0]))-datenum(datetime([1900 01 01 0 0 0])))*24 == time);
    l_day = find((datenum(datetime([last_day 18 0 0]))-datenum(datetime([1900 01 01 0 0 0])))*24 == time);
    field(:, :) = squeeze(ncread(filename, fieldname, [idx_lon idx_lat 1 f_day], [1 1 Inf l_day-f_day+1], [1 1 1 1]))';
    field = flip(field, 2);
end