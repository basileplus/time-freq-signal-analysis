% ----------------------------------------------------------
% TRAITEMENT DU SIGNAL  -- Analyse de signaux Doppler
% 
% Correction - Jean-Francois GIOVANNELLI
% Derniere modification : 19-10-97 par JFG.
%
% NormSpec.m : Fonction de normalisation des spectres.
% Syntaxe :    Spec = NormSpec(Spec,Option)
%
% Entree : Spec	suite des spectres a normaliser en colonne
%		Option	indique si la normalisation souhaitee se fait par
%		rapport au max des spectres (Option='M') ou par 
%		rapport au min et au Max (Option='mM') ou
%		par rapport a leur puissance (Option='P')
%
%		Sortie	: 	Spec 		Spectres normalises
%
% ----------------------------------------------------------

% Declaration de la fonction.
	function Spec = NormSpec(Spec,Option)

% Parametres
	LongSpec = size(Spec,1);

% Normalisation par le maximum
if Option=='M'
	Max = max(Spec);
	Spec = Spec ./ Max(ones(LongSpec,1),:);
end

% Normalisation par le min et le max
if Option=='mM'
	Max = max(Spec);
	Min = min(Spec);
	Spec = (Spec - Min(ones(LongSpec,1),:)) ./ (Max(ones(LongSpec,1),:)- Min(ones(LongSpec,1),:));
end

% Normalisation par la puissance
if Option=='P'
	Puiss = mean(Spec);
	Spec = Spec ./ Puiss(ones(LongSpec,1),:);
end

