function y=RmgFullerCurves(RmgData,varargin);

% y = RmgFullerCurves(Rmg)
%
% returns a Fuller Curves structure for Rmg.
%
% Last updated by Robert E. Kopp, March 1 2008
% Copyright (C) 2008 Robert E. Kopp, licensed under GNU GPL v.3

	y.experiment = 'Fuller';


	
	candidateNRMBlocks=intersect(find(strcmpi(RmgData.BlockType(1:end-1),'NRM')),find(strcmpi(RmgData.BlockType(2:end),'AF')));
	
	if length(candidateNRMBlocks)==0
	    y.doesExist=0; return;
	end

	y.doesExist=1;
	stepsNRMBlock=find(RmgData.stepBlock == candidateNRMBlocks(1));
	y.NRM=RmgExtractAFOfStep(RmgData,stepsNRMBlock(end));

	candidateIRMBlocks=intersect(find(strcmpi(RmgData.BlockType(1:end-1),'IRM')),find(strcmpi(RmgData.BlockType(2:end),'AF')));

	if length(candidateIRMBlocks) == 0
		y.doesExist = 0;
		return;
	end

	steps=find(RmgData.stepBlock==candidateIRMBlocks(end));
	if length(steps)>0
		y.IRM=RmgExtractAFOfStep(RmgData,steps(end));
	end
	
	y.doesExist=y.doesExist*y.IRM(1).doesExist;
	if y.doesExist==0
	    return;
	end
	
	y.trialFields=y.IRM.treatmentAFFields;
	y.calcIRM = y.IRM.mmag;
	y.calcNRM=abs(interp1(y.NRM.treatmentAFFields,y.NRM.mmag,y.trialFields,'linear','extrap'));
	
	y.NRMtoIRM=y.calcNRM(1)/y.calcIRM(1);
	

	candidateARMBlocks=intersect(find(strcmpi(RmgData.BlockType(1:end-1),'ARM')),find(strcmpi(RmgData.BlockType(2:end),'AF')));
	for i=1:length(candidateARMBlocks)
		steps=find(RmgData.stepBlock==candidateARMBlocks(i));
		if length(steps)>0
			y.ARM(i)=RmgExtractAFOfStep(RmgData,steps(end));
		end
	end


	for i=1:length(y.ARM)
		y.calcARM(i,:)=abs(interp1(y.ARM(i).treatmentAFFields,y.ARM(i).mmag,y.trialFields,'linear','extrap'));
	end
	
	y.ARMtoIRM=y.calcARM(:,1)/y.calcIRM(1);
	
end