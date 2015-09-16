function y=RmgSIRMDerivativeCurveFitComps(curve,means,stds)

y=curve;
curve.AF.logderivSmooth=curve.AF.logderivSmooth';
curve.IRM.logderivSmooth=curve.IRM.logderivSmooth';

y.means=means;
y.stds=stds;

y.fitequation='0';
y.coeffs={};
for i=1:length(means)
    y.fitequation=[y.fitequation '+a' num2str(i) '*pdf(' 39 'norm' 39 ',x,' num2str(means(i)) ',' num2str(stds(i)) ')'];
    y.coeffs={y.coeffs{:},['a' num2str(i)]};
end

RMGfittype=fittype(y.fitequation,'coeff',y.coeffs)
fitopts=fitoptions('METHOD','NonlinearLeastSquares','Display','iter','Lower',repmat([0],length(means),1),'Upper',repmat([Inf],length(means),1),'StartPoint',repmat([max(curve.AF.logderivSmooth)/length(means)],length(means),1))

[y.AF.fit,y.AF.goodness,y.AF.out]=fit(curve.AF.logDerivFields',curve.AF.logderivSmooth,RMGfittype,fitopts);
[y.IRM.fit,y.IRM.goodness,y.IRM.out]=fit(y.IRM.logDerivFields',curve.IRM.logderivSmooth,RMGfittype,fitopts);

end