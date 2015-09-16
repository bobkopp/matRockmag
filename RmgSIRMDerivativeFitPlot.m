function y=RmgSIRMDerivativeFitPlot(RmgData,Fits,varargin)

linecolorsIRM={'g','b','r'};
linecolorsAF={'y','c','m'};
linecolorsSingle={'g','b','r','y','c','m'};
linesyms={'.','x','o','+','*','s','d','v','^','>','<'};

doAF=1;
doAcq=1;
showPoints=1;

if nargin>=1
    for i=1:nargin-2
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

legendstr={};

if length(RmgData)==1
    titleSuffix=[': ' RmgData(1).samplename];
    RmgData(1).samplename='';
else
    titleSuffix='';
    
end

if numcurves==1
    if doAF
            titleSuffix=[' of IRM AF' titleSuffix];
    elseif doAcq
            titleSuffix=[' of IRM Acq' titleSuffix];
    end
end

for i=1:length(RmgData)
    IRM(i)=RmgSIRMCurve(RmgData(i));
end
 
xlabel ('log B (mT)');
ylabel 'df_{IRM}/dB';
title(['dIRM/dB' titleSuffix]);
hold on;

if showPoints
    for i=1:length(RmgData)
        if IRM(i).doesExist
            if numcurves>1
                plot(IRM(i).IRM.logDerivFields+3,IRM(i).IRM.logderiv,[linecolorsIRM{mod(i,3)+1} linesyms{mod(i,11)+1}]);
                hold on;
                plot(IRM(i).AF.logDerivFields+3,IRM(i).AF.logderiv,[linecolorsAF{mod(i,3)+1} linesyms{mod(i,11)+1}]);
            elseif doAcq
                plot(IRM(i).IRM.logDerivFields+3,IRM(i).IRM.logderiv,[linecolorsSingle{mod(i,6)+1} linesyms{mod(i,11)+1}]);
                hold on;
            elseif doAF
                plot(IRM(i).AF.logDerivFields+3,IRM(i).AF.logderiv,[linecolorsSingle{mod(i,6)+1} linesyms{mod(i,11)+1}]);
                hold on;
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
 
    for i=1:length(RmgData)
        if IRM(i).doesExist
            if numcurves>1
 %               plot(IRM(i).IRM.logDerivFields+3,IRM(i).IRM.logderivSmooth,[linecolorsIRM{mod(i,3)+1} '-']);
 %               plot(IRM(i).AF.logDerivFields+3,IRM(i).AF.logderivSmooth,[linecolorsAF{mod(i,3)+1} '-']);

                legendstr={legendstr{:} [RmgData(i).samplename ' Acq']};
                legendstr={legendstr{:} [RmgData(i).samplename ' AF']};
               
                
                minAFlogDerivFields=min([minAFlogDerivFields;IRM(i).AF.logDerivFields']);
                minIRMlogDerivFields=min([minIRMlogDerivFields;IRM(i).IRM.logDerivFields']);
                maxAFlogDerivFields=max([maxAFlogDerivFields;IRM(i).AF.logDerivFields']);
                maxIRMlogDerivFields=max([maxIRMlogDerivFields;IRM(i).IRM.logDerivFields']);
                maxIRMlogDeriv=max([maxIRMlogDeriv IRM(i).IRM.logderiv]);
                maxAFlogDeriv=max([maxAFlogDeriv IRM(i).AF.logderiv]);
            else
                if doAF
 %                   plot(IRM(i).AF.logDerivFields+3,IRM(i).AF.logderivSmooth,[linecolorsSingle{mod(i,6)+1} '-']);
                    if length(RmgData)>1
                        legendstr={legendstr{:} [RmgData(i).samplename ' AF']};
                    end
                   minAFlogDerivFields=min([minAFlogDerivFields;IRM(i).AF.logDerivFields']);
                    maxAFlogDerivFields=max([maxAFlogDerivFields;IRM(i).AF.logDerivFields']);
                    maxAFlogDeriv=max([maxAFlogDeriv IRM(i).AF.logderiv]);
               elseif doAcq
 %                   plot(IRM(i).IRM.logDerivFields+3,IRM(i).IRM.logderivSmooth,[linecolorsSingle{mod(i,6)+1} '-']);
                    if length(RmgData)>1
                        legendstr={legendstr{:} [RmgData(i).samplename ' Acq']};
                    end
                    minIRMlogDerivFields=min([minIRMlogDerivFields;IRM(i).IRM.logDerivFields']);
                    maxIRMlogDerivFields=max([maxIRMlogDerivFields;IRM(i).IRM.logDerivFields']);
                    maxIRMlogDeriv=max([maxIRMlogDeriv IRM(i).IRM.logderiv]);
                end
            end
          
        end
    end
    
    if length(legendstr) > 1
         legend(legendstr,'Location','Northwest');
    end

    xlim([min(minAFlogDerivFields,minIRMlogDerivFields)+3 max(maxAFlogDerivFields,maxIRMlogDerivFields)+3]);
    ylim([0 max(maxAFlogDeriv,maxIRMlogDeriv)]);
    
    axis manual;
    
       for i=1:length(RmgData)
        if IRM(i).doesExist
            if numcurves>1
                plot(IRM(i).IRM.logDerivFields+3,Fits(i).IRMfit.bestfit.fit(IRM(i).IRM.logDerivFields),[linecolorsIRM{mod(i,3)+1} '--']);
                plot(IRM(i).AF.logDerivFields+3,Fits(i).AFfit.bestfit.fit(IRM(i).AF.logDerivFields),[linecolorsAF{mod(i,3)+1} '--']);
            else
                if doAF
                    plot(IRM(i).AF.logDerivFields+3,Fits(i).IRMfit.bestfit.fit(IRM(i).AF.logDerivFields),[linecolorsSingle{mod(i,6)+1} '--']);
               elseif doAcq
                    plot(IRM(i).IRM.logDerivFields+3,Fits(i).AFfit.bestfit.fit(IRM(i).IRM.logDerivFields),[linecolorsSingle{mod(i,6)+1} '--']);

                end
            end
          
        end
    end
    
else
    axis off;
end
    
end


