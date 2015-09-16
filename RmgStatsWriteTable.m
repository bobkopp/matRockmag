function y=RmgStatsTableWrite(RmgData,filename,varargin)

% y = RmgStats(Rmg,filename)
%
% outputs a stats table for a Rmg structure or array.
%
% Last updated by Robert E. Kopp, March 1 2008
% Copyright (C) 2008 Robert E. Kopp, licensed under GNU GPL v.3


stats=RmgStats(RmgData,varargin{:});

headers=['Sample ' '\tSusceptibility (' stats(1).units.susceptibility ')\tsIRM (' stats(1).units.sIRM ...
    ')\tsIRM/kg (' stats(1).units.sIRMperkg ')\tHcr (' stats(1).units.Hcr ')\tR ' '\tIRM30/IRM100' '\tIRM100/IRM300' '\t Integrated frac. IRMAcq-IRMAF (' stats(1).units.Hcr ')\tdfIRM/dB (field) ' '\tdfIRM/dB ' ...
    '\tMAF of IRM (' stats(1).units.MDF ')' '\tDP of IRM Acq' '\tSkewness of IRM Acq' ...
    '\tMDF of IRM (' stats(1).units.MDF ')' '\tDP of IRM AF' '\tSkewness of IRM AF' ...
    '\tARM susceptibility (' stats(1).units.ARMsusceptibility ')' '\tARM susceptibility/IRM (' stats(1).units.ARMsusceptibilityToIRM ')' ...
    '\tARM/IRM @ 100uT' '\tARM/IRM @ 500uT' '\tARM/IRM @ 500uT - Deviation from Tanh' ...
    '\tMDF of ARM (' stats(1).units.MDF ')' '\tDP of ARM' '\tSkewness of ARM' ...
    '\tMDF of IRM at ARM (' stats(1).units.MDF ')' '\tDP of IRM at ARM' '\tSkewness of IRM at ARM' '\tNRM (' stats(1).units.sIRM ')\tNRM-directional (' stats(1).units.sIRM ...
    ')\tMDF of NRM (' stats(1).units.MDF ')'];


fid=fopen([filename '.asc'],'w');
fprintf(fid,[headers '\n']);

