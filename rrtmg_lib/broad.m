function wbrodl=broad(pz1, wkl)
% Calculate column density
    Na = 6.02e23;
    gravity = 9.8;
    wvvmr = wkl(1, :);
    amm = (1 - wvvmr) * 28.966 + wvvmr * 18.016; % The molecular weight of moist air
    dp = pz1(1:length(pz1) - 1) - pz1(2:length(pz1));
    dry_air = dp * 1e3 * Na ./ (1e2 * gravity * amm .* (1 + wvvmr));
    summol = wkl(2, :) + wkl(3, :) + wkl(4, :) + wkl(5, :) + wkl(6, :) + wkl(7, :);
    wbrodl = dry_air .* (1 - summol);
end