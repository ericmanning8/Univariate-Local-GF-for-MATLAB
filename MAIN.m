%%% Main Script

% load data 
data;
x1 = data(:,1);
y1 = data(:,2);
st = 10;
max_step = 1000;
points = length(x1);

% choose method of edge correction
method = ChooseEdgeCorrection();

% perform GFL analysis 
if (method == 1) % NDF with edge corrections 
    gfl = calc_gfl_ew(x1, y1, st, max_step, points);
else % without edge corrections 
    gfl = calc_gfl(x1, y1, st, max_step, points);
end

% display the NDF vector 
disp('GLF vector:');
disp(gfl(:,1));

%create a contour plot: 
figure(1);
contour(x1,y1,gfl);