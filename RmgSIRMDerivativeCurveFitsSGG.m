function y=RmgSIRMDerivativeCurveFitsSGG(curve)

y.IRMfit=fitSGGMulti(curve.IRM.logDerivFields,curve.IRM.logderivSmooth);
y.AFfit=fitSGGMulti(curve.AF.logDerivFields,curve.AF.logderivSmooth);

end