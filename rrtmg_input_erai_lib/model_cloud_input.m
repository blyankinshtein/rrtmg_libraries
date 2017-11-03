function [cc, ciwc, clwc, rle, rie] = model_cloud_input(erai_filename, ceres_filename, station_num, first_day, last_day, pz1)
        [~, cc, ciwc, clwc] = read_erai_clouds(erai_filename, station_num, first_day, last_day);
        cc = cc(1, :);
        ciwc = ciwc(1, :);
        clwc = clwc(1, :);
        [rle, rie] = read_ceres_clouds(ceres_filename, pz1, station_num, first_day, last_day, 1);
        rle = rle(:,1)';
        rie = rie(:,1)';
end