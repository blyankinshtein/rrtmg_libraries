function [cc, ciwc, clwc, rle, rie] = model_cloud_input(erai_filename, ceres_filename, lat, lon, first_day, last_day, p, climo_name)
% reads cloud variables from erai and ceres
% cc - cloud cover
% ciwc - cloud ice water content
% clwc - cloud liquid water content
% rle - effective radius of liquid particles
% rie - effective radius of ice particles
% p - pressure profile
% climo_name - to save ceres climotology for the location
    [~, cc, ciwc, clwc] = read_erai_clouds(erai_filename, lat, lon, first_day, last_day);
    [rle, rie] = read_ceres_clouds(ceres_filename, p, lat, lon, first_day, last_day, 1, climo_name);
    rle = rle(:, 1:2:size(rle,2))';
    rie = rie(:, 1:2:size(rie,2))';
end