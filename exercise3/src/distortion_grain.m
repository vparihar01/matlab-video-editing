% DISTORTION_GRAIN(VIDEO) adds film grain to an existing frame in
% VIDEO.FRAME(1).FILTERED.
%  
%   VIDEO:  a structure containing an array of frames where frame(1)
%   contains the most current frame. 
%
%   VIDEO = DISTORTION_GRAIN(VIDEO, PARAM1, ...) returns the original video structure
%   with the updated current video.frame(1).filtered.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   IMPLEMENTATION:
%       Filmkörnung wurde durch den Matlab Befehl "imnoise" erzeugt.
%       Um den gewünschten Effekt zu erzielen wurde als Typ des Rauschens 'speckle' gewählt.
%       Dieser Typ erzeugt ein multiplikatives Rauschen mit einer gewissen
%       Varianz um den Mittelwert 0.
%       Der Parameter "variance" stellt die Varianz dar, wobei man keinen
%       Mittelwert übergeben muss, da dieser immer als 0 genommen wird.
%       Das Rauschen wird auf jeden der 3 Farbkanäle angewandt und erzeugt
%       dadurch ein buntes Rauschen im Ausgabebild.
%   
%   PHYSICAL BACKGROUND:
%       "Filmkorn nennt man in der Fotografie die kleinsten Strukturen des
%       entwickelten Films, die erst bei starker Vergrößerung gut sichtbar
%       werden. Fotochemisch handelt es sich dabei um Zusammenballungen von
%       feinst verteilten Silberpartikeln, die für die Zerrissenheit
%       gleichmäßig geschwärzter Flächen verantwortlich sind.
%       Die Fein- oder Grobkörnigkeit ist sehr vom Filmtyp, aber auch von
%       den Entwicklungsbedingungen abhängig. Filme mit niedriger
%       Lichtempfindlichkeit, also mit niedrigen ISO-Werten, sind in der
%       Regel sehr viel feinkörniger als stark lichtempfindliche Filme mit
%       hohen ISO-Werten."
%       Weiters gilt zu beachten, dass "moderne Filme mit ISO 400 können
%       durchaus weniger störendes Korn aufweisen als mittelempfindliche
%       Filme (ISO 50 bis ISO 100) aus den 1970er Jahren."
%       Quelle: http://de.wikipedia.org/wiki/Filmkorn
%
function video = distortion_grain(video, variance)

    if(video.frame(1).frame_nr == -1)
        return
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Apply imnoise filter on the whole image 
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % apply noise to RED Channel
    video.frame(1).filtered(:,:,1) = imnoise(video.frame(1).filtered(:,:,1), 'speckle', variance);
    % apply noise to GREEN Channel
    video.frame(1).filtered(:,:,2) = imnoise(video.frame(1).filtered(:,:,2), 'speckle', variance);
    % apply noise to BLUE Channel
    video.frame(1).filtered(:,:,3) = imnoise(video.frame(1).filtered(:,:,3), 'speckle', variance);
    
    