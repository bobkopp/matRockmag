function y=RmgSIRMCurve(RmgData, varargin)

% y = RmgSIRMCurve(Rmg)
%
% returns an SIRM structure for all IRM acquisition and demagnetization pairs in Rmg.
%
% Last updated by Robert E. Kopp, March 1 2008
% Copyright (C) 2008 Robert E. Kopp, licensed under GNU GPL v.3

	y.experiment = 'SIRM';
	
	candidateBlocks = intersect(find(strcmpi(RmgData.BlockType,'IRM')),find(RmgData.BlockSize>1));
	
	if length(candidateBlocks)==0
	    y.doesExist=0; return;
	end

	for i=1:length(candidateBlocks)
		blocksteps=find(RmgData.stepBlock == candidateBlocks(i));

		y(i).doesExist=1;
		y(i).experiment = 'SIRM';
		
		y(i).samplename=RmgData.samplename;
		y(i).mass=RmgData.mass;
		
		y(i).AF=RmgExtractAFOfStep(RmgData,blocksteps(end));
		if y(i).AF.doesExist
			y(i).baselineVector=y(i).AF.baselineVector;
		else
			y(i).baselineVector=[0 0 0]';
		end	
		y(i).IRM.IRMSteps=blocksteps;
		y(i).IRM.treatmentDCFields=RmgData.treatmentDCFields(y(i).IRM.IRMSteps);
		y(i).IRM.mvectorUnsub=RmgData.mvector(:,y(i).IRM.IRMSteps);
		y(i).IRM.mvector=y(i).IRM.mvectorUnsub-repmat(y(i).baselineVector,1,length(y(i).IRM.IRMSteps));
		y(i).IRM.IRMperkg=RmgData.mzperkg(y(i).IRM.IRMSteps);
		y(i).IRM.fracmags=abs(y(i).IRM.mvector(3,:)/y(i).IRM.mvector(3,length(y(i).IRM.IRMSteps)));

		y(i).sIRM=abs(y(i).IRM.mvector(3,end));
		y(i).sIRMperkg=y(i).sIRM/(RmgData.mass);		
	
		if (length(blocksteps)>1)
			y(i).IRM.dfields=diff(y(i).IRM.treatmentDCFields);
			y(i).IRM.derivFields=y(i).IRM.treatmentDCFields(1:end-1)+.5*y(i).IRM.dfields;
			y(i).IRM.dlogfields=diff(log10(y(i).IRM.treatmentDCFields));
			y(i).IRM.logDerivFields=log10(y(i).IRM.treatmentDCFields(1:end-1))+.5*y(i).IRM.dlogfields;
			y(i).IRM.derivFracmags=diff(y(i).IRM.fracmags)./diff((y(i).IRM.treatmentDCFields));
			y(i).IRM.logderiv=diff(y(i).IRM.fracmags)./diff(log10(y(i).IRM.treatmentDCFields));
	
			smoothSpan=double(int32(length(y(i).IRM.logDerivFields)*.03)*2+1);
			y(i).IRM.logderivSmooth=moving(y(i).IRM.logderiv,smoothSpan)';

			if y(i).AF.doesExist
				y(i).AF.fracmags=abs(y(i).AF.mvector(3,:)/y(i).IRM.mvector(3,length(y(i).IRM.IRMSteps)));
					
				y(i).diff.fields=[max([min(y(i).AF.treatmentAFFields) min(y(i).IRM.treatmentDCFields)]):1e-4:max([max(y(i).AF.treatmentAFFields)  max(y(i).IRM.treatmentDCFields)])];
			
				AFinterp=interpolate(log10(y(i).AF.treatmentAFFields),y(i).AF.fracmags,log10(y(i).diff.fields),'linear','extrap');
				IRMinterp=interpolate(log10(y(i).IRM.treatmentDCFields),y(i).IRM.fracmags,log10(y(i).diff.fields),'linear','extrap');
				y(i).diff.deltas=AFinterp-IRMinterp;
				[C,I]=min(abs(y(i).diff.deltas));
				y(i).diff.deltas=moving(1-AFinterp-IRMinterp,5);
				
				y(i).diff.integrateddelta=trapz(y(i).diff.fields*1000,y(i).diff.deltas);
				y(i).diff.crossover=y(i).diff.fields(I);
			
			
				y(i).AF.dfields=diff(y(i).AF.treatmentAFFields);
			
				y(i).AF.derivFields=y(i).AF.treatmentAFFields(1:length(y(i).AF.treatmentAFFields)-1)+.5*y(i).AF.dfields;
				
				y(i).AF.dlogfields=diff(log10(y(i).AF.treatmentAFFields));
				
				y(i).AF.logDerivFields=log10(y(i).AF.treatmentAFFields(1:length(y(i).AF.treatmentAFFields)-1))+.5*y(i).AF.dlogfields;
				
				y(i).AF.derivFracmags=-diff(y(i).AF.fracmags)./diff((y(i).AF.treatmentAFFields));
				
				
				y(i).AF.logderiv=-diff(y(i).AF.fracmags)./diff(log10(y(i).AF.treatmentAFFields));
				
				smoothSpan=double(int32(length(y(i).AF.logDerivFields)*.03)*2+1);
				y(i).AF.logderivSmooth=moving(y(i).AF.logderiv,smoothSpan)';
				
				y(i).Hcr=y(i).diff.crossover;
				y(i).R=interpolate(log10(y(i).IRM.treatmentDCFields),y(i).IRM.fracmags,log10(y(i).Hcr),'linear','extrap');
				y(i).MDF=y(i).AF.MDF;

			else
				y(i).diff.deltas=NaN;
				y(i).diff.integrateddelta=NaN;
				y(i).diff.crossover=NaN;
			
				y(i).Hcr=NaN;
				y(i).R=NaN;
				y(i).MDF=NaN;		
			end

			y(i).MAF=interpolate(y(i).IRM.fracmags,y(i).IRM.treatmentDCFields,0.5,'linear','extrap');
			
			y(i).IRM30toIRM100=interpolate(y(i).IRM.treatmentDCFields,y(i).IRM.mvector(3,:),0.03,'linear')/interpolate(y(i).IRM.treatmentDCFields,y(i).IRM.mvector(3,:),0.1,'linear');
			y(i).IRM100toIRM300=interpolate(y(i).IRM.treatmentDCFields,y(i).IRM.mvector(3,:),0.1,'linear')/interpolate(y(i).IRM.treatmentDCFields,y(i).IRM.mvector(3,:),0.3,'linear');
			
			y(i).IRM.meanlogfield=trapz(y(i).IRM.logDerivFields,y(i).IRM.logderivSmooth.*y(i).IRM.logDerivFields)/trapz(y(i).IRM.logDerivFields,y(i).IRM.logderivSmooth);
			y(i).IRM.dispersion=sqrt(trapz(y(i).IRM.logDerivFields,((y(i).IRM.logDerivFields-y(i).IRM.meanlogfield).^2).*y(i).IRM.logderivSmooth)/trapz(y(i).IRM.logDerivFields,y(i).IRM.logderivSmooth));
			y(i).IRM.skewness=trapz(y(i).IRM.logDerivFields,((y(i).IRM.logDerivFields-y(i).IRM.meanlogfield).^3).*y(i).IRM.logderivSmooth)/(y(i).IRM.dispersion^3);

		end

	end


end

function y=interpolate(setx,sety,x,varargin)
	[fixedx,ix] = unique(setx);
	[fixedy, iy] = unique(sety);
	indices = intersect(ix,iy);
	y=interp1(setx(indices),sety(indices),x,varargin{:});
end