function  soundp(X,FS)


%%%%% Fonction cree le 3 novembre 2004 
%%%%% par Thomas Rodet 
%
%
% interfacage de la fonction sound 
%
% conversion du signal d'entre entre -1 et 1
% rééchantillonnage a la frequence de sound 8192 hz
%
% exemple  soundp(sig,44100); 

Fe=8192;

if ndims(X)>2, error('Requires 2-D values only.'); end

if size(X,1)==1, X = X.'; end

if(max(X)>abs(min(X)))
whos  X=X/max(X);
else
   X=X/abs(min(X));
end

tailleX=length(X);

absin=0:tailleX-1;
absin=absin/FS;

absout=0:1/Fe:absin(end);

Xout= interp1(absin,X,absout,'linear');

%figure 
%hold on 
%plot(X)
%plot(Xout,'r')


sound(Xout);