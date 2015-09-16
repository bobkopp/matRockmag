function y=RmgBackfieldPlot(RmgData)

% y = RmgBackfieldPlot(Rmg)
%
% generates a Backfield plot for Rmg, where Rmg can be either an Rmg structure or a backfield structure.
%
% Last updated by Robert E. Kopp, March 1 2008
% Copyright (C) 2008 Robert E. Kopp, licensed under GNU GPL v.3

inputOk=0;
fields=fieldnames(RmgData);
if sum(strcmpi(fields,'experiment'))
	if strmatch('IRMBackfield',RmgData(1).experiment)
		inputOk=1;
		IRM=RmgData;
	end
elseif sum(strcmpi(fields,'steptypes'))
	if strmatch('IRM',RmgData(1).steptypes)		
		inputOk=1;
		for i=1:length(RmgData)
				curve=RmgIRMBackfieldCurve(RmgData(i));
				if curve(end).doesExist
					IRM(i)=curve(end);
				end
		end
	end
else
	return;
end

linecolors={'k','g','b','r','c','m','y'};
linesyms={'.','x','o','+','*','s','d','v','^','>','<'};
legendstr={};

for i=1:length(IRM)
    if IRM(i).doesExist
        
        if IRM(i).Demag.mvector(3,1) < 0
            %Modification added in by Isaac Hilburn - 2/17/2008 - to fix 
            %backfield IRM curves that are plotted in the opposite orientation
            %as the rest of the backfield IRM curves.  Field should go from
            %max field to min field barring something really weird from
            %occuring in the data
            IRM(i).Demag.mvector(3,:) = -1 * IRM(i).Demag.mvector(3,:)
        end
        
               
        plot(IRM(i).Demag.treatmentDCFields*1000,IRM(i).Demag.mvector(3,:)/IRM(i).Demag.mass,[linecolors{mod(i,7)+1} linesyms{mod(i,11)+1} '-']);
        legendstr={legendstr{:} RmgData(i).samplename};
        hold on;
    end
end

if sum([IRM.doesExist])>0
    if length(RmgData)>1
        legend(legendstr,'Location','Best');
        titleSuffix='';
    else
        titleSuffix=[': ' RmgData(1).samplename];
    end
    xlabel('-B (mT)');
    %Modification by Isaac Hilburn - 2/17/2008
    %Changed label on the graph to indicate the correct SI units
    %Used to be 'emu'
    ylabel( 'Am^2 / kg');
    title (['Backfield IRM' titleSuffix]);
else
    axis off;
end
