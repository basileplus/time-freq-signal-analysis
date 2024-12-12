function  WaveDraw(Family,par,Gender,n,j)
% WaveDraw -- Draw the  periodized orthogonal wavelet and is
% Fourier Transform. 
%
% Usage
%    WaveDraw([Family,par,Gender,n,j])
%  Inputs
%    Family   string: 'Haar', 'Daubechies', 'Coiflet', 'Symmlet',
%             Default: 'Symmlet'
%    par      integer parameter to MakeONFilter, MakeDDFilter. 
%             When Default 'Symmlet' active, default 8.
%
%    Gender   'Mother', 'Father'
%    n        signal length (dyadic)
%    j        Scale factor
%  Description
%    The Haar filter (which could be considered a Daubechies-2) was the
%    first wavelet, though not called as such, and is discontinuous.
%
%    The Coiflet filters are designed to give both the mother and father
%    wavelets 2*Par vanishing moments; here Par may be one of 1,2,3,4 or 5.
%
%    The Daubechies filters are minimal phase filters that generate wavelets
%    which have a minimal support for a given number of vanishing moments.
%    They are indexed by their length, Par, which may be one of
%    4,6,8,10,12,14,16,18 or 20. The number of vanishing moments is par/2.
%
%    Symmlets are also wavelets within a minimum size support for a given 
%    number of vanishing moments, but they are as symmetrical as possible,
%    as opposed to the Daubechies filters which are highly asymmetrical.
%    They are indexed by Par, which specifies the number of vanishing
%    moments and is equal to half the size of the support. It ranges 
%    from 4 to 10.
%
% 
%  Example:
%     
% 
%


%nargin

 if (nargin < 1)
       Family = 'Symmlet';
       par    = 8;
       Gender = 'Mother';
       n=2^6;
 end

 
 if nargin == 3,
   j=3;
   n = 2^(j+3)
 end


if (nargin>=5)
  i=j;
else
  j=3;
  i= (log(n)/log(2))-1;
end

 
  qmf = MakeONFilter(Family,par);
   w = zeros(1,n);
  w2 = zeros(1,n);
  if strcmp(Gender,'Mother'),
   w(1+(2^j)*1.5 )=1;
  else
    w(1+(2^j)*0.5)=1;
  end
  
   % w(13) = 1;
    wave = IWT_PO(w,j,qmf);
   %wave =  MakeWavelet(j,0.5,Family,par,Gender,n);


    wave2 = MakeWavelet(i,1,Family,par,Gender ,n); %Pour fft
    
 subplot(2,1,1)
 plot((1:n)-n/2.,(wave));
  title([Family ,' ', Gender , ' Wavelet']) 
 subplot(2,1,2)
  FTwave=abs(fft(wave2));
  plot(linspace(-0.5,0.5,n),fftshift(FTwave));
  title(['Fourier transform of ',Family ,' ',  Gender , ' Wavelet']) 
