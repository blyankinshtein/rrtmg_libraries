%Calculate column density of broadening gases in each layer
function wbrodl=wbcd(tavg,pavg,wkl,depth)
    btz=1.380662*10^(-23); %boltzmann constant
    wvvmr=wkl(1,:);

    totair=pavg*10^(-4)./tavg/btz; % molecules/cm^2/m (P = n k T, 10^(-4) because molecule/cm^2/m)
    wv=totair.*wvvmr./(1+wvvmr); %molecules/cm^2/m derived if wvvmr is small
    dryair=totair-wv; %molecules/cm^2/m
    sumv=sum(wkl(2:7,1)); %sum of mixing ratios of all GHGs
    wb=dryair.*(1-sumv); % molecules/cm^2/m dry air without GHG??
    wbrodl=wb.*depth*100; % column density: molecule/cm^2. Why 100??

end


