function y=RmgLowrieFullerCurves(RmgData,varargin)

% y = RmgLowrieFullerCurves(Rmg)
%
% returns a Lowrie-Fuller structure for all AF of ARM with AF of corresponding
% IRM in Rmg.
%
% Last updated by Robert E. Kopp, March 1 2008
% Copyright (C) 2008 Robert E. Kopp, licensed under GNU GPL v.3


	y.experiment='Lowrie-Fuller';

	candidateARMBlocks=intersect(find(strcmpi(RmgData.BlockType(1:end-1),'ARM')),find(strcmpi(RmgData.BlockType(2:end),'AF')));
	candidateIRMBlocks=intersect(find(strcmpi(RmgData.BlockType(1:end-1),'IRM')),find(strcmpi(RmgData.BlockType(2:end),'AF')));

	if length(candidateARMBlocks)*length(candidateIRMBlocks) == 0
		y.doesExist = 0;
		return;
	end

	for i=1:length(candidateIRMBlocks)
		steps=find(RmgData.stepBlock==candidateIRMBlocks(i));
		if length(steps)>0
			IRMstep(i)=steps(end);
			IRMLevel(i)=abs(RmgData.treatmentDCFields(IRMstep(end)));
		end
	end

	candidateMatches=[];
	for i=1:length(candidateARMBlocks)
		steps=find(RmgData.stepBlock==candidateARMBlocks(i));
		if length(steps)>0
			ARMstep(i)=steps(end);
			ARMAFLevel(i)=RmgData.treatmentAFFields(ARMstep(end));
			candidatePairs=find(IRMLevel==ARMAFLevel(i));
			if length(candidatePairs>0)
				candidateMatches(i)=candidatePairs(end);
			end
		end
	end
	
	if length(candidateMatches) == 0
		y.doesExist = 0;
		return;
	end
	
	count=0;
	for i=1:length(candidateARMBlocks)
		if candidateMatches(i)>0
			count=count+1;
			y(count).doesExist=1;
			y(count).ARMAF=RmgExtractAFOfStep(RmgData,ARMstep(i));
			y(count).IRMAF=RmgExtractAFOfStep(RmgData,IRMstep(candidateMatches(i)));
			y(count).deltaMDF = y(count).ARMAF.MDF - y(count).IRMAF.MDF;
		end
	end
end