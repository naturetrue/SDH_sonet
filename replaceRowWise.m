function Xout=replaceRowWise(Xin,xpos,Y,ypos)
% Xin is a matrix whose elements are numbered row-wise. 
% xpos is vector of positions within Xin.
% Y is a matrix whose elements are numbered row-wise.
% ypos is a vector of positions within Yin
% Xout is a copy of Xin, with the elements in the positions xpos replaced
% by the elelements in the positions ypos of Y. 
Xin=squeeze(Xin);
Y=squeeze(Y);
if not(length(ypos)==length(xpos))
    disp('+++ERROR replaceRowWise: xpos and ypos have to have the same length.+++')
elseif not(ismatrix((Xin))) || not(ismatrix((Y)))
    disp('+++ERROR replaceRowWise: Xin and Y cannot have more than 2 dimensions.+++')
elseif not(isvector(xpos)) || not(isvector(ypos))
    disp('+++ERROR replaceRowWise: xpos and ypos have to be vectors.+++')
else
    Xin=Xin'; Y=Y';
    Xin(xpos)=Y(ypos);
    Xout=Xin';
end

