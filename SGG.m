function y=SGG(xvalues,mvalues,svalues,qprimevalues,pvalues)

% we've defined qprime such that (1,2) maps to (-1,0)
qvalues=mod(qprimevalues+1,2)-1;

svalies=svalues+(svalues==0)*1e-17;
qvalues=qvalues+(qvalues==0)*1e-17;
pvalues=pvalues+(pvalues==0)*1e-17;

[x,m,s,q,p]=ndgrid(xvalues,mvalues,svalues,qvalues,pvalues);
s=s+1e-9*(s==0);
p=p+1e-9*(p==0);
q=q+1e-9*(q==0);


y=abs(q.*exp(q.*(x-m)./s)+exp((x-m)./(q.*s))./q).*exp(-abs(log((exp(q.*(x-m)./s)+exp((x-m)./(q.*s)))/2)).^p/2)./(2.^(1+1./p).*s.*gamma(1+1./p).*(exp(q.*(x-m)./s)+exp((x-m)./(q.*s))));
