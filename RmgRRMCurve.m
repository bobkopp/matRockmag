function y=RmgRRMCurve(RmgData,varargin)

% y = RmgRRMCurve(Rmg)
%
% returns a RRM structure for all RRM acquisition in RmgData.
%
% Last updated by Robert E. Kopp, March 1 2008
% Copyright (C) 2008 Robert E. Kopp, licensed under GNU GPL v.3

	y.experiment='RRM';


	mu0=4*pi*1e-7;

	candidateBlocks = find(strcmpi(RmgData.BlockType,'RRM'));
	
	if length(candidateBlocks)==0
	    y.doesExist=0; return;
	end
	
	y.doesExist=1;

	ARM=RmgARMCurve(RmgData);
	for i=1:length(ARM)
		fields=unique(ARM.treatmentAFFields);
		if length(fields)==1
			ARMField(i)=fields(1);
		else
			ARMField(i)=NaN;
		end
	end


	for i=1:length(candidateBlocks)
		y(i).experiment='RRM';
		y(i).doesExist = 1;
		y(i).samplename=RmgData.samplename;
		y(i).mass=RmgData.mass;
		y(i).RRMsteps=find(RmgData.stepBlock==candidateBlocks(i));
		y(i).spins = RmgData.spin(y(i).RRMsteps);
		RRM0step=find(y(i).spins==0);
		y(i).baselineVector=RmgData.mvector(:,y(i).RRMsteps(RRM0step(1)));
		y(i).deltas=RmgData.mvector(:,y(i).RRMsteps)-repmat(y(i).baselineVector,1,length(y(i).RRMsteps));
		targetARM=find(ARMField==RmgData.treatmentAFFields(y(i).RRMsteps(1)));
		if length(targetARM) > 0
			y(i).ARMsusceptibility=ARM(targetARM(end)).ARMsusceptibility;
		else
			y(i).ARMsusceptibility=NaN;
		end
		y(i).Brrm=mu0*y(i).deltas(3,:)/y(i).ARMsusceptibility;

	end
end