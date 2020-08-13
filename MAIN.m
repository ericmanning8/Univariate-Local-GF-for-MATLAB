%%% Main Script

% load data 
fileName = 'FullStackDriftOvercountCorrectedSieved.xlsx'; % Enter file name here 
data = xlsread(fileName, 'Sheet4');

x1 = data(:,1);
y1 = data(:,2);
st = 10;
max_step = 1000;
points = length(x1);

% choose method of edge correction
method = ChooseEdgeCorrection();

% perform GFL analysis 
if (method == 1) % NDF with edge corrections 
    gfl = calc_gfl_ew(x1, y1, st, max_step, points, 1);
else % without edge corrections 
    gfl = calc_gfl(x1, y1, st, max_step, points);
end

% display the NDF vector 
disp('GLF vector:');
disp(gfl(:,1));

% create a contour plot: 
figure(1);
contour(0:size(gfl(:,1)), 0:size(gfl(1,:)), gfl);