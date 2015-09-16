function y=RmgStatBox(RmgData,varargin)

% y = RmgStatBox(Rmg)
%
% produces a stat box for a Rmg structure.
%
% Last updated by Robert E. Kopp, March 1 2008
% Copyright (C) 2008 Robert E. Kopp, licensed under GNU GPL v.3

mu0=4*pi*10^-7;

DSPos=1;

stats=RmgStats(RmgData,varargin{:});

for i=1:length(RmgData)

    dataString(DSPos)={['Sample: ' stats(i).sample]};
    DSPos=DSPos+2;

    
    if isfinite(stats(i).susceptibility)
        dataString(DSPos)={['\chi = ' num2str((stats(i).susceptibility)) ' ' stats(i).units.susceptibility]};;
        DSPos=DSPos+1;
    end

    if isfinite(stats(i).sIRM)
        dataString(DSPos)={['sIRM = ' num2str((stats(i).sIRM)) ' ' stats(i).units.sIRM]};;
        DSPos=DSPos+1;
    end

    if isfinite(stats(i).sIRMperkg)
        dataString(DSPos)={['sIRM/kg = ' num2str((stats(i).sIRMperkg)) ' ' stats(i).units.sIRMperkg]};;
        DSPos=DSPos+1;
    end

    if isfinite(stats(i).Hcr)
        dataString(DSPos)={['H_{cr} = ' num2str((stats(i).Hcr)) ' ' stats(i).units.Hcr]};;
        DSPos=DSPos+1;
    end
    
    if isfinite(stats(i).CisowskiR)
        dataString(DSPos)={['R = ' num2str((stats(i).CisowskiR))]};;
        DSPos=DSPos+1;
    end

    
    if isfinite(stats(i).dfIRMdB)
        dataString(DSPos)={['(df_{IRM}/dB)_' num2str((stats(i).dfIRMdBatField)) ' = ' num2str(stats(i).dfIRMdB)]};
        DSPos=DSPos+1;
    end

    if isfinite(stats(i).MDFofIRM)
        dataString(DSPos)={['MDF_{IRM} = ' num2str((stats(i).MDFofIRM)) ' ' stats(i).units.MDF]};
        DSPos=DSPos+1;
    end

    
    if isfinite(stats(i).ARMsusceptibility)
        dataString(DSPos)={['k_{ARM}/IRM = ' num2str((stats(i).ARMsusceptibilityToIRM)) ' ' stats(i).units.ARMsusceptibilityToIRM]};
        DSPos=DSPos+1;
    end

    if isfinite(stats(i).ARMtoIRMat100uT)
        dataString(DSPos)={['(ARM/IRM)_{0.1mT} = ' num2str((stats(i).ARMtoIRMat100uT))]};
        DSPos=DSPos+1;
    end

    if isfinite(stats(i).MDFofARM)
        dataString(DSPos)={['MDF_{ARM} = ' num2str((stats(i).MDFofARM)) ' ' stats(i).units.MDF]};
        DSPos=DSPos+1;
    end

    DSPos=DSPos+1;
end
    
text(.05,.95,dataString,'VerticalAlignment','top');
axis off;