matRockmag

by Robert E. Kopp  
March 28, 2007  
Licensed under the terms of the GNU General Public License

Released as electronic supplementary material for:

	R. E. Kopp (2007), The Identification and Interpretation of Microbial Biogeomagnetism.
	Ph.D. Thesis, Division of Geological and Planetary Sciences, California Institute of Technology.

*****

## Contents:
	1. Requirements
	2. Basic Usage (GUI)
	3. Function Definitions
	4. Experimental Function Definitions

*****

## REQUIREMENTS

matRockmag was produced in MATLAB 7.1. For basic function, it requires no toolboxes; for
some of the experimental functions, it uses the Curve Fitting toolbox.

## BASIC USAGE (GUI)

Most functions of matRockmag can be accessed through the matRockmag GUI. Once matRockmag is installed
in the MATLAB path, the GUI can be launched by typing 'matRockmag' (sans quotes) at the command line.

Then:

	(1) Load the target data files into memory.
		(a) Navigate to the data directory by clicking on the "..." button next to the
		    File Path field, then using the dialog box that pops up.
		(b) Highlight the data files to load.
		(c) Click "Load Files". The loaded data sets will then be listed in the "Loaded Data" list.
		
	(2) Select the data files on which to operate. On a Mac, hold down Command to select multiple
	    files; on Windows, hold down Ctrl.
	    
	(3) Select the plots to make from the "Plots to make" list.
	
	(4) Select any desired options.
			
			By default, each plot for each data set will be in its own MATLAB figure.
			
			"Plot as Subplots" will create a single figure with subplots for each data sets.
			
			"Multiple samples per plot" will overlay data sets.
			
			"Auto-save as .fig" and "Auto-save as .eps" will save the figures automatically.
			
			Specify an AF level in "AF level" if you have ARM or RRM sequences in the data
			at multiple AF levels; otherwise leave as "0".
			
			The text in "File prefix" will be appended to any auto-saved file names.
			
			"Write stats to file" will create a file with the .asc suffix containing a table of rock
			magnetic parameters.
			
	(5) Click "Run".

## FUNCTION DEFINITIONS

META FUNCTIONS

RmgBatchPlotter(RmgData,Routines,[option1, [option2, [...]]])

This function is the backend underlying the matRockmag GUI and can produce the same sets
of plots.

	RmgData: A RmgData structure or array of such structures.
	Routines: A cell array containing strings specifying plots to be produced. Options are:
		'IRM', 'dIRM', 'ARM', 'LowrieFuller', 'AF', 'Fuller', 'RRM', 'Backfield', 'StatBox'.
	options:
		'Multisample' - overlay samples
		'Subplots' - plot different routines as subplots
		'AutosaveEPS'
		'AutosaveFIG'
		'AFLevel' - use next parameter in options as AF level for ARM, RRM
		'FilePrefix' - append next parameter to autosave file names

RMGImport(filename)

Produces a RmgData structure from the RMG file specified by filename.

RmgStats(RmgData,[AFLevel])

Returns structure with parameters determined from RmgData.

RmgStatsTableWrite(RmgData,filename)

Write parameters determined from array of data structures in RmgData to filename.

CURVE FUNCTIONS

RmgARMCurve(RmgData,[AFLevel])

Returns a structure containing the ARM acquisition level. IF AFLevel is specified, it finds
an ARM curve acquired at that AF level; otherwise, it finds the last performed ARM curve in
RmgData.

RmgExtractAFOfStep(RmgData,stepnum,[options])

Produces a structure containing the AF demagnetization of step specified by step number.
Options can be 'AFMaxSubtract' and 'noAFMaxSubtract'. If the former (which is the default),
then the moment of the AFmax step that precedes the target step (if available) or follows
the target step (if not) will be subtracted from the moments of the AF curve.

RmgFullerCurves(RmgData,[AFLevel])

Returns demagnetization of IRM, NRM, and ARM, and ARM and NRM demag curves interpolated
so that the demagnetization fields are the same as those of the IRM.

RmgIRMBackfieldCurve(RmgData)

Returns structure with IRM backfield curve.

RmgLowrieFullerCurves(RmgData,[AFLevel])

Returns demagnetization of ARM and IRM imparted at level of ARM AF field.

RmgRRMCurve(RmgData,[AFLevel])

Returns RRM curve.

PLOT FUNCTIONS

RmgARMPlot(RmgData,[AFLevel])

Plots the ARM acquisition curve in RmgData, optionally finding the ARM curve acquired in
AF field of strength AFLevel.

RmgBackfieldPlot(RmgData)

Plots backfield IRM curve.

RmgFullerPlot(RmgData,[AFLevel])

Produces a Fuller plot.

RmgLowrieFullerDerivativePlot(RmgData,[AFLevel, [option1, [option2, ...]]])

Plots derivative of AF of ARM and of IRM imparted at level of IRM; and optionally of NRM and RRM if present. Options are:
	'MultiAF' - plot NRM and RRM if present
	'ARMOnly' - plot ARM only (not IRM)
	
