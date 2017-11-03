function ceres_climo(filename_to_read, path_to_save, filename_to_save, lat, lon, month_num) %#ok<INUSL>
% generate 3-hourly monthly climatology for effective radii
    field_names = {'cldicediam_low_3hm', 'cldicediam_mid-low_3hm', 'cldicediam_mid-high_3hm', 'cldicediam_high_3hm',...
                   'cldwatrad_low_3hm', 'cldwatrad_mid-low_3hm', 'cldwatrad_mid-high_3hm', 'cldwatrad_high_3hm'};
    var_names = {'icelow_climo', 'icemidlow_climo', 'icemidhigh_climo', 'icehigh_climo',...
                 'liqlow_climo', 'liqmidlow_climo', 'liqmidhigh_climo', 'liqhigh_climo'};
    for i = 1:length(field_names)
        eval([var_names{i} ' = ceres_month_var_climo(filename_to_read, field_names{i}, lat, lon, month_num);']);
    end
    [~,~,~] = mkdir(path_to_save);
    save([path_to_save, '/', filename_to_save], var_names{:});
end