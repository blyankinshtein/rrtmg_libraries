%% HOW TO RUN RADIATIVE EQUILIBRIUM MODEL WITH RRTMG
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
%% generation of time variables
dt=0.25;
year = num2str(first_day(1));
month = num2str(first_day(2),'%.2i');
day_numbers = days(datetime(last_day)-datetime(first_day))+1;
first_time_step = (datenum(datetime([first_day 0 0 0]))-datenum(datetime([1900 01 01 0 0 0])))*24;
time = double(first_time_step:(24*dt):(first_time_step+(day_numbers-dt)*24));
%% read erai profiles
[p, t, q, o3, wkl] = model_erai_input(erai_profile_filename, lat, lon, first_day, last_day);
%% retrieve other (than o3) ghg profiles from a standard profile
wkl = model_ghg_input(wkl, p, 'win', [2, 4, 5, 6]);
%% read erai surface variables
p_surface = read_erai_var(erai_surface_filename, 'sp', lat, lon, first_day, last_day);
t_skin = read_erai_var(erai_surface_filename, 'skt', lat, lon, first_day, last_day);
%% read erai forecast albedo
falbedo = read_erai_forecast_var(erai_filename_falbedo, 'fal', lat, lon, first_day, last_day);
albedo = cat(1, falbedo(1), falbedo(1:length(falbedo)-2));
%% initialize clouds with CERES or zeros
if clouds == 1
    [~, cc, ciwc, clwc] = read_erai_clouds(erai_profile_filename, lat, lon, first_day, last_day);
    ceres_filename = ['ceres/CERES_SYN1deg-3H_Terra-Aqua-MODIS_Ed3A_Subset_', year, month, '01-', year, month,'31_clouds_re.nc'];
    [rle, rie] = read_ceres_clouds(ceres_filename, p, lat, lon, first_day, last_day, 1, station_name);
    rle = rle(:, 1:2:size(rle,2))';
    rie = rie(:, 1:2:size(rie,2))';
else
    var_names = {'cc', 'ciwc', 'clwc', 'rle', 'rie'};
    for k = 1 : length(var_names)
        eval([var_names{k}, '= zeros(size(t));']);
    end
end
%% interpolation of erai data to 3h resolution
dt = 0.125;
nsteps = day_numbers/dt -1;
for varnames = {'t', 'q', 'o3', 'cc', 'clwc', 'ciwc', 'rie', 'rle'}
    eval([varnames{1}, '_extended(1:2:nsteps,:) = ', varnames{1},'(:,:);']);
    eval([varnames{1}, '_extended(2:2:nsteps-1,:) = (', varnames{1}, '_extended(1:2:nsteps-2,:) + ',varnames{1}, '_extended(3:2:nsteps,:))./2;']);
end
for varnames = {'p_surface', 't_skin', 'time'}
    eval([varnames{1}, '_extended(1:2:nsteps) = ', varnames{1},'(:);']);
    eval([varnames{1}, '_extended(2:2:nsteps-1) = (', varnames{1}, '_extended(1:2:nsteps-2) + ',varnames{1}, '_extended(3:2:nsteps))./2;']);
end
for varnames = {'t', 'q', 'o3', 'cc', 'clwc', 'ciwc', 'rie', 'rle', 'p_surface', 't_skin', 'time'}
    eval([varnames{1}, ' = ', varnames{1}, '_extended;']);
end
%%
day_time = datetime(double(time)/24+datetime(1900,1,1),'ConvertFrom','datenum');
[pz1, tz, pavg, tav, wkl, cc1, clwc1, ciwc1, rie1, rle1] = form_input(p, t(1,:), p_surface(1)/100, t_skin(1), wkl, cc(1,:), clwc(1,:), ciwc(1,:), rie(1,:), rle(1,:));

nlayers = length(pavg);
tz1 = zeros(nsteps+1, nlayers+1);
tavg = zeros(nsteps+1, nlayers);
tz1(1,:) = tz;
tavg(1,:) = tav;
%
C_w = 4.2*1e6; % water heat capacity J/m/m^2
equivalent_depth = 5;
heat_capacity = C_w * equivalent_depth;
%
for nt = 1:nsteps
    %radiative heating
    [radheatrate, radsurfaceflux] = radiative_heating(rrtmg_folder, day_time(nt), lat, lon, albedo(nt), pz1, tz1(nt,:), pavg, tavg(nt,:), wkl, cc1, clwc1, ciwc1, rie1, rle1);
    radheatrate = interp1(log(pz1), radheatrate, log(pavg),'linear');

    tavg(nt+1,:) = tavg(nt,:) + radheatrate * dt;
    tz1(nt+1,1) = tz1(nt,1) + (-radsurfaceflux) / heat_capacity * 3600 * 24 * dt;
    tz1(nt+1,2:nlayers+1) = interp1(log(pavg(1:nlayers)), tavg(nt+1,:), log(pz1(2:nlayers + 1)),'linear','extrap');
end