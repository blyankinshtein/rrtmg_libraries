function [lre, ire] = read_ceres_clouds(filename, p, lat, lon, first_day, last_day, climo_flag, climo_name)  
% first_day and last_day are in format [year month day] and must be within
% the file with 3 hourly data of effective ice/water radii
% p is pressure
% if climo_flag = 1 missing data are replaced by climo; otherwise by zeros
    day_numbers = days(datetime(last_day)-datetime(first_day))+1;
    low = find(p >= 700);
    midlow = find((700 > p) & (p >= 500));
    midhigh = find((500 > p) & (p >= 300));
    high = find((300 > p) & (p  >= 100));
    if climo_flag == 1
        %% form climo
        climo_path_to_save = ['ceres/', climo_name];
        climo_filename_to_save = ['ceres_', num2str(first_day(2), '%.2i'), '_climo.mat'];
        if exist([climo_path_to_save, '/', climo_filename_to_save], 'file') ~=2

            climo_filename_to_read = 'ceres/CERES_SYN1deg-3HM_Terra-Aqua-MODIS_Ed3A_Subset_200003-201609_clouds_re.nc';
            ceres_climo(climo_filename_to_read, climo_path_to_save, climo_filename_to_save, lat, lon, first_day(2));
        end
        load([climo_path_to_save, '/', climo_filename_to_save]);

        lre = zeros(length(p),8);
        ire = zeros(length(p),8);


        for i = low
            lre(i, :) = liqlow_climo;
            ire(i, :) = icelow_climo;
        end
        for i = midlow
            lre(i, :) = liqmidlow_climo;
            ire(i, :) = icemidlow_climo;
        end
        for i = midhigh
            lre(i, :) = liqmidhigh_climo;
            ire(i, :) = icemidhigh_climo;
        end
        for i = high
            lre(i, :) = liqhigh_climo;
            ire(i, :) = icehigh_climo;
        end
        for i = 2:day_numbers
            lre(:, 8*(i-1)+1 : 8*(i-1)+8) = lre(:,1:8);
            ire(:, 8*(i-1)+1 : 8*(i-1)+8) = ire(:,1:8);
        end
        %% substitute known instant values  
        [~, cmdout] = system(['[ -f ', filename,' ] && echo "1"']);
        if ~isempty(cmdout) %strcmp(cmdout(1), '1')
            field_names = {'cldicediam_low_3h', 'cldicediam_mid-low_3h', 'cldicediam_mid-high_3h', 'cldicediam_high_3h',...
                       'cldwatrad_low_3h', 'cldwatrad_mid-low_3h', 'cldwatrad_mid-high_3h', 'cldwatrad_high_3h'};
            var_names = {'icelow', 'icemidlow', 'icemidhigh', 'icehigh',...
                         'liqlow', 'liqmidlow', 'liqmidhigh', 'liqhigh'};
            for i = 1:length(field_names)
                eval([var_names{i} ' = read_ceres_var(filename, field_names{i}, lat, lon, first_day, last_day);']);
            end
            for i = low
                lre(i, ~isnan(liqlow)) = liqlow(~isnan(liqlow))';
                ire(i, ~isnan(icelow)) = icelow(~isnan(icelow))';
            end
            for i = midlow
                lre(i, ~isnan(liqmidlow)) = liqmidlow(~isnan(liqmidlow))';
                ire(i, ~isnan(icemidlow)) = icemidlow(~isnan(icemidlow))';
            end
            for i = midhigh
                lre(i, ~isnan(liqmidhigh)) = liqmidhigh(~isnan(liqmidhigh))';
                ire(i, ~isnan(icemidhigh)) = icemidhigh(~isnan(icemidhigh))';
            end
            for i = high
                lre(i, ~isnan(liqhigh)) = liqhigh(~isnan(liqhigh))';
                ire(i, ~isnan(icehigh)) = icehigh(~isnan(icehigh))';
            end
        end
    else
        field_names = {'cldicediam_low_3h', 'cldicediam_mid-low_3h', 'cldicediam_mid-high_3h', 'cldicediam_high_3h',...
                   'cldwatrad_low_3h', 'cldwatrad_mid-low_3h', 'cldwatrad_mid-high_3h', 'cldwatrad_high_3h'};
        var_names = {'icelow', 'icemidlow', 'icemidhigh', 'icehigh',...
                     'liqlow', 'liqmidlow', 'liqmidhigh', 'liqhigh'};
        for i = 1:length(field_names)
            eval([var_names{i} ' = read_ceres_var(filename, field_names{i}, lat, lon, first_day, last_day);']);
        end
        lre = zeros(length(p), 8 * day_numbers);
        ire = zeros(length(p), 8 * day_numbers);
        for i = low
            lre(i, :) = liqlow';
            ire(i, :) = icelow';
        end
        for i = midlow
            lre(i, :) = liqmidlow';
            ire(i, :) = icemidlow';
        end
        for i = midhigh
            lre(i, :) = liqmidhigh';
            ire(i, :) = icemidhigh';
        end
        for i = high
            lre(i, :) = liqhigh';
            ire(i, :) = icehigh';
        end
        lre(isnan(lre)) = 0;
        ire(isnan(ire)) = 0;
    end
    ire = ire ./ 2;
end