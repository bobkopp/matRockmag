function f=fitSGGMulti(x,y,varargin)

maxn=min(floor((length(x)-1)/5),5);

if nargin>2
    maxn=varargin{1};
end

i=1;
f.fitSGG(1)=fitSGG(x,y,1);
f.bestfitSGGn=i;
f.bestfit=f.fitSGG(i);

if maxn>1
    for i=2:maxn
        
        StartPoint(1:5:5*(i-1))=f.fitSGG(i-1).a*(i-1)/i;
        StartPoint(2:5:5*(i-1))=f.fitSGG(i-1).m;
        StartPoint(3:5:5*(i-1))=f.fitSGG(i-1).s*(i-1)/i;
        StartPoint(4:5:5*(i-1))=1;
        StartPoint(5:5:5*(i-1))=2;
        StartPoint=[StartPoint mean(f.fitSGG(i-1).a) mean(f.fitSGG(i-1).m) mean(f.fitSGG(i-1).s) 1 2];
            
        
        f.fitSGG(i)=fitSGG(x,y,i,'StartPoint',StartPoint);

        f.Fratio(i)=((f.fitSGG(i-1).goodness.sse-f.fitSGG(i).goodness.sse)/f.fitSGG(i).goodness.sse)/((f.fitSGG(i-1).goodness.dfe-f.fitSGG(i).goodness.dfe)/f.fitSGG(i).goodness.dfe);
        f.pvalue(i)=1-fcdf(f.Fratio(i),f.fitSGG(i).goodness.dfe,f.fitSGG(i-1).goodness.dfe);

        if f.pvalue(i) > 0.01
            f.bestfitSGGn=i-1;
            f.bestfit=f.fitSGG(i-1);
            break;
        else
            f.bestfitSGGn=i;
            f.bestfit=f.fitSGG(i);
        end

    end
end

f.a = f.bestfit.a;
f.m = f.bestfit.m;
f.s = f.bestfit.s;
f.q = f.bestfit.q;
f.p = f.bestfit.p;
f.totalArea = f.bestfit.totalArea;
f.mean=f.bestfit.mean;
f.dispersion=f.bestfit.dispersion;
f.skewness=f.bestfit.skewness;