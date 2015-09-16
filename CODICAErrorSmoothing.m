function f=CODICAErrorSmoothing(x,y, varargin)

    smoothSpan=0;
    smoothOrder=3;
    
    if nargin>3
        smoothSpan=varargin{1};
        smoothOrder=varargin{2};
    elseif nargin>2
        smoothSpan=varargin{1};
    end

% following Egli (2003)


    xscaling=xscaletanh(x,y)
    
    yres=xscaling.yres;
    ymax=xscaling.ymax;
    a=xscaling.a;
    p=xscaling.p;
    xmedian=xscaling.xmedian;

    residual=y-xscaling(x);
    
    errscaling=xscalesin(x,residual);
    
    perr=errscaling.p;

    if smoothSpan==0, smoothSpan=double(int32(length(x)*.06)*2+1); end;
 
    residualsSmooth=butterFilter(residual,smoothSpan,smoothOrder);
    
    f.residual=residual;
    f.smoothed=residualsSmooth;
    
    rescaled=xscaling(x)+residualsSmooth;
    
    f.errscaling=errscaling;
    f.xscaling=xscaling;
    f.rescaled=rescaled;

end

function g=xscaletanh(x,y)

    [maxy,maxyindex]=max(y);
    xmax=x(maxyindex);

    [miny,minyindex]=min(y);
    xmin=x(minyindex);

    scalefittype = fittype('yres+.5*ymax*(1-real(tanh(a*(x^p-xmedian^p))))','coeff',{'yres','ymax','a','p','xmedian'});
    fitopts=fitoptions('METHOD','NonlinearLeastSquares','MaxFunEvals',10000,'Display','iter','Lower',[0 0 -Inf 0 -Inf],'Upper',[Inf Inf Inf 1 Inf],'StartPoint',[miny maxy 5/((xmax-xmin)^.05) .05 (xmax+xmin)/2]);

    [fitted,goodness,out]=fit(x,y,scalefittype,fitopts);
    g=fitted;
end

function g=xscalesin(x,y)
    scalefittype=fittype('a1*sin(b1*x^p+c1)','coeff',{'a1','b1','c1','p'});
    trialsine=fit(x.^.05,y,'sin1')
    fitopts=fitoptions('METHOD','NonlinearLeastSquares','MaxFunEvals',10000,'Display','iter','Lower',[0 -Inf -Inf 0 ],'Upper',[Inf Inf Inf 1],'StartPoint',[trialsine.a1 trialsine.b1 trialsine.c1 .05 ]);
    [fitted,goodness,out]=fit(x,y,scalefittype,fitopts)
    g=fitted;
end

function g=butterFilter(x,cutoff,order)
    transformed=fft(x);
    v=1:.5*length(transformed);
    bfilter=1-1./((1+(cutoff./v).^order).^(1/2*order));
    if mod(length(transformed),2)==1
        bfilter=[1 bfilter bfilter(end:-1:1)]';
    else
        bfilter=[1 bfilter bfilter(end-1:-1:1)]';
    end
    g=ifft(transformed.*bfilter);
end