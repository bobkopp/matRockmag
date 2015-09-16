function y=RmgARMPlot(RmgData,varargin)

% y = RmgARMPlot(Rmg)
%
% generates a ARM acquisition plot for Rmg, where Rmg can be either an Rmg structure or a ARM structure.
%
% Last updated by Robert E. Kopp, March 1 2008
% Copyright (C) 2008 Robert E. Kopp, licensed under GNU GPL v.3

	inputOk=0;
	fields=fieldnames(RmgData);
	if sum(strcmpi(fields,'experiment'))
		if strmatch('ARM',RmgData(1).experiment)
			inputOk=1;
			ARM=RmgData;
		end
	elseif sum(strcmpi(fields,'steptypes'))
		if strmatch('ARM',RmgData(1).steptypes)		
			inputOk=1;
			count=0;
			for i=1:length(RmgData)
				curve=RmgARMCurve(RmgData(i));
				for j=1:length(curve)
					if sum(abs(diff(curve(j).treatmentAFFields)))==0
						count=count+1;
						ARM(count)=curve(j);
					end
				end
			end
		end
	else
		return;
	end

	if length(ARM) == 0
		return;
	end	
	
	for i=1:length(ARM)
		AFLevel(i)=ARM(i).treatmentAFFields(1);
	end
	
	emuConvert=1e-3;
	GaussConvert=1e-4;
	
	chiton.ARM.treatmentDCFields=GaussConvert*[0:20];
	chiton.ARM.mz=emuConvert*[1.02E-06 0.00001745 0.00003845 0.00005815 0.00007521 0.00009431 0.0001107 0.0001297 0.0001466 0.0001596 0.0001751 0.0001916 0.0002064 0.0002214 0.0002379 0.000252 0.0002652 0.0002832 0.0002941 0.0003066 0.000319];
	chiton.IRM100=0.001936*emuConvert;
	
	MS1.ARM.treatmentDCFields=GaussConvert*[0:20];
	MS1.ARM.mz=emuConvert*[0.0004002,0.01099,0.02553,0.03462,0.04089,0.0456,0.04913,0.05138,0.05335,0.05458,0.05582,0.05672,0.05742,0.05808,0.05862,0.05909,0.05947,0.05977,0.06013,0.0604,0.06072];
	MS1.IRM100=0.06725*emuConvert;
	
	linecolors={'k','g','b','r','c','m','y'};
	linesyms={'.','x','o','+','*','s','d','v','^','>','<'};
	
	legendstr={};
	
	for i=1:length(ARM)
	    if ARM(i).doesExist
	        plot(ARM(i).treatmentDCFields*1000,ARM(i).fracmags,[linecolors{mod(i,7)+1} linesyms{mod(i,11)+1} '-']);
	        legendstr={legendstr{:} [ARM(i).samplename ' (' num2str(round(AFLevel(i)*1000)) ' mT)']};
	        hold on;
	       % labelField=max(ARM(i).treatmentDCFields)*.8;
	       % ARM(i).fracmagsinterp(labelField)+.05
	       % text(1000*labelField,ARM(i).fracmagsinterp(labelField)+.05,RmgData(i).samplename);
	    end
	end
	
	if sum([ARM.doesExist])>0
	    if length(ARM)>1
	        legend(legendstr,'Location','NorthWest');
	        titleSuffix='';
	    else
	        titleSuffix=[': ' RmgData(1).samplename];
	    end
	    plot(chiton.ARM.treatmentDCFields*1000,chiton.ARM.mz/chiton.IRM100,'r:');
	    plot(MS1.ARM.treatmentDCFields*1000,MS1.ARM.mz/MS1.IRM100,'b:');
	    xlabel ('B (mT)');
	    ylabel (['f_{IRM' num2str(AFLevel(i)*1000) '}']);
	    maxField=max([ARM.treatmentDCFields]);
	    xlim([0 1000*maxField]);
	    title(['ARM' titleSuffix]);
	else
	    axis off;
	end
	
end