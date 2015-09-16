function y=RmgARMCurve(RmgData,varargin)

% y = RmgARMCurve(Rmg)
%
% returns an ARM structure for all ARM acquisition sequences in Rmg.
%
% Last updated by Robert E. Kopp, March 1 2008
% Copyright (C) 2008 Robert E. Kopp, licensed under GNU GPL v.3

	y.experiment='ARM';

	mu0=4*pi*1e-7;
	
	candidateBlocks = find(strcmpi(RmgData.BlockType,'ARM'));
	candidateBlocks = intersect(candidateBlocks,find(strcmpi(RmgData.BlockType(2:end),'AF')));
	
	if length(candidateBlocks)==0
	    y.doesExist=0; return;
	end
	
	for i=1:length(candidateBlocks)
		y(i).doesExist=1;
		y(i).experiment='ARM';
		y(i).samplename=RmgData.samplename;

		y(i).mass=RmgData.mass;
		
		y(i).ARMsteps=find(RmgData.stepBlock==candidateBlocks(i));
		y(i).bias=RmgData.bias(y(i).ARMsteps);
		y(i).treatmentDCFields=RmgData.treatmentDCFields(y(i).ARMsteps);
		y(i).treatmentAFFields=RmgData.treatmentAFFields(y(i).ARMsteps);
		y(i).mvectorUnsub=RmgData.mvector(:,y(i).ARMsteps);
		y(i).mvector=y(i).mvectorUnsub-repmat(y(i).mvectorUnsub(:,1),1,length(y(i).ARMsteps));
	
		y(i).ARMsusceptibility=interp1(y(i).treatmentDCFields,abs(y(i).mvector(3,:)),1e-4,'linear','extrap')/(1e-4/mu0);
	
		if length(unique(y(i).treatmentAFFields))==1
			AFLevel=y(i).treatmentAFFields(1);
		else
			AFLevel=NaN;
		end
		
		if isfinite(AFLevel)
	    		    y(i).mvectorIRM = correspondingIRM(RmgData,AFLevel) - y(i).mvectorUnsub(:,1);
			    y(i).fracmags=abs(y(i).mvector(3,:)/y(i).mvectorIRM(3));
			    y(i).ARMsusceptibilityToIRM=y(i).ARMsusceptibility/abs(y(i).mvectorIRM(3));
			    y(i).ARMtoIRMat100uT=y(i).ARMsusceptibilityToIRM*(1e-4/mu0);
			    y(i).ARMtoIRMat500uT=interp1(y(i).treatmentDCFields,abs(y(i).mvector(3,:)),5e-4,'linear','extrap')/abs(y(i).mvectorIRM(3));
			    y(i).ARMtoIRMat500uTDeviationfromTanh=y(i).ARMtoIRMat500uT-tanh((5e-4/mu0)*y(i).ARMsusceptibilityToIRM);
			    dfields=diff(y(i).treatmentDCFields);
			    y(i).derivfields=y(i).treatmentDCFields(1:length(dfields))+.5*dfields;
			    y(i).fracmagsderiv=diff(y(i).fracmags)./dfields;
		end
		
	end
end

function y=correspondingIRM(Rmg,IRMLevel)	
	AllIRMSteps=find(strcmpi(Rmg.steptypes,'IRM'));
	if length(AllIRMSteps>0)
		candidateIRMSteps = intersect(AllIRMSteps,find(Rmg.treatmentDCFields==IRMLevel));
		if length(candidateIRMSteps)>0
			y = Rmg.mvector(:,candidateIRMSteps(end));
		else
			fieldDistance = Rmg.treatmentDCFields - IRMLevel;
			interpolableSteps = intersect(AllIRMSteps,AllIRMSteps+1);
			interpolableSteps = intersect(interpolableSteps,find(fieldDistance(1:end-1)./fieldDistance(2:end)<0));
			[junk,interpolableTargetIndex] = min(fieldDistance(interpolableSteps).^2 + fieldDistance(interpolableSteps+1).^2);;
			interpolableTarget = interpolableSteps(interpolableTargetIndex);
			y(1,1) = interp1(log10([Rmg.treatmentDCFields(interpolableTarget) Rmg.treatmentDCFields(interpolableTarget+1)]),[Rmg.mvector(1,interpolableTarget) Rmg.mvector(1,interpolableTarget+1)],log10(IRMLevel),'linear');
			y(2,1) = interp1(log10([Rmg.treatmentDCFields(interpolableTarget) Rmg.treatmentDCFields(interpolableTarget+1)]),[Rmg.mvector(2,interpolableTarget) Rmg.mvector(2,interpolableTarget+1)],log10(IRMLevel),'linear');
			y(3,1) = interp1(log10([Rmg.treatmentDCFields(interpolableTarget) Rmg.treatmentDCFields(interpolableTarget+1)]),[Rmg.mvector(3,interpolableTarget) Rmg.mvector(3,interpolableTarget+1)],log10(IRMLevel),'linear');
		end
	else
		y = [NaN;NaN;NaN];
	end
end
