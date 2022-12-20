input = getDirectory("Choose input directory, which contains the directories of the samples with the segmented CA1 data"); 
output = getDirectory("Choose output directory, where measurements will be saved"); 

list = getFileList(input);
print(list.length);

for (a=0; a < list.length; a++){
	File.makeDirectory(output + list[a]);
	list1 = getFileList(input + list[a]);
	for (b=0; b < list1.length; b++){
		File.makeDirectory(output + list[a] + list1[b]);
		//run("Image Sequence...", "open=[" + input + list[a] + "\\" + list1[b] + "] sort");
		open (input + list[a] + list1[b]);
		filename2 = getTitle();
		filename = replace(filename2, ".tiff", "");
	
	    getDimensions( width, height, channels, slices, frames );
	    
		for(slice = 1; slice <= slices; slice++){
			
			Stack.setSlice( slice );
			
			File.makeDirectory(output +list[a] + "/" + "slice_" + slice);

			setTool("polyline");
			waitForUser("Press ok when you have drawn the line (on the middle of the pyramidal layer)");
			run("Fit Spline", "straighten"); 
	    	getSelectionCoordinates(x, y);
	    	y0 = Array.copy(y);
			
			d=0;
			y = Array.copy(y0);
			for (i=0; i<y.length; i++) {
				y[i] = y[i] - 240; //pixel size 0.64um, 240 pixels are 150 um.
		    }
			makeSelection("polyline", x, y);
	    	run("Clear Results");
	    	run("Fit Spline", "straighten"); 
	    	profile = getProfile(); 
	    	for (i=0; i<profile.length; i++){
	      		setResult("Value", i, profile[i]);
	    	}
	    	for (k=0; k<profile.length; k++){
		  		setResult("X", k, round(x[k]));
		  		setResult("Y", k, round(y[k]));
			}
	  		updateResults;
	    	saveAs("Results", output + list[a] + "/slice_" + slice + "/" + "profiles_" + d + ".txt");
	    
		    while (d<=1440){ //in total 900 um
		    	for (i=0; i<y.length; i++) {
					y[i] = y[i] + 8; //pixel size 0.64um, 8 pixels are 5 um.
		    	}
		    	makeSelection("polyline", x, y);
		    	d +=8;
				run("Clear Results");
				run("Fit Spline", "straighten"); 
				profile = getProfile(); 
				for (k=0; k<profile.length; k++){
		  			setResult("Intensity", k, profile[k]);
				}
				for (k=0; k<profile.length; k++){
		  			setResult("X", k, round(x[k]));
		  			setResult("Y", k, round(y[k]));
				}
				updateResults;
				d2=d*0.64;
				saveAs("Results", output + list[a] + "/slice_" + slice + "/" + "profiles_" + d + ".txt");
			}
		}
	    close();
	}
}
