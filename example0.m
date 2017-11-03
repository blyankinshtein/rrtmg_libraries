%% HOW TO READ DATA FROM ERAi
%% paths to libraries
current_folder = pwd;
%library that load data from ERAi&CERES&standard profile
rrtmg_input_erai_lib = [current_folder, '/rrtmg_input_erai_lib'];
addpath(rrtmg_input_erai_lib);
%% paths to erai files
erai_profile_filename = './erai/erai-4xdaily_N80_N45_W50_W180_200101_profile.nc'; % 6hourly resolution
erai_surface_filename = './erai/erai-4xdaily_N80_N45_W50_W180_200101_surface.nc'; % 6hourly resolution
erai_falbedo_filename = './erai/erai-8xdaily_N80_N45_W50_W180_200101_falbedo.nc'; % 3hourly resolution
erai_radiation_filename = './erai/erai-8xdaily_N80_N45_W50_W180_200101_radiation.nc'; % 3hourly resolution
%% location and time settings
lat = 66;
lon = 234;
first_day = [2001 01 01]; 
last_day = [2001 01 10];
%% read erai surface variables like pressure or temperature
p_surface = read_erai_var(erai_surface_filename, 'sp', lat, lon, first_day, last_day);
t_skin = read_erai_var(erai_surface_filename, 'skt', lat, lon, first_day, last_day);
%% read erai forecast surface variables like albedo
albedo = read_erai_forecast_var(erai_falbedo_filename, 'fal', lat, lon, first_day, last_day);
%% read erai level variables like temperature profiles
t = read_erai_levels(erai_profile_filename, 't', lat, lon, first_day, last_day);
%% read erai pressure, temperature, specific humidity and ozone
[p, t, q, o3] = read_erai_profiles(erai_profile_filename, lat, lon, first_day, last_day);
%% read erai pressure, temperature, specific humidity, ozone and start filling wkl (see rrtmg instructions) profiles
[p, t, q, o3, wkl] = model_erai_input(erai_profile_filename, lat, lon, first_day, last_day);
%% fill wkl with remaining values from a standard profile
indices = [2, 4, 5, 6]; % 1)H2O 2)CO2 3)O3 4)N2O 5)CO 6)CH4
wkl = model_ghg_input(wkl, p, 'win', indices);
%% read standard profiles
[zh, pz1, tz1, wkl] = read_standard_profile('win', 1);
%% read erai cloud profiles
[p, cc, ciwc, clwc] = read_erai_clouds(erai_profile_filename, lat, lon, first_day, last_day);
%% read erai radiation variables like ttr
[time, ttr] = read_erai_radiation_series(erai_radiation_filename, lat, lon, first_day, last_day, 'ttr');


