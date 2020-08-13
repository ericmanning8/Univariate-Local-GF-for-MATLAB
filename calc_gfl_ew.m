% Estimate GF L(d) assuming weighted edge corrections -> method given by Goreaud and Pelissier (1998)

function gf_l = calc_gfl_ew(x1, y1, t_incr, last_t, n, bin)

    xmin = min(x1);
    ymin = min(y1);
    xmax = max(x1); 
    ymax = max(y1);  
    area = (xmax - xmin) * (ymax - ymin);

    dx = 0;
    dy = 0;
    dx2 = 0;
    dy2 = 0;
    dij = 0; % dist to boundary buffers.
    edge_wgt = 0;
    method = 0; % Edge correction factor.

    gf_l = zeros(n, n); % perallocate gf_l vector size to all zeros

    if (last_t < 0)
        last_t = 0;
    end

    for i = 1:n % Loop through all points
    
        for j = 1:n
        
            if (((abs(x1(i) - x1(j)) < t_incr) && (abs(y1(i) - y1(j)) < t_incr)))
            
                dij = EuclDistance(x1(i), y1(i), x1(j), y1(j)); % Distance between points

                if ((dij <= t_incr && dij > last_t && i ~= j))
                
                    dx = dist_x(x1(i), xmin, xmax); 
                    dy = dist_y(y1(i), ymin, ymax); % Distance to boundaries
                    dx2 = max(xmax - x1(i), x1(i) - xmin); 
                    dy2 = max(ymax - y1(i), y1(i) - ymin);

                    method = assess_edge(dij, dx, dy, dx2, dy2);

                    if (method == 0)
                        edge_wgt = 1;
                    elseif (method == 1)
                        edge_wgt = edge_corr1(min(dx, dy), dij);
                    elseif (method == 2)
                        edge_wgt = edge_corr2(dx, dy, dx2, dy2, dij);
                    elseif (method == 3)
                        edge_wgt = edge_corr3(dx, dy, dx2, dy2, dij);
                    end

                    gf_l(i, bin) = gf_l(i, bin) + edge_wgt; % Update value of GF l(d)

                end
            end
        end

        if (bin == 1)
            gf_l(i, bin) = area * (gf_l(i, bin) / ((n - 1))); % Final GF L value for i at bin
        else
            gf_l(i, bin) = gf_l(i, bin - 1) + area * (gf_l(i, bin) / ((n - 1)));% Final GF L value for i at bin
        end

    end
    
end