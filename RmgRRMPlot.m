function y=RmgRRMPlot(RmgData,varargin);

% y = RmgARMPlot(Rmg)
%
% generates a RRM acquisition plot for Rmg, where Rmg can be either an Rmg structure or a RRM structure.
%
% Last updated by Robert E. Kopp, March 1 2008
% Copyright (C) 2008 Robert E. Kopp, licensed under GNU GPL v.3

	inputOk=0;
	fields=fieldnames(RmgData);
	if sum(strcmpi(fields,'experiment'))
		if strmatch('RRM',RmgData(1).experiment)
			inputOk=1;
			RRM=RmgData;
		end
	elseif sum(strcmpi(fields,'steptypes'))
		if strmatch('RRM',RmgData(1).steptypes)		
			inputOk=1;
			count=0;
			for i=1:length(RmgData)
				curve=RmgRRMCurve(RmgData(i));
				for j=1:length(curve)
					if curve(j).doesExist
						count=count+1;
						RRM(count)=curve(j);
					end
				end
			end
		end
	else
		return;
	end
	
	if not(inputOk)
		return;
	end
		

linecolors={'k','g','b','r','c','m','y'};
linesyms={'.','x','o','+','*','s','d','v','^','>','<'};


legendstr={};

for i=1:length(RRM)
    if RRM(i).doesExist
        plot(RRM(i).spins,RRM(i).Brrm*10^6,[linecolors{mod(i,7)+1} linesyms{mod(i,11)+1} ]);
        legendstr={legendstr{:} [RRM(i).samplename]};
        hold on;
    end
end

if sum([RRM.doesExist])>0
    if length(RmgData)>1
        legend(legendstr,'Location','Northwest');
        titleSuffix='';
    else
        titleSuffix=[': ' RRM(1).samplename];
    end
    xlabel ('Spin (Hz)');
    ylabel ('B_{RRM} (\muT)');
    title(['RRM' titleSuffix]);
else
    axis off;
end