RmgLowrieFullerDerivativePlot(RmgData,[AFLevel, [option1]])

Plots AF of ARM and of IRM imparted at level of IRM; and optionally of NRM and RRM if present. Option is:
	'MultiAF' - plot NRM and RRM if present

RmgRRMPlot(RmgData,[AFLevel])

Plots RRM as function of spin speed.

RmgSIRMCurve(RmgData)

Plots SIRM acquisition curve and demagnetization curve.

RmgSIRMDerivativePlot(RmgData,[option1, [option2]])

Plots derivative SIRM acquisition curve and demagnetization curve. Options are:
	'AFOnly' - demagnetization curve only
	'AcqOnly' - acquisition curve only
	'SmoothOnly' - show only smoothed lines, not data points

RmgStatBox(RmgData)

Produces statistics box.

FMRRmgStatDepthProfiles(RmgData,Rmgdepths,FMRdata,FMRdepths,plots,[massfactor,[linespec,[opts]]])

	Requires that matFMR be installed in the MATLAB path if FMR	parameters are called.
	
	Constructs profile subplots of parameters vs. depth.
	
	RmgData: Array of rock magnetic data (produced by matRockmag through RmgImport). Can be
			 left as empty array [].
	Rmgdepths: Depth of each member of RmgData.
	FMRdata: Array of FMR data. Can be left as empty array [].
	FMRdepths: Depth of each member of FMRdata.
	massfactor: Mass factor by which to multiply rock magnetic parameter to produce kg
				normalized parameters. Defaults to 10^6 (i.e., assumes 'vol' field of
				rock magnetic data is mass in mg).
	linespec: MATLAB-style line spec
	opts: 'smooth' will cause the curve to be smoothed.
	plots: Cell array of strings identifying each parameter to be profiled. Any 
		   string not recognized will produced a blank subplot. Options are:
		   		'sirm/vol' - ratio of SIRM to volume/mass
		   		'logsirm/vol' - ratio of SIRM to volume/mass, plotted on log scale
		   		'armsuscep' - ARM susceptibility
		   		'arm100/irm' - ratio of ARM at 100 uT to IRM
		   		'arm500/irm' - ratio of ARM at 500 uT to IRM
		   		'dfirm/db' - value of the derivative of IRM at the max field value
		   		'armsuscep/irm' - ratio of ARM susceptibility to IRM
		   		'cisowskir' - Cisowski R parameter
		   		'hcr' - Hcr, determined from IRM acquisition and AF
		   		'irm30/irm100' - ratio of IRM at 30 mT to IRM at 100 mT
		   		'irm100/irm300' - ratio of IRM at 100 mT to IRM at 300 mT
		   		'maf-irm' - median acquisition field of IRM
		   		'mdf-irm' - median destructive field of IRM
		   		'mdf-arm' - median destructive field of ARM
		   		'mdf-irmtoarm' - ratio of MDF of IRM to MDF of ARM
		   		'mdf-arm-mdf-irm' - difference between MDF of ARM and MDF of IRM
		   		'dp-irmacq' - dispersion parameter of IRM acquisition spectrum
		   		
		   		'fmrabs' - total FMR absorption 
				'geff' - effective g value
				'dbfwhm' - full-width half maximum
				'db95' - width around median integrated FMR absorption containing 95% of absorption
				'a' - asymmetry ratio A
				'alpha' - factor alpha
				'mnii' - estimated Mn(II)
				'feiii' - estimated paramagnetic Fe(III)
				'frc' - estimated free radicals
				'mnii/total' - ratio of estimated Mn(II) to total absorption
				'feiii/total' - ratio of estimated paramagnetic Fe(III) to total absorption
				'frc/total' - ratio of estimated free radicals to total absorption
				'frc/mnii' - ratio of estimated free radicals to estimated Mn(II)
				'feiii/mnii' - ratio of estimated Fe(III) to Mn(II)
				'sirm/fmrabs' - ratio of SIRM to total absorption
				'logsirm/fmrabs' - ratio of SIRM to total absorption, log scale
				'armsuscep/fmrabs' - ratio of ARM susceptibility to total absorption



## EXPERIMENTAL FUNCTION DEFINITIONS

These routines are experimental.

CODICAErrorSmoothing(x,y, [smoothSpan, [smoothOrder]])

Smooths curve specified by x and y following the CODICA method of Egli (2003).

fitSGG(x, y, [numberSGGs])

Fits the curve specified by x and y to the number of skewed generalized Gaussians
(after Egli, 2003) specified by numberSGGs. numberSGGs defaults to 1.

fitSGGComps(x,y,means,stds,qs, ps)

Fits the curve specified by x and y to the skewed generalized Gaussians with
components specified by the parameters in arrays means, stds, qs, and ps.

fitSGGMulti(x,y, [maxn])

Attempts to auto-fit the curve specified by x and y to different numbers of
skewed generalized Gaussians, up to a maximum of 5 or a smaller number specified
by maxn.

SGG(xvalues,mvalues,svalues,qprimevalues,pvalues)

Generates a skewed generalized Gaussian (after Egli, 2003).