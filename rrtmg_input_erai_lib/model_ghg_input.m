function wkl = model_ghg_input(wkl_old, pz1, profile_name, indices)
    % initiate indicated species from a standard profile
    wkl = wkl_old;
    [~, pz, ~, wkl1] = read_standard_profile(profile_name,1);
    % get CO2, CO, N2O, CH4 mr from the standard profile
    for k = indices
        wkl(k,:) = interp1(log(pz), wkl1(k, :), log(pz1), 'linear', 'extrap');
    end
    wkl(7,:) = 0.209;
end