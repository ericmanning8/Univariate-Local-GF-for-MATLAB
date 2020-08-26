function test_main()
    % file IO
    fileName = 'FullStackDriftOvercountCorrectedSieved.xlsx'; % Enter file name here 
    data = xlsread(fileName, 'Sheet4');
    
    % input data 
    x1 = data(:,1);
    y1 = data(:,2); 
    
    % variables 
    points = length(x1);
    xmin = min(x1);
    ymin = min(y1);
    xmax = max(x1); 
    ymax = max(y1); 
    t = 0.1;
    max_step = 1000;
    interval = true; 
    n_simul = 100;
    limit = 1000000;
    edge_method = 1;
    testname = "Univariate Getis and Franklin's L";
    t_incr = 0;
    bins = ceil(max_step / t) + 1;
    
    if ((bins * t) > (max_step + t))
        bins = bins - 1;
    end
    
    % data structures 
    gf_l = zeros(points + 1, bins + 1);
    gfl_global = zeros(1, bins + 1);
    gfl_var = zeros(1, bins + 1);
    
    % bypass checkscale, sort and label functions 
    
    area = (xmax - xmin) * (ymax - ymin);

    i = 1;
    wb = waitbar(0, 'Computing Local Clustering Function...');
    while (i <= bins)
        percentDone = (t_incr / max_step);
        waitbar(percentDone, wb);
            
        if (edge_method == 1)
            calc_gfl(gf_l, x1, y1, t_incr, i, points, area);
        elseif (edge_method == 2)
            gf_l(:, i) = calc_gfl_ew(x1, y1, t_incr, (t_incr - t), points, area);
        end
            
        i = i + 1; 
        t_incr = t_incr + t;
    end

    % Correct so that L(d) = d under CSR
    for i = 1:points
    
        for j = 1:bins
            gf_l(i, j) = Sqr(gf_l(i, j) / pi);
        end
    end

    % Now do the Average and CI calculations for the global statistic ...
    if (n_simul > 0 && interval == true)
    
        ave_cols_array(gf_l, gfl_global, points, bins);
        var_cols_array(gf_l, gfl_var, points, bins);

        buffer_gfl = new (points + 1, bins + 1);
        ave_buffer = new (bins + 1);


        all_rep_buffer = new (bins + 1, n_simul + 1);
        Initialise2d(all_rep_buffer, -999999999, bins, n_simul);

        x_rnd = (points + 1);
        y_rnd = (points + 1);

        for rep = 1:n_simul
        
            Initialise2d(buffer_gfl, 0, points, bins);
            percentDone = Conversion.Int((rep / n_simul) * 100);

            if (bygroups == false)
                Application.StatusBar = "Calculating " + testname + " CIs " + percentDone + "% completed.";
            else
                Application.StatusBar = "Calculating " + testname + " CIs for group " + group + ": " + percentDone + "% completed.";
            end
            
            generate_csr(x_rnd, y_rnd, xmin, ymin, xmax, ymax, points);
            i = 1; 
            t_incr = 0;

            while (i <= bins)
            
                if (edge_method == 1)
                    calc_gfl(buffer_gfl, x_rnd, y_rnd, t_incr, i, points, area);
                elseif ((edge_method == 2))
                    calc_gfl_ew(buffer_gfl, x_rnd, y_rnd, t_incr, (t_incr - t), points, i, xmin, ymin, xmax, ymax, area);

                i = i + 1; t_incr = t_incr + t;
                end
            end

            % Correct so that L(d) = d under CSR
            for i = 1:points
                for j = 1:bins
                    buffer_gfl(i, j) = Sqr(buffer_gfl(i, j) / pi);
                end
            end

            % Average it here across all points and add to all_rep_buffer ...
            Initialise(ave_buffer, 0, bins);
            ave_cols_array(buffer_gfl, ave_buffer, points, bins);

            i = 1;
            while (i <= bins)
                all_rep_buffer(i, rep) = ave_buffer(i);
                i = i + 1; t_incr = t_incr + t;
            end
        end

        sort_rows_array(all_rep_buffer, bins, n_simul);

        low_list = (bins + 1);
        high_list = (bins + 1);

        extract_limits(all_rep_buffer, low_list, high_list, bins, n_simul, limit);
    end
end
