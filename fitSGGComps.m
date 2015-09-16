function f=fitSGGComps(x,y,means,stds,qs, ps)


if size(x,1)==1, x=x'; end;
if size(y,1)==1, y=y'; end;

SGG1=fittype('a1*SGG(x,m1,s1,q1,2)','coeff',{'a1'},'problem',{,'m1','s1','q1'});
SGG2=fittype('a1*SGG(x,m1,s1,q1,2)+a2*SGG(x,m2,s2,q2,2)','coeff',{'a1','a2'},'problem',{'m1','s1','q1','m2','s2','q2'});
SGG3=fittype('a1*SGG(x,m1,s1,q1,2)+a2*SGG(x,m2,s2,q2,2)+a3*SGG(x,m3,s3,q3,2)','coeff',{'a1','a2','a3'},'problem',{'m1','s1','q1','m2','s2','q2','m3','s3','q3'});
SGG4=fittype('a1*SGG(x,m1,s1,q1,2)+a2*SGG(x,m2,s2,q2,2)+a3*SGG(x,m3,s3,q3,2)+a4*SGG(x,m4,s4,q4,2)','coeff',{'a1','a2','a3','a4'},'problem',{'m1','s1','q1','m2','s2','q2','m3','s3','q3','m4','s4','q4'});
SGG5=fittype('a1*SGG(x,m1,s1,q1,2)+a2*SGG(x,m2,s2,q2,2)+a3*SGG(x,m3,s3,q3,2)+a4*SGG(x,m4,s4,q4,2)+a5*SGG(x,m5,s5,q5,2)','coeff',{'a1','a2','a3','a4','a5'},'problem',{'m1','s1','q1','m2','s2','q2','m3','s3','q3','m4','s4','q4','m5','s5','q5'});


n=length(means);
SGGfittype=SGG1;
if n==2
        SGGfittype=SGG2;
elseif n==3
        SGGfittype=SGG3;
elseif n==4
        SGGfittype=SGG4;
elseif n==5 
        SGGfittype=SGG5;
end

StartPoint=repmat(max(0,trapz(x,y)/n),1,n);
Seed={};
for i=1:n
   Seed={Seed{:} means(i) stds(i) qs(i)}; 
end

%fitopts=fitoptions('METHOD','NonlinearLeastSquares','MaxFunEvals',10000,'Display','iter','Lower',repmat([0 -Inf 0 0 1],1,n),'Upper',repmat([Inf Inf Inf 2 Inf],1,n),'StartPoint',StartPoint);
fitopts=fitoptions('METHOD','NonlinearLeastSquares','MaxFunEvals',10000,'Display','iter','Lower',repmat(0,1,n),'Upper',repmat(Inf,1,n),'StartPoint',StartPoint)

[fitted,goodness,out]=fit(x,y,SGGfittype,fitopts,'problem',Seed)
f.fit=fitted;
f.goodness=goodness;
f.out=out;

values=coeffvalues(f.fit);
f.a = values;
f.m = means;
f.s = stds;
f.q = qs;
f.p = ps;

errorranges=confint(f.fit);
foursigma=errorranges(2,:)-errorranges(1,:);

f.a_error95 = .5*foursigma;
f.m_error95 = repmat(0,1,n);
f.s_error95 = repmat(0,1,n);
f.q_error95 = repmat(0,1,n);
f.p_error95 = repmat(0,1,n);

f.x = x;
f.expected=f.fit(f.x);

for i=1:n
    f.y(:,i) = f.a(i)*SGG(x,f.m(i),f.s(i),f.q(i),f.p(i));
    f.totalArea(i)=trapz(x,f.y(:,i));
    
    f.mean(i)=trapz(x,f.y(:,i).*x)/trapz(x,f.y(:,i));
    f.dispersion(i)=sqrt(trapz(x,((x-f.mean(i)).^2).*f.y(:,i))/trapz(x,f.y(:,i)));
	f.skewness(i)=trapz(x,((x-f.mean(i)).^3).*f.y(:,i))/(f.dispersion(i)^3);


end