function y=RmgExtractAFOfStep(RmgData,stepnum,varargin)

% y = RmgExtractAFOfStep(Rmg,stepnum)
%
% returns an AF structure for step number stepnum (if it exists).
%
% Last updated by Robert E. Kopp, March 1 2008
% Copyright (C) 2008 Robert E. Kopp, licensed under GNU GPL v.3

	y.experiment='AF';
	y.samplename=RmgData.samplename;
	y.mass=RmgData.mass;
	y.targetStep.stepnum=stepnum;
	y.targetStep.steptype=RmgData.steptypes{stepnum};
	y.targetStep.level=RmgData.levels(stepnum);
	y.targetStep.bias=RmgData.bias(stepnum);
	y.targetStep.spin=RmgData.spin(stepnum);
	y.targetStep.mvector=RmgData.mvector(:,stepnum);
	y.targetStep.treatmentDCField=RmgData.treatmentDCFields(stepnum);
	y.targetStep.treatmentAFField=RmgData.treatmentAFFields(stepnum);
	y.targetStep.treatmentTemp=RmgData.treatmentTemps(stepnum);

	if stepnum+1>length(RmgData.levels)
	    y.doesExist=0;
	    return;
	end
	
	currentBlock = RmgData.stepBlock(stepnum);
	
	if not(strcmpi('AF',RmgData.BlockType(currentBlock + 1)))
		y.doesExist=0; return;
	end
	
	if RmgData.stepBlock(stepnum+1) == currentBlock
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
	
	priorAFmax = []; subsequentAFmax = [];
	
	if strcmpi('AFMax',RmgData.BlockType(currentBlock - 1))
	    magBaselineStep=find(RmgData.stepBlock == currentBlock -1);
	    magBaselineStep = magBaselineStep(end);
	elseif strcmpi('AFMax',RmgData.BlockType(currentBlock + 2))
	    magBaselineStep=find(RmgData.stepBlock == currentBlock + 2);
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
	y.AFSteps = find(RmgData.stepBlock == currentBlock + 1);
	y.mvectorUnsub=RmgData.mvector(:,y.AFSteps);
	
	if subtractAFMax==1
		y.mvector=y.mvectorUnsub-repmat(y.baselineVector,1,length(y.AFSteps));
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
	y.treatmentAFFields=RmgData.treatmentAFFields(y.AFSteps);
	
	y.treatmentAFFields(1)=1e-7;
	
	dfields=diff(y.treatmentAFFields);
	dlogfields=diff(log10(y.treatmentAFFields));
	y.treatmentAFderivFields=y.treatmentAFFields(1:end-1)+.5*dfields;
	y.log10treatmentAFderivFields=log10(y.treatmentAFFields(1:end-1))+.5*dlogfields;
	
	y.mzlogderiv=-diff(y.mzNormalized)./diff(log10(y.treatmentAFFields));
	
	smoothSpan=double(int32(length(y.log10treatmentAFderivFields)*.03)*2+1);
	y.mzlogderivSmooth=moving(y.mzlogderiv,smoothSpan)';
	
	y.MDF=interp1(y.mzNormalized,y.treatmentAFFields,0.5,'linear','extrap');
	y.MDFdirectional=interp1(y.mdirectionalNormalized,y.treatmentAFFields,0.5,'linear','extrap');
	
	y.meanlogfield=trapz(y.log10treatmentAFderivFields,y.mzlogderivSmooth.*y.log10treatmentAFderivFields)/trapz(y.log10treatmentAFderivFields,y.mzlogderivSmooth);
	y.dispersion=sqrt(trapz(y.log10treatmentAFderivFields,((y.log10treatmentAFderivFields-y.meanlogfield).^2).*y.mzlogderivSmooth)/trapz(y.log10treatmentAFderivFields,y.mzlogderivSmooth));
	y.skewness=trapz(y.log10treatmentAFderivFields,((y.log10treatmentAFderivFields-y.meanlogfield).^3).*y.mzlogderivSmooth)/(y.dispersion^3);
	
end