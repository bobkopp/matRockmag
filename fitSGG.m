function f=fitSGG(x,y,varargin)

if size(x,1)==1, x=x'; end;
if size(y,1)==1, y=y'; end;

SGG1=fittype('a1*SGG(x,m1,s1,q1,2)','coeff',{'a1','m1','s1','q1'});
SGG2=fittype('a1*SGG(x,m1,s1,q1,2)+a2*SGG(x,m2,s2,q2,2)','coeff',{'a1','m1','s1','q1','a2','m2','s2','q2'});
SGG3=fittype('a1*SGG(x,m1,s1,q1,2)+a2*SGG(x,m2,s2,q2,2)+a3*SGG(x,m3,s3,q3,2)','coeff',{'a1','m1','s1','q1','a2','m2','s2','q2','a3','m3','s3','q3'});
SGG4=fittype('a1*SGG(x,m1,s1,q1,2)+a2*SGG(x,m2,s2,q2,2)+a3*SGG(x,m3,s3,q3,2)+a4*SGG(x,m4,s4,q4,2)','coeff',{'a1','m1','s1','q1','a2','m2','s2','q2','a3','m3','s3','q3','a4','m4','s4','q4'});
SGG5=fittype('a1*SGG(x,m1,s1,q1,2)+a2*SGG(x,m2,s2,q2,2)+a3*SGG(x,m3,s3,q3,2)+a4*SGG(x,m4,s4,q4,2)+a5*SGG(x,m5,s5,q5,2)','coeff',{'a1','m1','s1','q1','a2','m2','s2','q2','a3','m3','s3','q3','a4','m4','s4','q4','a5','m5','s5','q5'});


n=1;
SGGfittype=SGG1;
if nargin>2
    if varargin{1}==2
        n=2;
        SGGfittype=SGG2;
    elseif varargin{1}==3
        n=3;
        SGGfittype=SGG3;
    elseif varargin{1}==4
        n=4;
        SGGfittype=SGG4;
    elseif varargin{1}==5
        n=5;
        SGGfittype=SGG5;
    end
end

StartPoint=0;
if nargin>3
    for i=2:length(varargin)
        if strcmp(varargin{i},'StartPoint')
            StartPoint=varargin{i+1};
            i=i+1;
        end
    end
end

if StartPoint==0
    trialGauss=fit(x,y,'gauss1')
    StartPoint=repmat([trialGauss.a1/n trialGauss.b1 trialGauss.c1 1 2],1,n);
end

StartPoint=StartPoint(sort([1:5:length(StartPoint) 2:5:length(StartPoint) 3:5:length(StartPoint) 4:5:length(StartPoint)]));

%fitopts=fitoptions('METHOD','NonlinearLeastSquares','MaxFunEvals',10000,'Display','iter','Lower',repmat([0 -Inf 0 0 1],1,n),'Upper',repmat([Inf Inf Inf 2 Inf],1,n),'StartPoint',StartPoint);
fitopts=fitoptions('METHOD','NonlinearLeastSquares','MaxFunEvals',10000,'Display','iter','Lower',repmat([.01 -10 0 0.5],1,n),'Upper',repmat([Inf 10 Inf 1.5],1,n),'StartPoint',StartPoint)

[fitted,goodness,out]=fit(x,y,SGGfittype,fitopts)
f.fit=fitted;
f.goodness=goodness;
f.out=out;

values=coeffvalues(f.fit);
f.a = values(1:4:end);
f.m = values(2:4:end);
f.s = values(3:4:end);
f.q = values(4:4:end);
f.p = repmat(2,1,n);

errorranges=confint(f.fit);
foursigma=errorranges(2,:)-errorranges(1,:);

f.a_error95 = .5*foursigma(1:5:end);
f.m_error95 = .5*foursigma(2:5:end);
f.s_error95 = .5*foursigma(3:5:end);
f.q_error95 = .5*foursigma(4:5:end);
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

