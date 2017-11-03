%% HOW TO READ DATA FROM ERAi AND RUN RRTMG
%% paths to libraries
current_folder = pwd;
%library that load data from ERAi&CERES&standard profile
rrtmg_input_erai_lib = [current_folder, '/rrtmg_input_erai_lib'];
addpath(rrtmg_input_erai_lib);
%path to executable rrtmg files
rrtmg_folder = [current_folder, '/rrtmg'];
%library that runs rrtmg
rrtmg_lib_folder = [current_folder, '/rrtmg_lib'];
addpath(rrtmg_lib_folder);
%%
clouds = 1; % 1 if all-sky calculation; 0 if clear-sky
erai_profile_filename = './erai/erai-4xdaily_N80_N45_W50_W180_200101_profile.nc';
erai_surface_filename = './erai/erai-4xdaily_N80_N45_W50_W180_200101_surface.nc';
erai_filename_falbedo = './erai/erai-8xdaily_N80_N45_W50_W180_200101_falbedo.nc';
lat = 66;
lon = 234;
station_name = 'Norman_Wells';
first_day = [2001 01 01]; 
last_day = [2001 01 10];
year = num2str(first_day(1));
month = num2str(first_day(2),'%.2i');
%% read erai profiles
[p, t, q, o3, wkl] = model_erai_input(erai_profile_filename, lat, lon, first_day, last_day);
tz1 = t(1, :);
pz1 = p(1, :);
%% retrieve other (than o3) ghg profiles from a standard profile
wkl = model_ghg_input(wkl, pz1, 'win', [2, 4, 5, 6]);
%% read erai surface variables
p_surface = read_erai_var(erai_surface_filename, 'sp', lat, lon, first_day, last_day);
t_skin = read_erai_var(erai_surface_filename, 'skt', lat, lon, first_day, last_day);
%% read erai forecast albedo
falbedo = read_erai_forecast_var(erai_filename_falbedo, 'fal', lat, lon, first_day, last_day);
albedo = cat(1, falbedo(1), falbedo(1:length(falbedo)-2));
%% initialize clouds with CERES or zeros
if clouds == 1
    ceres_filename = ['ceres/CERES_SYN1deg-3H_Terra-Aqua-MODIS_Ed3A_Subset_', year, month, '01-', year, month,'31_clouds_re.nc'];
    [cc, ciwc, clwc, rle, rie] = model_cloud_input(erai_profile_filename, ceres_filename, lat, lon, first_day, last_day, p, station_name);
else
    var_names = {'cc', 'ciwc', 'clwc', 'rle', 'rie'};
    for k = 1 : length(var_names)
        eval([var_names{k}, '= zeros(size(t));']);
    end
end
%% read erai surface data and fix the setting so that the surface is not at 1000 hPa
[pz1, tz1, pavg, tavg, wkl, cc1, clwc1, ciwc1, rie1, rle1] = form_input(pz1, tz1, p_surface(1)/100, t_skin(1), wkl, cc(1,:), clwc(1,:), ciwc(1,:), rie(1,:), rle(1,:));
%% run the LW model and get heating rate
[lw_heatrate, ttr, lw_surfaceflux] = rrtmg_lw_run(rrtmg_folder, pz1, tz1, pavg, tavg, wkl, cc1, clwc1, ciwc1, rie1, rle1);
%% run the SW model and get heating rate
day_time = datetime([first_day 0 0 0]);
juldat = day(day_time,'dayofyear');

sza = solar_zenith_angle(day_time, lat, lon);
% option:
% sza = average_solar_zenith_angle(day_time, 1.5, 0.1, lat, lon);
[sw_heatrate, ssrd, ssr, tsr, tisr] = rrtmg_sw_run(rrtmg_folder, pz1, tz1, pavg, tavg, wkl, cc1, clwc1, ciwc1, rie1, rle1, juldat, sza, albedo);