function y=RmgFullerPlot(RmgData,varargin)

% y = RmgFullerPlot(Rmg)
%
% generates a Fuller plot, where Rmg can be either an Rmg structure or a Fuller structure.
%
% Last updated by Robert E. Kopp, March 1 2008
% Copyright (C) 2008 Robert E. Kopp, licensed under GNU GPL v.3

inputOk=0;
fields=fieldnames(RmgData);
if sum(strcmpi(fields,'experiment'))
	if strmatch('Fuller',RmgData(1).experiment)
		inputOk=1;
		FullerCurves=RmgData;
	end
elseif sum(strcmpi(fields,'steptypes'))
	if strmatch('IRM',RmgData(1).steptypes)		
		inputOk=1;
		for i=1:length(RmgData)
			    FC=RmgFullerCurves(RmgData(i));
			    if FC.doesExist
			    	FullerCurves(i).doesExist=1;
			    	FullerCurves(i).NRM=FC.NRM;
			    	FullerCurves(i).IRM=FC.IRM;
			    	FullerCurves(i).ARM=FC.ARM;
			    	FullerCurves(i).trialFields=FC.trialFields;
			    	FullerCurves(i).calcNRM=FC.calcNRM;
			    	FullerCurves(i).calcIRM=FC.calcIRM;
			    	FullerCurves(i).calcARM=FC.calcARM;
			    else
			    	FullerCurves(i).doesExist=0;
			    end
		end
	end
else
	return;
end


linecolorsNRM={'g','b','r'};
linecolorsARM={'y','c','m'};
linesyms={'.','+','*','^'};

legendstr={};

if length(RmgData)==1
    titleSuffix=[': ' RmgData(1).samplename];
    RmgData(1).samplename='';
else
        titleSuffix='';
    
end

countNRM=0;
countARM=0;
for i=1:length(FullerCurves)
   
    if FullerCurves(i).doesExist
        if FullerCurves(i).NRM.doesExist
        		countNRM=countNRM+1;
	        loglog(FullerCurves(i).calcIRM,FullerCurves(i).calcNRM,[linecolorsNRM{mod(countNRM,3)+1} linesyms{mod((countNRM-1)*2+1,4)+1} '-']);
	        legendstr={legendstr{:} [FullerCurves(i).NRM.samplename ' NRM'] };
	        hold on;
	end
	if FullerCurves(i).ARM(1).doesExist
		for j=1:length(FullerCurves(i).ARM);
			countARM=countARM+1;
		        loglog(FullerCurves(i).calcIRM,FullerCurves(i).calcARM(j,:),[linecolorsARM{mod(countARM,3)+1} linesyms{mod((countARM-1)*2,4)+1} '-']);
		        hold on;
		        legendstr={legendstr{:} [FullerCurves(i).ARM(j).samplename ' ARM'] };
		 end
	end
    end

end


if sum([FullerCurves.doesExist])>0
    legend(legendstr,'Location','Best');
    axis manual;
    stdvector=[1e-15 1];
    minIRM=min(min([FullerCurves.calcIRM]));
    maxIRM=max(max([FullerCurves.calcIRM]));
    
    minARM=min(min([FullerCurves.calcARM]));
    maxARM=max(max([FullerCurves.calcARM]));
    
    minNRM=min(min([FullerCurves.calcNRM]));
    maxNRM=max(max([FullerCurves.calcNRM]));
    miny=min(minNRM,minARM);
    maxy=max(maxNRM,maxARM);
    
    meany=10^(.5*log10(miny)+.5*log10(maxy));
    
    loglog(stdvector,stdvector*1e-4,'k:');
    if ((1.2e-4*maxIRM>miny) *(1.2e-4*maxIRM<maxy))
        text(maxIRM,maxIRM*1.2e-4,'1:10^{-4}');
    end
    loglog(stdvector,stdvector*1e-3,'k:');
    if ((1.2e-3*maxIRM>miny) *(1.2e-4*maxIRM<maxy))
        text(maxIRM,maxIRM*1.2e-3,'1:1000');
    end
    loglog(stdvector,stdvector*1e-2,'k:');
    if ((1.2e-2*maxIRM>miny) *(1.2e-4*maxIRM<maxy))
        text(maxIRM,maxIRM*1.2e-2,'1:100');
    end
    loglog(stdvector,stdvector*1e-1,'k:');
    if ((1.2e-1*maxIRM>miny) *(1.2e-1*maxIRM<maxy))
        text(maxIRM,maxIRM*1.2e-1,'1:10');
    end
    loglog(stdvector,stdvector,'k:');
    if ((1.2*maxIRM>miny) *(1.2*maxIRM<maxy))
        text(maxIRM,maxIRM*1.2,'1:1');
    end
    xlabel ('IRM (Am^2)');
    ylabel ('m {Am^2}');
    title(['Fuller' titleSuffix]);
else
    axis off;
end