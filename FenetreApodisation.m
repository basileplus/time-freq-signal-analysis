function win=FenetreApodisation(nom,taille)
% FenetreApodisation --  Genere une fenetre d'apodisation
%  Usage
%    win = FenetreApodisation(nom,taille)
%
%  Entrées
%    Nom   string: 'Rectangle', 'Hanning', 'Hamming',
%            'Gaussian', 'Blackman';
%
%    Taille   Taille du signal desiré
%
%  Sorties
%    win    Fenetre d'apodisation 1-d centre de taille Taille ;
%  Description
%    Rectangle		1
%    Hanning 		cos(pi*t)^2
%    Hamming		.54 + .46cos(2pi*t)
%    Gaussian		exp(-18 * t^2/2)
%    Blackman		.42 + .50*cos(2pi*t) + .08cos(4.*pi.*t)
%  Examples
%     win = FenetreApodisation('Rectangle',17);	plot(win);
%     win = FenetreApodisation('Hanning',  17);	plot(win);
%     win = FenetreApodisation('Hamming',  17);	plot(win);
%     win = FenetreApodisation('Gaussian', 17);	plot(win); 
%     win = FenetreApodisation('Blackman', 17);	plot(win);
%  See Also
%

t = ((1:taille)-((taille+1)/2))./(taille-1);


 
 if strcmp(nom,'Rectangle'),
 	win = ones(size(t));
 elseif strcmp(nom,'Hanning'),
	win = realpow(cos(pi.*t),2);
 elseif strcmp(nom,'Hamming'),
	win = .54 + .46*cos(2.*pi.*t);
 elseif (strcmp(nom,'Gaussian')|strcmp(nom,'gaussian')),
	win = exp(-realpow(t,2)*18);
 elseif strcmp(nom,'Blackman'),
	win = .42 + .50*cos(2.*pi.*t) + .08*cos(4.*pi.*t);
 end;

 

