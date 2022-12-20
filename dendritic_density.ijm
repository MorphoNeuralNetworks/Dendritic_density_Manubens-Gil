height = getHeight();
tolerance = 30;
increment = 5;
ddens = newArray(height/increment+2);
dist = newArray(height/increment+2);
setTool("polyline");
waitForUser("Press ok when you have drawn the line (on the middle of the pyramidal layer)");
run("Fit Spline", "straighten"); 
getSelectionCoordinates(x, y);
y0 = Array.copy(y);
d=0;
y = Array.copy(y0);
y0_stats = Array.getStatistics(y0, min, max, mean, stdDev) 
for (i=0; i<y.length; i++) {
	y[i] = y[i] - y0_stats[0]; 
}
makeSelection("polyline", x, y);
run("Fit Spline", "straighten"); 
profile = getProfile(); 
maxima = Array.findMaxima(profile, tolerance);
ddens[d] = maxima.length;
dist[d] = - y0_stats[0];
y_stats = Array.getStatistics(y, min, max, mean, stdDev) 
while (y_stats[1] < height){ 
	for (i=0; i<y.length; i++) {
		y[i] = y[i] + increment; 
	}
	makeSelection("polyline", x, y);
	y_stats = Array.getStatistics(y, min, max, mean, stdDev);
	d += 1;
	run("Fit Spline", "straighten"); 
	profile = getProfile();
	maxima = Array.findMaxima(profile, tolerance);
	ddens[d] = maxima.length;
	dist[d] = 1 - y0_stats[0] + d*increment;
}
Plot.create("Layer Sholl analysis","Distance to soma layer","Number of intersections",dist,ddens);
Fit.doFit("8th Degree Polynomial",dist,ddens);
Fit.plot;