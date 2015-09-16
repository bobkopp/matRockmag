function y=RmgLowrieFullerDerivativePlot(RmgData,varargin)

% y = RmgLowrieFullerPlot(Rmg,[MultiAF])
%
% generates a Lowrie-Fuller or multi-AF demag derivative plot for Rmg, where Rmg can be either an Rmg structure or an array of AFs.
%
% Last updated by Robert E. Kopp, March 1 2008
% Copyright (C) 2008 Robert E. Kopp, licensed under GNU GPL v.3

	doMultiAF=0;
	
	if nargin>1
	    if varargin{1}
	        doMultiAF=1;
	    else
	        doMultiAF=0;
	    end
	end

	inputOk=0;
	fields=fieldnames(RmgData);
	if sum(strcmpi(fields,'experiment'))
		if strmatch('AF',RmgData(1).experiment)
			inputOk=1;
			AF=RmgData;
		end
	elseif sum(strcmpi(fields,'steptypes'))
		if strmatch('IRM',RmgData(1).steptypes)		
			inputOk=1;
			count=0;
			for i=1:length(RmgData)
			    Curves=RmgLowrieFullerCurves(RmgData(i));
			    for j=1:length(Curves)
				    if Curves(j).ARMAF.doesExist
					    count=count+1;
					    AF(count)=Curves.ARMAF;
				    end
				    if Curves(j).IRMAF.doesExist
					    count=count+1;
					    AF(count)=Curves.IRMAF;
				    end
		 	    end
			    if doMultiAF
			        FullerCurves=RmgFullerCurves(RmgData(i));
			        if FullerCurves.doesExist
				        count=count+1;
				        AF(count)=FullerCurves.NRM;
			        end
			    end
			end
		end
	else
		return;
	end


linecolors={'g','b','r','y','c','m'};
linesyms={'.','x','o','+','*','s','d','v','^','>','<'};

legendstr={};

if length(RmgData)==1
    titleSuffix=[': ' RmgData(1).samplename];
    RmgData(1).samplename='';
else
    titleSuffix='';
end

for i=1:length(AF)
	plot(AF(i).log10treatmentAFderivFields + 3,AF(i).mzlogderiv,[linecolors{mod(i,6)+1} linesyms{mod(i,11)+1} '-']);
	hold on;
	legendstr={legendstr{:} [AF(i).samplename ' ' AF(i).targetStep.steptype]};
end

if length(AF)>0
    legend(legendstr,'Location','Northeast');
    xlabel('B (mT)');
    ylabel('frac. mag.');
    if doMultiAF
        title(['AF' titleSuffix]); 
    else
        title(['Lowrie-Fuller' titleSuffix]);
    end
else
    axis off;
end




