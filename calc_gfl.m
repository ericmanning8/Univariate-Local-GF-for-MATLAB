% Estimate GF L(d) assuming NO edge corrections

function  calc_gfl(gf_l, x1, y1, t_incr, bin, n, area)

    for i = 1:n %Loop through all points
        for j = 1:n
            if ((abs(y1(i) - y1(j)) < t_incr) && (abs(x1(i) - x1(j)) < t_incr)) % Skip i=j and end loop when distance between i and j too big (assumed lists ordered)

                if ( (i ~= j) && (points_in_circle(x1(i), y1(i), x1(j), y1(j), t_incr) == true) )
                    gf_l(i, bin) = gf_l(i, bin) + 1; %Update value of GF l(d)
                end

            end
        end 
    
        gf_l(i, bin) = sqrt(area * gf_l(i, bin) / (pi * (n - 1))); %Final GF L value for i at bin

    end
end
