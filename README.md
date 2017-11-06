# rrtmg_libraries
This project consists of two libraries:
- rrtmg_input_erai_lib for convenient way to read data from ERA Interim reanalysis, standard profiles and CERES dataset,
- rrtmg_lib to make input files for Rapid Radiative Transfer Model for GCM use (RRTMG).

Additionally, there are executable files of RRTMG (built for use on some Linux machines); examples of data and examples of use.
If the executable files of RRTMG don't work, see the instruction of compilation here:
http://rtweb.aer.com/rrtm_frame.html

Content
---------------
- atmos_profile: standard atmospheric profiles from http://eodg.atm.ox.ac.uk/RFM/atm/ (GHG concentrations)
- ceres: example of CERES SYN1deg dataset for MODIS cloud data (Observed cloud parameters: water and ice particle radii for low, mid-low, mid-high and high clouds)
https://ceres.larc.nasa.gov/products.php?product=SYN1deg

-- CERES_SYN1deg-3H_Terra-Aqua-MODIS_Ed3A_Subset_20010101-20010131_clouds_re.nc - example of global (1x1 grid) one month data with 3-hourly resolution

-- CERES_SYN1deg-3HM_Terra-Aqua-MODIS_Ed3A_Subset_200003-201609_clouds_re.nc - example of global (1x1 grid) climatological data with 3-hourly monthly resolution

- erai: example of one month ERA Interim reanalysis datasets (January 2001, N45-80, W50-180 with 0.75 grid)
http://apps.ecmwf.int/datasets/data/interim-full-daily/

-- erai-4xdaily_N80_N45_W50_W180_200101_profile.nc - example of dataset of temperature, ozone, specific humidity, cloud cover, cloud liquid water content and cloud ice water content profiles, 6-hourly resolution

-- erai-4xdaily_N80_N45_W50_W180_200101_surface.nc - example of dataset of skin temperature and surface pressure, 6-hourly resolution

-- erai-8xdaily_N80_N45_W50_W180_200101_falbedo.nc - example of dataset of forecast albedo, 3-hourly resolution

-- erai-8xdaily_N80_N45_W50_W180_200101_radiation.nc (optional) - example of dataset of solar and thermal radiation flux variables

- rrtmg: executable files of Rapid Radiative Transfer Model
- rrtmg_input_erai_lib: library of matlab functions for reading from all the above indicated datasets
- rrtmg_lib: library of matlab functions for making RRTMG input files
- profile_jan_0.inc: example of a textfile with atmospheric profiles necessary for RRTMG 
- example0.m: example of reading data with rrtmg_input_erai_lib
- example1.m: example of reading data with rrtmg_input_erai_lib and running RRTMG with rrtmg_lib
- example2.m: example of reading data from a textfile profile_jan_0.inc and running RRTMG with rrtmg_lib
- example3.m: example of reading data with rrtmg_input_erai_lib and running radiative-equilibrium single-column model with rrtmg_lib
