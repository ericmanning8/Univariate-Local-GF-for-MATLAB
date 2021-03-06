% Estimate GF L(d) assuming weighted edge corrections -> method given by Goreaud and Pelissier (1998)

function gf_l = calc_gfl_ew(gf_l, x1, y1, t_incr, last_t, n, bin, area)
    xmin = min(x1);
    ymin = min(y1);
    xmax = max(x1); 
    ymax = max(y1);  
    
    edge_wgt = 0;
    method = 0; % Edge correction factor.

    if (last_t < 0)  
        last_t = 0;
    end

    for i = 1:n        % Loop through all points
        for j = 1:n
            if ((abs(x1(i) - x1(j)) < t_incr) && (abs(y1(i) - y1(j)) < t_incr)) % Skip points outside bounding box (Fisher, 1990)

                dij = EuclDistance(x1(i), y1(i), x1(j), y1(j)); % Distance between points

                if (dij <= t_incr && dij > last_t && i ~= j) % if the point%s in the circle ...

                    % Distance to boundaries
                    dx = dist_x(x1(i), xmin, xmax);
                    dy = dist_y(y1(i), ymin, ymax) ; 
                    dx2 = max_val(xmax - x1(i), x1(i) - xmin);
                    dy2 = max_val(ymax - y1(i), y1(i) - ymin);

                    method = assess_edge(dij, dx, dy, dx2, dy2);

                    if method == 0  
                        edge_wgt = 1;
                    elseif method == 1  
                        edge_wgt = edge_corr1(min_val(dx, dy), dij);
                    elseif method == 2  
                        edge_wgt = edge_corr2(dx, dy, dx2, dy2, dij);
                    elseif method == 3  
                        edge_wgt = edge_corr3(dx, dy, dx2, dy2, dij);
                    end

                    gf_l(i, bin) = gf_l(i, bin) + edge_wgt; % Update value of GF l(d)

                end
            end
        end
        
        if bin == 1 
            gf_l(i, bin) = area * (gf_l(i, bin) / ((n - 1))); % Final GF L value for i at bin
        else
            gf_l(i, bin) = gf_l(i, bin - 1) + area * (gf_l(i, bin) / ((n - 1))); % Final GF L value for i at bin
        end  
    end
end