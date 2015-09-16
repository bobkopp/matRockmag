function y=RmgSIRMPlot(RmgData)

% y = RmgSIRMPlot(Rmg)
%
% generates a SIRM acquisition and demag plot for Rmg, where Rmg can be either an Rmg structure or a IRM structure.
%
% Last updated by Robert E. Kopp, March 1 2008
% Copyright (C) 2008 Robert E. Kopp, licensed under GNU GPL v.3

	inputOk=0;
	fields=fieldnames(RmgData);
	if sum(strcmpi(fields,'experiment'))
		if strmatch('SIRM',RmgData(1).experiment)
			inputOk=1;
			IRM=RmgData;
		end
	elseif sum(strcmpi(fields,'steptypes'))
		if strmatch('IRM',RmgData(1).steptypes)		
			inputOk=1;
			for i=1:length(RmgData)
				curve=RmgSIRMCurve(RmgData(i));
				best=length(curve);
				for j=1:length(curve)
					if curve(j).AF.doesExist
						best=j;
					end
				end
				IRM(i)=curve(best);
			end
		end
	else
		return;
	end


	linecolors={'k','g','b','r','c','m','y'};
	linesyms={'.','x','o','+','*','s','d','v','^','>','<'};
	
	
	legendstr={};
	
	for i=1:length(RmgData)
	    if IRM(i).doesExist
	        semilogx(IRM(i).IRM.treatmentDCFields*1000,IRM(i).IRM.fracmags,[linecolors{mod(i,7)+1} linesyms{mod(i,11)+1} '-']);
	        if length(IRM)>1
	            legendstr={legendstr{:} RmgData(i).samplename};
	        end
	        hold on;
	    end
	end
	
	if sum([IRM.doesExist])>0
	    if length(RmgData) > 1
	        legend(legendstr,'Location','Northwest');
	    
	        titleSuffix='';
	    else
	        titleSuffix=[': ' RmgData(1).samplename];
	    end
	    for i=1:length(IRM)
	        if IRM(i).AF.doesExist
	            semilogx(IRM(i).AF.treatmentAFFields*1000,IRM(i).AF.fracmags,[linecolors{mod(i,7)+1} linesyms{mod(i,11)+1} '-']);
	        end
	    end
	    xlabel ('B (mT)');
	    ylabel (['f_{SIRM}']);
	    title(['IRM' titleSuffix]);
	else
	    axis off;
	end
end