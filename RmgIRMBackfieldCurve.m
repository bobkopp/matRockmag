function y=RmgIRMBackfieldCurve(RmgData,varargin)

% y = RmgIRMBackfieldCurve(Rmg)
%
% returns an IRM Backfield structure for all experiments in Rmg.
%
% Last updated by Robert E. Kopp, March 1 2008
% Copyright (C) 2008 Robert E. Kopp, licensed under GNU GPL v.3

	y.experiment='IRMBackfield';
	y.doesExist = 0;
	y.samplename=RmgData.samplename;

	IRMSequences = RmgSIRMCurve(RmgData);
	for i=1:length(IRMSequences)
		dsign=diff(sign(IRMSequences(i).IRM.treatmentDCFields));
		candidate{i}=find(abs(dsign)==2)+1;
		candidate{i}=candidate{end};
		if length(candidate{i}) > 0
			y.doesExist = 1;
		end
	end

	if not(y.doesExist)
		return;
	end
	
	count=0;
	for i=1:length(IRMSequences)
		if length(candidate{i})>0
			count=count+1;
			IRMSequences(i).IRM.IRMSteps(candidate{i});
			y(count).Demag = RmgExtractDCDemag(RmgData,IRMSequences(i).IRM.IRMSteps(candidate{i}));		
		end
	end

end

function y=RmgExtractDCDemag(RmgData,stepnum,varargin)
	y.samplename=RmgData.samplename;
	y.mass=RmgData.mass;
	y.targetStep.stepnum=stepnum;
	y.targetStep.steptype=RmgData.steptypes{stepnum};
	y.targetStep.level=RmgData.levels(stepnum);
	y.targetStep.bias=RmgData.bias(stepnum);
	y.targetStep.spin=RmgData.spin(stepnum);
	y.targetStep.mvector=RmgData.mvector(:,stepnum);
	y.targetStep.treatmentDCField=RmgData.treatmentDCFields(stepnum);
	y.targetStep.treatmentDCField=RmgData.treatmentDCFields(stepnum);
	y.targetStep.treatmentTemp=RmgData.treatmentTemps(stepnum);

	if stepnum+1>length(RmgData.levels)
	    y.doesExist=0;
	    return;
	end
	
	currentBlock = RmgData.stepBlock(stepnum);
	demagBlock = RmgData.stepBlock(stepnum+1);
	
	if not(strcmpi('IRM',RmgData.steptypes{stepnum+1}))
		y.doesExist=0; return;
	end
	
	subtractAFMax = 1;
	
	if nargin > 2
	    if strcmp(varargin(1),'noAFMaxSubtract')
			subtractAFMax = 0;
		elseif strcmp(varargin(1),'AFMaxSubtract')
			subtractAFMax = 1;
		end
	end
	
	priorDCmax = []; subsequentDCmax = [];
	
	if strcmpi('AFMax',RmgData.BlockType(currentBlock - 1))
	    magBaselineStep=find(RmgData.stepBlock == currentBlock -1);
	    magBaselineStep = magBaselineStep(end);
	elseif strcmpi('AFMax',RmgData.BlockType(demagBlock + 1))
	    magBaselineStep=find(RmgData.stepBlock == demagBlock + 1);
	    magBaselineStep = magBaselineStep(1);
    	else
	    magBaselineStep=0;
	end
	
	if magBaselineStep>0
	    y.baselineVector=RmgData.mvector(:,magBaselineStep);
	else
	    y.baselineVector=[0 0 0];
	end
	
	y.doesExist=1;
	y.DemagSteps = intersect(find(RmgData.stepBlock == demagBlock),stepnum:length(RmgData.stepBlock));
	y.mvectorUnsub=RmgData.mvector(:,y.DemagSteps);
	
	if subtractAFMax==1
		y.mvector=y.mvectorUnsub-repmat(y.baselineVector,1,length(y.DemagSteps));
	else
		y.mvector=y.mvectorUnsub;
	end
	
	y.mmag=sqrt(sum(y.mvector.^2));
	y.dmmag=sqrt(sum((diff(y.mvector,1,2)).^2));
	c=cumsum(y.dmmag(end:-1:1));
	y.mdirectional=[c(end:-1:1) 0]+y.mmag(end);
	y.mz=y.mvector(3,:);
	y.mzNormalized=y.mvector(3,:)/y.mvector(3,1);
	y.mmagNormalized=y.mmag/y.mmag(1);
	y.mdirectionalNormalized=y.mdirectional/y.mdirectional(1);
	y.treatmentDCFields=RmgData.treatmentDCFields(y.DemagSteps);
		
	dfields=diff(y.treatmentDCFields);
	shiftedfields=abs(y.treatmentDCFields-y.treatmentDCFields(1)+1e-7);
	y.treatmentDCFieldsShifted=shiftedfields;
	y.treatmentDCderivFields=y.treatmentDCFields(1:end-1)+.5*dfields;

	dlogfields=diff(log10(shiftedfields));
	y.log10treatmentDCderivFields=log10(shiftedfields(1:end-1))+.5*dlogfields;
	
	y.mzlogderiv=-diff(y.mzNormalized)./diff(log10(y.treatmentDCFieldsShifted));
	
	smoothSpan=double(int32(length(y.log10treatmentDCderivFields)*.03)*2+1);
	y.mzlogderivSmooth=moving(y.mzlogderiv,smoothSpan)';
	
	y.MDF=interp1(y.mzNormalized,y.treatmentDCFields,0.5,'linear','extrap');
	y.MDFdirectional=interp1(y.mdirectionalNormalized,y.treatmentDCFields,0.5,'linear','extrap');
	
	y.meanlogfield=trapz(y.log10treatmentDCderivFields,y.mzlogderivSmooth.*y.log10treatmentDCderivFields)/trapz(y.log10treatmentDCderivFields,y.mzlogderivSmooth);
	y.dispersion=sqrt(trapz(y.log10treatmentDCderivFields,((y.log10treatmentDCderivFields-y.meanlogfield).^2).*y.mzlogderivSmooth)/trapz(y.log10treatmentDCderivFields,y.mzlogderivSmooth));
	y.skewness=trapz(y.log10treatmentDCderivFields,((y.log10treatmentDCderivFields-y.meanlogfield).^3).*y.mzlogderivSmooth)/(y.dispersion^3);

end