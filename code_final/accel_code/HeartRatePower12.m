function f=HeartRatePower12(P,f)

%rr=rrin/64;t=0;
%for i=1:length(rr)-1
%    t(i+1)=t(i)+rr(i);
%end;

%[P,f]=HeartRateLomb(rr,t);

ind=find(f>=0.04&f<=0.15);
f=sum(P(ind));
