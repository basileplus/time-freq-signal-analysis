% ----------------------------------------------------------
% TRAITEMENT DU SIGNAL  -- Analyse de signaux Doppler
% 
% Correction - Jean-Francois GIOVANNELLI
% Derniere modification : 19-10-97 par JFG.
%
%  Decoupe.m : Fonction de decoupage des signaux.
%
%   Syntaxe  : MatSig = Decoupe(Sig,LongFen,UnSurQ)
%
%    Entree  : Sig     :  signal a decouper
%             LongFen  :  taille de la fenetre de stationnarite
%             UnSurQ   :  une fois que le signal est decoupe 
%                        en fenetres, cette procedure ne revoit 
%                        qu'une fenetre sur UnSurQ (utile pour 
%                        economise de la memoire).
%
%    Sortie : MatSig, signaux decoupes, par colonnes
%
%
% ----------------------------------------------------------

% Declaration de la fonction.
	function MatSig = Decoupe(Sig,LongFen,UnSurQ)


% Mise en colonne du signal
	Sig = Sig(:);


% Parametres des siganux a traiter
	LongSig  = size(Sig,1);
	

% Constructiuon de la matrice d'indice qui va bien
	Ind1 = (1:LongFen)';
	Ind2 = (0:UnSurQ:LongSig-LongFen);

	
% Construction de la matrices de signaux
MatSig = Sig( Ind1(:,ones(1,size(Ind2,2))) + Ind2(ones(size(Ind1,1),1),:) );