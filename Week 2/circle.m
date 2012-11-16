%function h = circle(x,y,r)
%source:
%http://www.mathworks.nl/support/solutions/en/data/1-15I2I/
function h = circle(x,y,r)

hold on
th = 0:pi/50:2*pi;
xunit = r * cos(th) + x;
yunit = r * sin(th) + y;
h = plot(xunit, yunit);
hold off