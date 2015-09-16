function y=RmgBatchPlotter(RmgData,Routines,varargin)

    doMultisample=0;
    doSubplots=0;
    AFLevel=0;
    AutosaveFmts={};
    fileprefix='';
    
    y=[];

    if nargin>2
        for i=1:length(varargin)
            if strcmp(varargin{i},'Multisample')
                doMultisample=1;
            elseif strcmp(varargin{i},'Subplots')
                doSubplots=1;
            elseif strcmp(varargin{i},'AutosaveEPS')
                AutosaveFmts={AutosaveFmts{:} 'eps'};
            elseif strcmp(varargin{i},'AutosaveFIG')
                AutosaveFmts={AutosaveFmts{:} 'fig'};
            elseif strcmp(varargin{i},'AFLevel')
                AFLevel=varargin{i+1};
                i=i+1;
            elseif strcmp(varargin{i},'FilePrefix')
                fileprefix=varargin{i+1};
                i=i+1;
            end
        end
    end

    if doMultisample
        if doSubplots
            h=figure;
            y(length(y)+1)=h;
            MakeMultiplot(RmgData,Routines,AFLevel);
            AutosaveHandler(h,[fileprefix 'plots'],AutosaveFmts);
        else
            for j=1:length(Routines)
                h=figure;
                y(length(y)+1)=h;
                MakePlot(RmgData,Routines{j},AFLevel);
                AutosaveHandler(h,[fileprefix Routines{j}],AutosaveFmts);
            end
        end
    else
        for i=1:length(RmgData)
            if length(AFLevel)>1
                wAFLevel=AFLevel(i);
            else
                wAFLevel=AFLevel;
            end
            if doSubplots
                h=figure;
                y(length(y)+1)=h;
                MakeMultiplot(RmgData(i),Routines,wAFLevel);                
                AutosaveHandler(h,[fileprefix RmgData(i).samplename '-plots'],AutosaveFmts);
            else
                for j=1:length(Routines)
                    h=figure;
                    y(length(y)+1)=h;
                    MakePlot(RmgData(i),Routines(j),AFLevel);
                    AutosaveHandler(h,[fileprefix RmgData(i).samplename '-' Routines{j}],AutosaveFmts);
                end
            end
        end
    end
    
end

function y=MakePlot(RmgData,plottype,varargin)

    if nargin > 2
        AFLevel=varargin{1};
    else
        AFLevel=0;
    end
    
    if strcmp(plottype,'IRM')
        RmgSIRMPlot(RmgData);
    elseif strcmp(plottype,'dIRM')
        RmgSIRMDerivativePlot(RmgData);
    elseif strcmp(plottype,'ARM')
        RmgARMPlot(RmgData,AFLevel);
    elseif strcmp(plottype,'LowrieFuller')
        RmgLowrieFullerPlot(RmgData,AFLevel);
    elseif strcmp(plottype,'AF')
        RmgLowrieFullerPlot(RmgData,AFLevel,'MultiAF');
    elseif strcmp(plottype,'Fuller')
        RmgFullerPlot(RmgData,AFLevel);
    elseif strcmp(plottype,'RRM')
        RmgRRMPlot(RmgData,AFLevel);
    elseif strcmp(plottype,'Backfield')
        RmgBackfieldPlot(RmgData);
    elseif strcmp(plottype,'StatBox')
        RmgStatBox(RmgData,AFLevel);
    end
end

function y=MakeMultiplot (RmgData,plottype,varargin)

    if nargin > 2
        AFLevel=varargin{1};
    else
        AFLevel = 0;
    end
    
    rows=ceil(sqrt(length(plottype)));
    cols=ceil(length(plottype)/rows);
    
    for i=1:length(plottype)
        subplot(rows,cols,i);
        MakePlot(RmgData,plottype{i},AFLevel);
    end
end

function y=AutosaveHandler(handle,filename,formats)
    if length(formats) > 0
        for i=1:length(formats)
            if strcmp(formats(i),'eps')
                saveas(handle,[filename '.eps'],'epsc2');
            elseif strcmp(formats(i),'fig')
                saveas(handle,[filename '.fig'],'fig');
            end
        end
    end
end