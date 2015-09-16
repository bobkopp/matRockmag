function y=RMGImport(filenam)

% y = RMGImport(filename)
%
% returns an Rmg structure for file specified by filename.
%
% Last updated by Robert E. Kopp, March 1 2008
% Copyright (C) 2008 Robert E. Kopp, licensed under GNU GPL v.3

	mu0=4*pi*1e-7;
	GaussConvert=1e-4;
	OerstedConvert=1e-4/mu0;
	emuConvert=1e-3;
	cmConvert=0.01;
	gramConvert=1e-3;	

	fid=fopen(filenam);
	datarows=textscan(fid,'%s','delimiter','\n');
	fclose(fid);
	
	y.datrows=datarows{1};
	y.titlerow=y.datrows{1};
	y.headerrow=y.datrows{2};
	y.datarows={y.datrows{3:length(y.datrows)}};
	
	k=1;
	rem=y.titlerow;
	done=0;
	while done==0
	   [y.titledat{k},rem]=strtok(rem,',');
	   if isempty(y.titledat{k})
	       done=1;
	   end
	   if findstr('Vol:',y.titledat{k}) | findstr('Mass:',y.titledat{k})
	       y.mass=str2num(strtok(y.titledat{k},'Vol:'));
	   end
	   k=k+1;
	end
	y.samplename=y.titledat{1};
	y.sampledesc=y.titledat{2};
	
	k=1;
	done=0;
	rem=y.headerrow;
	while done==0
	   [y.headerdat{k},rem]=strtok(rem,',');
	   if isempty(y.headerdat{k})
	       done=1;
	   end
	   if findstr('Level',y.headerdat{k})
	       y.col.level=k;
	   end
	   if findstr('Bias',y.headerdat{k})
	       y.col.bias=k;
	   end
	   if findstr('Spin',y.headerdat{k})
	       y.col.spin=k;
	   end
	   if findstr('Mz ',y.headerdat{k})
	       y.col.mz=k;
	   end
	   if findstr('Mx',y.headerdat{k})
	       y.col.mx=k;
	   end
	   if findstr('My',y.headerdat{k})
	       y.col.my=k;
	   end
	   if findstr('Suscep',y.headerdat{k})
	       y.col.suscep=k;
	   end
	   if findstr('Mz/Vol',y.headerdat{k}) |  findstr('Mz/Mass',y.headerdat{k})
	       y.col.mzperkg=k;
	   end
	   if findstr('Date/Time',y.headerdat{k})
	   	   y.col.datetime=k;
       else
           y.col.datetime=NaN;
       end
	   if findstr('emu',y.headerdat{k})
	       y.convertedFromCGS=1;
	   end
	
	   k=k+1;
	end
	
	
	[y.steptypes,rem]=strtok(y.datarows,',');
	y.stepcol=strvcat(y.steptypes{:});
	for k=1:length(y.headerdat)
	   [y.datstrings{k},rem]=strtok(rem,',');
	end
	y.levels=str2num([y.datstrings{y.col.level}{:}]);
	y.bias=str2num([y.datstrings{y.col.bias}{:}]);
	y.spin=str2num([y.datstrings{y.col.spin}{:}]);
	if isfinite(y.col.datetime)
        y.datestrings=y.datstrings{y.col.datetime};
    end
	y.mz=str2num([y.datstrings{y.col.mz}{:}]);
	y.mzperkg=str2num([y.datstrings{y.col.mzperkg}{:}]);
	
	y.mx=y.mz*0;
	y.my=y.mz*0;
	
	if isfield(y.col,'mx')
	    y.mx=str2num([y.datstrings{y.col.mx}{:}]);    
	end
	if isfield(y.col,'my')
	    y.my=str2num([y.datstrings{y.col.my}{:}]);    
	end
	if isfield(y.col,'suscep')
	    y.suscep=str2num([y.datstrings{y.col.suscep}{:}]);    
	end
	
	y.stepsAFmax=strmatch('AFmax',y.stepcol);
	y.stepsAFz=strmatch('AFz',y.stepcol);
	y.stepsAFxyz=strmatch('AF',y.stepcol,'exact');
	y.stepsAF=sort(union(y.stepsAFz,y.stepsAFxyz));
	y.stepsIRM=strmatch('IRM',y.stepcol);
	y.stepsARM=strmatch('ARM',y.stepcol);
	y.stepsRRM=strmatch('RRM',y.stepcol);
	y.stepsThermal=union(strmatch('TT',y.stepcol),strmatch('TRM',y.stepcol));
	y.stepsNRM=strmatch('NRM',y.stepcol);
	
	y.treatmentTemps=298*ones(1,length(y.levels));
	y.treatmentTemps(y.stepsThermal)=y.levels(y.stepsThermal);
	lN2Steps=intersect(y.stepsThermal,find(y.levels==77));
	y.treatmentTemps(lN2Steps)=77;
	
	y.treatmentAFFields=zeros(1,length(y.levels));
	stepsWithAF=union(y.stepsAF,y.stepsARM);
	stepsWithAF=union(stepsWithAF,y.stepsRRM);
	y.treatmentAFFields(stepsWithAF)=y.levels(stepsWithAF);
	
	y.treatmentDCFields=y.bias;
	y.treatmentDCFields(y.stepsIRM)=y.treatmentDCFields(y.stepsIRM)+y.levels(y.stepsIRM);
	
	if y.convertedFromCGS
	    y.treatmentAFFields=y.treatmentAFFields*GaussConvert;
	    y.treatmentDCFields=y.treatmentDCFields*GaussConvert;
	    y.bias=y.bias*GaussConvert;
	    y.mx=y.mx*emuConvert;
	    y.my=y.my*emuConvert;
	    y.mz=y.mz*emuConvert;
	    y.mzperkg=y.mzperkg*emuConvert;
	end
	
	if strmatch('mass in mg',y.titlerow)
		y.originalMassUnits='mg';
		y.mass=y.mass/1e6;
		y.mzperkg=y.mzperkg*10^6;
	else
		y.originalMassUnits='g';
		y.mzperkg=y.mzperkg*10^3;
		y.mass=y.mass/1e3;
	end
	
	y.mvector=[y.mx;y.my;y.mz];
	y.mvectorperkg=y.mvector/y.mass;
	
	
	stepTypes=y.steptypes;
	
	i=1;
	if strcmpi('AFz',stepTypes{i})
		stepTypes{i} = 'AF';
	elseif strcmp('TAF',stepTypes{i})
		stepTypes{i} = 'AF';
	end
	
	
	y.stepBlock(1) = 1;
	y.BlockType{i} = stepTypes{1};
	y.BlockSize(1) = 1;
		
	for i=2:length(stepTypes)
		if strcmpi('AFz',stepTypes{i})
			stepTypes{i} = 'AF';
		elseif strcmp('TAF',stepTypes{i})
			stepTypes{i} = 'AF';
		end
		if not(strcmpi(stepTypes{i-1},stepTypes{i}))
			y.stepBlock(i) = y.stepBlock(i-1)+1;
			y.BlockType{y.stepBlock(i)} = stepTypes{i};
			y.BlockSize(y.stepBlock(i)) = 1;
	
		else
			y.stepBlock(i) = y.stepBlock(i-1);
			y.BlockSize(y.stepBlock(i)) = y.BlockSize(y.stepBlock(i)) + 1;	
		end
	end
	
end
