function tx = sdhTransmit(allImages)
    
% We assume that the pointer is between 0 and 521 so we stay in the same frame.''
secretPointers=[SOME_UNKNOWN_VALUES]; secretIter=1;
Nframes=ceil(length(allImages)/(260*9))+1; % truncamiento por arriba de la operacion esa 
POH=uint8(ones(9,1)); % POH 9x1 en columna
STMS=uint8(zeros(9,270,Nframes)); % paquetes necesarios
NDFon=uint16(hex2dec('9000')); % No Data Flag en
NDFoff=uint16(hex2dec('6000')); % No Data Flag dis
pointerOld=secretPointers(1);
CV4Old=uint8(3*ones(9,261)); % matriz de 3 de tam del contenedor con relleno
for iter = 1:Nframes
aux=STMS(1:9,10:270,iter); % PDH contenedor virtual 
if positiveJustificationHappens(iter) % Justificacion positiva
pointerNew=pointerOld+1; % incremento del puntero por la justificacion positiva
aux=replaceRowWise(aux,1:3*261,CV4Old,9*261-3*261-pointerOld*3+1:9*261-pointerOld*3);
aux=replaceRowWise(aux,3*261+4:3*261+(pointerOld+1)*3,CV4Old,9*261-pointerOld*3+1:9*261); 
else
aux=replaceRowWise(aux,1:3*261+pointerOld*3,CV4Old,9*261-3*261-pointerOld*3+1:9*261);
end
STMS(1:9,10:270,iter)=aux;
if newImageStarts(iter)
pointerNew=secretPointers(secretIter); % assigns a pointer value between 0 and 521

secretIter=secretIter+1;

H1H2=uint16(pointerNew)+NDFon;
elseif positiveJustificationHappens(iter)
H1H2=uint16(pointerOld)+NDFoff;

H1H2=bitxor(H1H2,uint16(hex2dec('2AA')));
else
H1H2=uint16(pointerNew)+NDFoff;
end
aux=typecast(H1H2,'uint8');
H1=aux(2); H2=aux(1);
STMS(4,1,iter)=H1;
STMS(4,4,iter)=H2;
if iter<Nframes

auxcv=zeros(9,260);

auxcv=replaceRowWise(auxcv,1:9*260,allImages,(iter-1)*9*260+1:iter*9*260);

CV4New=[POH,auxcv];

auxstm=STMS(1:9,10:270,iter);

auxstm=replaceRowWise(auxstm,1+3*261+pointerNew*3:9*261,CV4New,1:9*261-3*261-pointerNew*3);

STMS(1:9,10:270,iter)=auxstm;
end
CV4Old=CV4New;
pointerOld=pointerNew;
end
tx=uint8(zeros(1,9*270*(Nframes)));
for iter=1:Nframes
tx=replaceRowWise(tx,(iter-1)*9*270+1:iter*9*270,(STMS(:,:,iter)),1:9*270);
end
end