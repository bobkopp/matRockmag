function y=RmgSIRMDerivativePlot(RmgData,varargin)

% y = RmgSIRMDerivativePlot(Rmg)
%
% generates a IRM Derivative plot for Rmg, where Rmg can be either an Rmg structure or a IRM structure.
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

linecolorsIRM={'g','b','r'};
linecolorsAF={'y','c','m'};
linecolorsSingle={'g','b','r','y','c','m'};
linesyms={'.','x','o','+','*','s','d','v','^','>','<'};

doAF=1;
doAcq=1;
showPoints=1;
yaxislabel='df_{IRM}/dB';
if length(RmgData)==1
    titleSuffix=[': ' RmgData(1).samplename];
    RmgData(1).samplename='';
else
    titleSuffix='';
    
end

if nargin>=1
    for i=1:nargin-1
        if strcmp(varargin{i},'AFOnly')
            doAF=1;
            doAcq=0;
        elseif strcmp(varargin{i},'AcqOnly')
            doAF=0;
            doAcq=1;
        end
        if strcmp(varargin{i},'SmoothOnly')
            showPoints = 0;
        end
    end
end


numcurves=doAF+doAcq;


if numcurves==1
    if doAF
            titleSuffix=[' of IRM AF' titleSuffix];
    elseif doAcq
            titleSuffix=[' of IRM Acq' titleSuffix];
    end
end

multipleFactor=repmat(1,length(RmgData),1);

if nargin>=1
    for i=1:nargin-1
        if strcmp(varargin{i},'MomentByMass')
            yaxislabel='dIRM/dB by kg';
            for i=1:length(IRM)
                multipleFactor(i)=IRM(i).sIRMperkg;
            end
        end
        if strcmp(varargin{i},'Moment')
            yaxislabel='dIRM/dB';
            for i=1:length(IRM)
                multipleFactor(i)=IRM(i).sIRM;
            end
        end
    end
end

legendstr={};


 
xlabel ('log B (mT)');
ylabel (yaxislabel);
title(['dIRM/dB' titleSuffix]);
hold on;

if showPoints
    for i=1:length(RmgData)
        if IRM(i).doesExist
            if numcurves>1
                plot(IRM(i).IRM.logDerivFields+3,multipleFactor(i)*IRM(i).IRM.logderiv,[linecolorsIRM{mod(i,3)+1} linesyms{mod(i,11)+1}]);
                hold on;
                if IRM(i).AF.doesExist
	                plot(IRM(i).AF.logDerivFields+3,multipleFactor(i)*IRM(i).AF.logderiv,[linecolorsAF{mod(i,3)+1} linesyms{mod(i,11)+1}]);
	      end
            elseif doAcq
                plot(IRM(i).IRM.logDerivFields+3,multipleFactor(i)*IRM(i).IRM.logderiv,[linecolorsSingle{mod(i,6)+1} linesyms{mod(i,11)+1}]);
                hold on;
            elseif doAF
                if IRM(i).AF.doesExist
               	 plot(IRM(i).AF.logDerivFields+3,multipleFactor(i)*IRM(i).AF.logderiv,[linecolorsSingle{mod(i,6)+1} 	linesyms{mod(i,11)+1}]);
                hold on;
               end
            end
        end
    end
end

minAFlogDerivFields=0;
minIRMlogDerivFields=0;
maxAFlogDerivFields=-3;
maxIRMlogDerivFields=-3;
maxIRMlogDeriv=0;
maxAFlogDeriv=0;


if sum([IRM.doesExist])>0
 
    for i=1:length(IRM)
        if IRM(i).doesExist
            if numcurves>1
                plot(IRM(i).IRM.logDerivFields+3,multipleFactor(i)*IRM(i).IRM.logderivSmooth,[linecolorsIRM{mod(i,3)+1} '-']);
                legendstr={legendstr{:} [RmgData(i).samplename ' Acq']};
                if IRM(i).AF.doesExist
	                plot(IRM(i).AF.logDerivFields+3,multipleFactor(i)*IRM(i).AF.logderivSmooth,[linecolorsAF{mod(i,3)+1} '-']);
	                legendstr={legendstr{:} [RmgData(i).samplename ' AF']};
	       end

               
                
                minIRMlogDerivFields=min([minIRMlogDerivFields;IRM(i).IRM.logDerivFields']);
                maxIRMlogDerivFields=max([maxIRMlogDerivFields;IRM(i).IRM.logDerivFields']);
                maxIRMlogDeriv=max([maxIRMlogDeriv multipleFactor(i)*IRM(i).IRM.logderiv]);
                if IRM(i).AF.doesExist
	                minAFlogDerivFields=min([minAFlogDerivFields;IRM(i).AF.logDerivFields']);
          	      maxAFlogDerivFields=max([maxAFlogDerivFields;IRM(i).AF.logDerivFields']);
            	maxAFlogDeriv=max([maxAFlogDeriv multipleFactor(i)*IRM(i).AF.logderiv]);
                end
            else
                if doAF & IRM(i).AF.doesExist
                    plot(IRM(i).AF.logDerivFields+3,multipleFactor(i)*IRM(i).AF.logderivSmooth,[linecolorsSingle{mod(i,6)+1} '-']);
                    if length(RmgData)>1
                        legendstr={legendstr{:} [RmgData(i).samplename ' AF']};
                    end
                    minAFlogDerivFields=min([minAFlogDerivFields;IRM(i).AF.logDerivFields']);
                    maxAFlogDerivFields=max([maxAFlogDerivFields;IRM(i).AF.logDerivFields']);
                    maxAFlogDeriv=max([maxAFlogDeriv multipleFactor(i)*IRM(i).AF.logderiv]);
               elseif doAcq
                    plot(IRM(i).IRM.logDerivFields+3,multipleFactor(i)*IRM(i).IRM.logderivSmooth,[linecolorsSingle{mod(i,6)+1} '-']);
                    if length(RmgData)>1
                        legendstr={legendstr{:} [RmgData(i).samplename ' Acq']};
                    end
                    minIRMlogDerivFields=min([minIRMlogDerivFields;IRM(i).IRM.logDerivFields']);
                    maxIRMlogDerivFields=max([maxIRMlogDerivFields;IRM(i).IRM.logDerivFields']);
                    maxIRMlogDeriv=max([maxIRMlogDeriv multipleFactor(i)*IRM(i).IRM.logderiv]);
                end
            end
          
        end
    end
    
    if length(legendstr) > 1
         legend(legendstr,'Location','Northwest');
    end

    xlim([min(minAFlogDerivFields,minIRMlogDerivFields)+3 max(maxAFlogDerivFields,maxIRMlogDerivFields)+3]);
    ylim([0 max(maxAFlogDeriv,maxIRMlogDeriv)]);
else
    axis off;
end
    
end


