function y=RmgSIRMDerivativeCurveFits(curve)

y=curve;
curve.AF.logderivSmooth=curve.AF.logderivSmooth';
curve.IRM.logderivSmooth=curve.IRM.logderivSmooth';

fitopts=fitoptions('gauss1','Lower',[0 -Inf 0]);

[y.AF.logderivfit(1).fit,y.AF.logderivfit(1).goodness,y.AF.logderivfit(1).out]=fit(curve.AF.logDerivFields',curve.AF.logderivSmooth,'gauss1',fitopts);
[y.IRM.logderivfit(1).fit,y.IRM.logderivfit(1).goodness,y.IRM.logderivfit(1).out]=fit(y.IRM.logDerivFields',curve.IRM.logderivSmooth,'gauss1',fitopts);

for i=2:5

    
    fitopts=fitoptions(['gauss',num2str(i)],'Lower',repmat([0 -Inf 0],1,i));
    
    [y.IRM.logderivfit(i).fit,y.IRM.logderivfit(i).goodness,y.IRM.logderivfit(i).out]=fit(y.IRM.logDerivFields',curve.IRM.logderivSmooth,['gauss',num2str(i)],fitopts);    
    y.IRM.logderivfit(i).Fratio=((y.IRM.logderivfit(i-1).goodness.sse-y.IRM.logderivfit(i).goodness.sse)/y.IRM.logderivfit(i).goodness.sse)/((y.IRM.logderivfit(i-1).goodness.dfe-y.IRM.logderivfit(i).goodness.dfe)/y.IRM.logderivfit(i).goodness.dfe);
    y.IRM.logderivfit(i).pvalue=1-fcdf(y.IRM.logderivfit(i).Fratio,y.IRM.logderivfit(i).goodness.dfe,y.IRM.logderivfit(i-1).goodness.dfe);

    if y.IRM.logderivfit(i).pvalue > 0.01
        y.IRM.logderivbestfitgaussians=i-1;
        y.IRM.logderivbestfit=y.IRM.logderivfit(i-1);
        break;
    end

end


for i=2:5

    
        fitopts=fitoptions(['gauss',num2str(i)],'Lower',repmat([0 -Inf 0],1,i));

    [y.AF.logderivfit(i).fit,y.AF.logderivfit(i).goodness,y.AF.logderivfit(i).out]=fit(curve.AF.logDerivFields',curve.AF.logderivSmooth,['gauss',num2str(i)],fitopts);    
    y.AF.logderivfit(i).Fratio=((y.AF.logderivfit(i-1).goodness.sse-y.AF.logderivfit(i).goodness.sse)/y.AF.logderivfit(i).goodness.sse)/((y.AF.logderivfit(i-1).goodness.dfe-y.AF.logderivfit(i).goodness.dfe)/y.AF.logderivfit(i).goodness.dfe);
    y.AF.logderivfit(i).pvalue=1-fcdf(y.AF.logderivfit(i).Fratio,y.AF.logderivfit(i).goodness.dfe,y.AF.logderivfit(i-1).goodness.dfe);

    if y.AF.logderivfit(i).pvalue > 0.01
        y.AF.logderivbestfitgaussians=i-1;
        y.AF.logderivbestfit=y.AF.logderivfit(i-1);
        break;
    end

end


end