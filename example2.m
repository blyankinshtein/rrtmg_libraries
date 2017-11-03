%% HOW TO READ DATA FROM YUWEI'S PROFILE AND RUN RRTMG_LW
%% path to executable rrtmg files
current_folder = pwd;
rrtmg_folder = [current_folder, '/rrtmg'];
%%
profile = load('profile_jan_0.inc');

nlayers = 40;

pavg = profile(1:nlayers, 2); %hPa
tavg = profile(1:nlayers, 3); %K

h2ovmr = profile(1:nlayers, 5) * 1e-6; 
co2 = 380*10^(-6);
o3vmr = profile(1:nlayers, 6) * 1e-6; 
n2ovmr = profile(1:nlayers, 7) * 1e-6; 
ch4vmr = profile(1:nlayers, 9) * 1e-6; 

wkl = zeros(7, nlayers);
wkl(1,:) = h2ovmr; %h2o
wkl(2,:) = co2;
wkl(3,:) = o3vmr; %o3
wkl(4,:) = n2ovmr; %n2o
wkl(5,:) = 1.5e-7; %co
wkl(6,:) = ch4vmr; %1.8ppm ch4
wkl(7,:) = 0.209 ;%o2 20.9%

pz1 = zeros(1, nlayers);
pz1(2:nlayers-1) = (pavg(2:nlayers-1) + pavg(3:nlayers)) / 2;
pz1(1) = pavg(1);
pz1(nlayers) = 0.5;
tz1 = interp1(log(pavg), tavg, log(pz1), 'linear', 'extrap');
pavg = pavg(2:nlayers);
tavg = tavg(2:nlayers);
wkl = wkl(:,2:nlayers);
%%
for var_name = {'cc', 'clwc', 'ciwc', 'rle', 'rie'}
    eval([var_name{1}, '= zeros(1, length(pz1));']);
end
%%
[lw_heatrate, ttr, lw_surfaceflux] = rrtmg_lw_run(rrtmg_folder, pz1, tz1, pavg, tavg, wkl, cc, clwc, ciwc, rie, rle);