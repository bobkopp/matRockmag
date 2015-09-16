function AFLevel=RmgAFLevelFind(data, varargin)

for i=1:length(data)

    AFLevel(i)=1000e-4;

    if nargin>1
        if varargin{1}=='RRM'
            if length(data(i).stepsRRM>0)
                AFLevels=data(i).treatmentAFFields(data(i).stepsRRM);
                AFLevel(i)=AFLevels(end);
            end
        end
    end

    if length(data(i).stepsARM>0)
        AFLevels=data(i).treatmentAFFields(data(i).stepsARM);
        AFLevel(i)=AFLevels(end);
    end
end