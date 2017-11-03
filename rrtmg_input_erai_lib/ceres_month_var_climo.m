function field_climo = ceres_month_var_climo(filename, fieldname, lat, lon, month_num)
% forms 3-hourly january climatology for a ceres variable 
    [idx_lon, idx_lat] = pick_point(filename, lat, lon, 'ceres');
    field = squeeze(ncread(filename, fieldname, [idx_lon idx_lat 1], [1 1 Inf], [1 1 1]));
    time = ncread(filename, 'time'); % "days since 2000-03-01 00:00:00" ;
    time_to_display = datetime(double(time)+datetime(2003,3,1));
    field = field(month(time_to_display) == month_num);
    field_climo = zeros(1,8);
    for i = 1:8
        field_climo(i) = nanmean(field(i:8:length(field)));
    end
end