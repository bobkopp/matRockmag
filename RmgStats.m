function y=RmgStats(RmgData,varargin)

% y = RmgStats(Rmg)
%
% returns a statistics structure for a Rmg structure.
%
% Last updated by Robert E. Kopp, March 1 2008
% Copyright (C) 2008 Robert E. Kopp, licensed under GNU GPL v.3

mu0=4*pi*10^-7;

for i=1:length(RmgData)

    FullerCurves=RmgFullerCurves(RmgData(i));
    LFCurves=RmgLowrieFullerCurves(RmgData(i));
    SIRMCurve=RmgSIRMCurve(RmgData(i));
    RRMCurve=RmgRRMCurve(RmgData(i));
    ARMCurve=RmgARMCurve(RmgData(i));
    BackfieldCurve=RmgIRMBackfieldCurve(RmgData(i));

    suscepPoints=find(RmgData(i).suscep>0);;
  
    y(i).sample=RmgData(i).samplename;
    if length(suscepPoints)>0
        y(i).susceptibility = RmgData(i).suscep(suscepPoints(length(suscepPoints)));
    else
        y(i).susceptibility=NaN;
    end

    if LFCurves(1).doesExist
    	LFCurves=LFCurves(end);
        y(i).MDFofARM=LFCurves.ARMAF.MDF*1e3;
        y(i).MDFofIRMatARM=LFCurves.IRMAF.MDF*1e3;  
        y(i).DPofARM = LFCurves.ARMAF.dispersion;
        y(i).DPofIRMatARM = LFCurves.IRMAF.dispersion;
        y(i).SkewnessofARM = LFCurves.ARMAF.skewness;
        y(i).SkewnessofIRMatARM = LFCurves.IRMAF.skewness;
 
    else
        y(i).MDFofARM=NaN;
        y(i).MDFofIRMatARM=NaN;  
        y(i).DPofARM = NaN;
        y(i).DPofIRMatARM = NaN;
        y(i).SkewnessofARM = NaN;
        y(i).SkewnessofIRMatARM = NaN;
    end

    if SIRMCurve(1).doesExist
	best=length(SIRMCurve);
	for j=1:length(SIRMCurve)
		if SIRMCurve(j).AF.doesExist
			best=j;
		end
	end
	SIRMCurve=SIRMCurve(best);

        y(i).sIRM=SIRMCurve.sIRM;
        y(i).sIRMperkg=SIRMCurve.sIRMperkg;
        y(i).dfIRMdBatField=1000*SIRMCurve.IRM.treatmentDCFields(length(SIRMCurve.IRM.logderiv));
        y(i).dfIRMdB=SIRMCurve.IRM.logderiv(length(SIRMCurve.IRM.logderiv));
        y(i).IRM30toIRM100=SIRMCurve.IRM30toIRM100;
        y(i).IRM100toIRM300=SIRMCurve.IRM100toIRM300;
        y(i).MAFofIRM = SIRMCurve.MAF*1e3;
        y(i).DPofIRMAcq = SIRMCurve.IRM.dispersion;
        if SIRMCurve.AF.doesExist
	        y(i).Hcr=SIRMCurve.Hcr*1000;
	        y(i).CisowskiR = SIRMCurve.R;
	        y(i).SkewnessofIRMAcq = SIRMCurve.IRM.skewness;
	        y(i).IntegratedIRMMinusAF = SIRMCurve.diff.integrateddelta;
	        y(i).MDFofIRM = SIRMCurve.MDF*1e3;
	        y(i).SkewnessofIRMAF = SIRMCurve.AF.skewness;
	        y(i).DPofIRMAF = SIRMCurve.AF.dispersion;
	else
	        y(i).Hcr=NaN;
	        y(i).CisowskiR = NaN;
	        y(i).SkewnessofIRMAcq = NaN;
	        y(i).IntegratedIRMMinusAF = NaN;
	        y(i).MDFofIRM = NaN;
	        y(i).SkewnessofIRMAF = NaN;
	        y(i).DPofIRMAF = NaN;
	end

    else
        y(i).sIRM=NaN;
        y(i).sIRMperkg=NaN;
        y(i).Hcr=NaN;
        y(i).CisowskiR(i) = NaN;
        y(i).IRM30toIRM100=NaN;
        y(i).IRM100toIRM300=NaN;
        y(i).IntegratedIRMMinusAF = NaN;
        y(i).MAFofIRM = NaN;
        y(i).MDFofIRM = NaN;
        y(i).DPofIRMAcq = NaN;
        y(i).DPofIRMAF = NaN;
        y(i).SkewnessofIRMAcq = NaN;
        y(i).SkewnessofIRMAF = NaN;
        y(i).dfIRMdBatField=NaN;
        y(i).dfIRMdB=NaN;
    end

    if ARMCurve(1).doesExist
    	ARMCurve=ARMCurve(end);
        y(i).ARMsusceptibility=ARMCurve.ARMsusceptibility;
        y(i).ARMsusceptibilityToIRM=ARMCurve.ARMsusceptibilityToIRM;
        y(i).ARMtoIRMat100uT=ARMCurve.ARMtoIRMat100uT;
        y(i).ARMtoIRMat500uT=ARMCurve.ARMtoIRMat500uT;
        y(i).ARMtoIRMat500uTDeviationfromTanh=ARMCurve.ARMtoIRMat500uTDeviationfromTanh;
    else
        y(i).ARMsusceptibility=NaN;
        y(i).ARMsusceptibilityToIRM=ARMCurve.ARMsusceptibilityToIRM;
        y(i).ARMtoIRMat100uT=NaN;
        
        y(i).ARMtoIRMat500uT=NaN;
        y(i).ARMtoIRMat500uTDeviationfromTanh=NaN;
        
    end
    
    if FullerCurves(1).doesExist
        y(i).NRM=FullerCurves.NRM.mmag(1);
        y(i).NRMdirectional=FullerCurves.NRM.mdirectional(1);
        y(i).MDFofNRM=FullerCurves.NRM.MDFdirectional*1e3;
    else
        y(i).NRM=NaN;
        y(i).NRMdirectional=NaN;
        y(i).MDFofNRM=NaN;
    end

    
    y(i).units.susceptibility='raw';
    y(i).units.sIRM = 'Am^2';
    y(i).units.sIRMperkg='Am^2/kg';
    y(i).units.Hcr='mT';
    y(i).units.ARMsusceptibility = 'm^3';
    y(i).units.ARMsusceptibilityToIRM = 'm/A';
    y(i).units.MDF='mT';
end