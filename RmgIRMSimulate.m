function y=RmgIRMSimulate(Bvalues,Banvalues,linewidthvalues)

dtheta=0.001*pi;

%[Bapplied,Ban,theta]=ndgrid(Bvalues,Banvalues,0:dtheta:.499*pi);
%switchingField=abs(Ban./cos(theta));
%number=2*pi*sin(theta).*dtheta;
%weight=cos(theta);
%switched=number.*weight.*(Bapplied>switchingField);
%y=sum(switched,3)/pi;


    [nulla,nullb,Ban,theta] = ndgrid (1,1,Banvalues,[0:dtheta:.499*pi]);

    weightings1 = 2*pi*sin(theta)*dtheta .* cos(theta);
    switchingField1=abs(Ban./cos(theta));
    
    Bvalues=reshape(Bvalues,[length(Bvalues) 1]);
    linewidthvalues=reshape(linewidthvalues,[1 length(linewidthvalues)]);
    
    matsize=size(switchingField1)
    matsize=matsize(3:end);
    
    B = repmat(Bvalues,[1 length(linewidthvalues) matsize]);
    switchingField = repmat(switchingField1,[length(Bvalues) length(linewidthvalues) 1]);
    weightings = repmat(weightings1,[length(Bvalues) length(linewidthvalues) 1]);
    linewidth = repmat(linewidthvalues,[length(Bvalues) 1 matsize]);

    
    size(weightings)
    size(linewidth)
    size(switchingField)
    size(B)
    
    contribs = weightings .* sqrt(1/(2*pi)) ./linewidth .* exp (-((B - switchingField).^2)./(2*linewidth.^2));

    
    % ok, now collapse along the fourth dimension
    
    absorption=sum(contribs,4);
    y=absorption;  
