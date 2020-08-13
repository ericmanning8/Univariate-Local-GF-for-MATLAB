% Points in nhb for k analysis ...
function inCircle = points_in_circle(xa, ya, xb, yb, max_d)

    if (EuclDistance(xa, ya, xb, yb) <= max_d)
        inCircle = true;
    else
        inCircle = false;
    end

end