for i=1:length(RmgData)
    dataString='';

    dataString=[stats(i).sample '\t'];
    
    if isfinite(stats(i).susceptibility)
        dataString=[dataString num2str(stats(i).susceptibility)];
    end
    dataString=[dataString '\t'];

    if isfinite(stats(i).sIRM)
        dataString=[dataString num2str((stats(i).sIRM))];
    end
    dataString=[dataString '\t'];

    if isfinite(stats(i).sIRMperkg)
        dataString=[dataString num2str((stats(i).sIRMperkg))];;
    end
    dataString=[dataString '\t'];

    if isfinite(stats(i).Hcr)
        dataString=[dataString num2str((stats(i).Hcr))];;
    end
    dataString=[dataString '\t'];
    
    if isfinite(stats(i).CisowskiR)
        dataString=[dataString num2str((stats(i).CisowskiR))];;
    end
    dataString=[dataString '\t'];

    if isfinite(stats(i).IRM30toIRM100)
        dataString=[dataString num2str((stats(i).IRM30toIRM100))];;
    end
    dataString=[dataString '\t'];
    
	if isfinite(stats(i).IRM100toIRM300)
        dataString=[dataString num2str((stats(i).IRM100toIRM300))];;
    end
    dataString=[dataString '\t'];
    
    if isfinite(stats(i).IntegratedIRMMinusAF)
        dataString=[dataString num2str((stats(i).IntegratedIRMMinusAF))];;
    end
    dataString=[dataString '\t'];
    
    if isfinite(stats(i).dfIRMdBatField)
        dataString=[dataString num2str(stats(i).dfIRMdBatField)];
    end
    dataString=[dataString '\t'];

    if isfinite(stats(i).dfIRMdB)
        dataString=[dataString num2str(stats(i).dfIRMdB)];
    end
    dataString=[dataString '\t'];

    if isfinite(stats(i).MAFofIRM)
        dataString=[dataString num2str(stats(i).MAFofIRM)];
    end
    dataString=[dataString '\t'];

    if isfinite(stats(i).DPofIRMAcq)
        dataString=[dataString num2str(stats(i).DPofIRMAcq)];
    end
    dataString=[dataString '\t'];
    
     if isfinite(stats(i).SkewnessofIRMAcq)
        dataString=[dataString num2str(stats(i).SkewnessofIRMAcq)];
    end
    dataString=[dataString '\t'];

    
    if isfinite(stats(i).MDFofIRM)
        dataString=[dataString num2str(stats(i).MDFofIRM)];
    end
    dataString=[dataString '\t'];
    
    
    if isfinite(stats(i).DPofIRMAF)
        dataString=[dataString num2str(stats(i).DPofIRMAF)];
    end
    dataString=[dataString '\t'];
    
     if isfinite(stats(i).SkewnessofIRMAF)
        dataString=[dataString num2str(stats(i).SkewnessofIRMAF)];
    end
    dataString=[dataString '\t'];

    
    if isfinite(stats(i).ARMsusceptibility)
        dataString=[dataString num2str((stats(i).ARMsusceptibility)) ];
    end
    dataString=[dataString '\t'];

    
    
    
    if isfinite(stats(i).ARMsusceptibilityToIRM)
        dataString=[dataString num2str((stats(i).ARMsusceptibilityToIRM)) ];
    end
    dataString=[dataString '\t'];
    
    
    if isfinite(stats(i).ARMtoIRMat100uT)
        dataString=[dataString  num2str((stats(i).ARMtoIRMat100uT))];
    end
    dataString=[dataString '\t'];

    if isfinite(stats(i).ARMtoIRMat500uT)
        dataString=[dataString  num2str((stats(i).ARMtoIRMat500uT))];
    end
    dataString=[dataString '\t'];
    
    if isfinite(stats(i).ARMtoIRMat500uTDeviationfromTanh)
        dataString=[dataString  num2str((stats(i).ARMtoIRMat500uTDeviationfromTanh))];
    end
    dataString=[dataString '\t'];
    

    
    if isfinite(stats(i).MDFofARM)
        dataString=[dataString num2str(stats(i).MDFofARM)];
    end
    dataString=[dataString '\t'];
    
    if isfinite(stats(i).DPofARM)
        dataString=[dataString num2str(stats(i).DPofARM)];
    end
    dataString=[dataString '\t'];
    
     if isfinite(stats(i).SkewnessofARM)
        dataString=[dataString num2str(stats(i).SkewnessofARM)];
    end
    dataString=[dataString '\t'];

    
    if isfinite(stats(i).MDFofIRMatARM)
        dataString=[dataString num2str(stats(i).MDFofIRMatARM)];
    end
    dataString=[dataString '\t'];
    
    
    if isfinite(stats(i).DPofIRMatARM)
        dataString=[dataString num2str(stats(i).DPofIRMatARM)];
    end
    dataString=[dataString '\t'];
    
     if isfinite(stats(i).SkewnessofIRMatARM)
        dataString=[dataString num2str(stats(i).SkewnessofIRMatARM)];
    end
    dataString=[dataString '\t'];

    if isfinite(stats(i).NRM)
        dataString=[dataString num2str(stats(i).NRM)];
    end
    dataString=[dataString '\t'];
    
    if isfinite(stats(i).NRMdirectional)
        dataString=[dataString num2str(stats(i).NRMdirectional)];
    end
    dataString=[dataString '\t'];
    
    if isfinite(stats(i).MDFofNRM)
        dataString=[dataString num2str(stats(i).MDFofNRM)];
    end
    dataString=[dataString '\t'];
    
    dataString=[dataString '\n'];
    fprintf(fid,dataString);
end

fclose(fid);

end