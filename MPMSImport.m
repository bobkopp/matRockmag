function y=MPMSImport(filenam)

periodsInName=regexpi(filenam,'\.');
extensionPeriod=periodsInName(length(periodsInName));

y.sample=filenam(1:extensionPeriod-1);

[y.data]=textread(filenam,'','delimiter',',','whitespace','','emptyvalue',NaN,'headerlines',31);

y.field=y.data(:,3)/1e4;
y.temperature=y.data(:,4);
y.moment=y.data(:,5)/1e3;

y.RTPoints=find(abs(y.temperature-300)<.5);

y.FCTemp=[y.temperature(1:y.RTPoints(1))];
y.FCMoment=[y.moment(1:y.RTPoints(1))];
y.FCdMoment=diff(y.FCMoment)./diff(y.FCTemp);
y.ZFCTemp=[y.temperature(y.RTPoints(1)+1:y.RTPoints(2))];
y.ZFCMoment=[y.moment(y.RTPoints(1)+1:y.RTPoints(2))];
y.ZFCdMoment=diff(y.ZFCMoment)./diff(y.ZFCTemp);
y.LTCTemp=[y.temperature(y.RTPoints(length(y.RTPoints)-1):y.RTPoints(length(y.RTPoints)))];
y.LTCMoment=[y.moment(y.RTPoints(length(y.RTPoints)-1):y.RTPoints(length(y.RTPoints)))];

%y.FCInterp=fit(y.FCTemp,y.FCMoment,'linearinterp');
%y.ZFCInterp=fit(y.ZFCTemp,y.ZFCMoment,'linearinterp');

FC80=interpolate(y.FCTemp,y.FCMoment,80);
FC150=interpolate(y.FCTemp,y.FCMoment,150);

ZFC80=interpolate(y.ZFCTemp,y.ZFCMoment,80);
ZFC150=interpolate(y.ZFCTemp,y.ZFCMoment,150);


y.FCMomentNorm=y.FCMoment/FC80;
y.ZFCMomentNorm=y.ZFCMoment/FC80;
y.LTCMomentNorm=y.LTCMoment/y.LTCMoment(1);


reversalPoint=find(y.LTCTemp==min(y.LTCTemp));
y.LTCReversalPoint=reversalPoint;
y.LTCCoolingdMoment=diff(y.LTCMoment(1:reversalPoint))./diff(y.LTCTemp(1:reversalPoint));
y.LTCWarmingdMoment=diff(y.LTCMoment(reversalPoint:end))./diff(y.LTCTemp(reversalPoint:end));

y.dFC=(FC80-FC150)/(FC80);
y.dZFC=(ZFC80-ZFC150)/(ZFC80);
y.dFCtodZFC=y.dFC/y.dZFC;

y.memory=y.LTCMoment(end)/y.LTCMoment(1);
