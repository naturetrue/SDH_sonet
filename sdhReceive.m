function [imgs] = sdhReceive(tx)
    Npack = length(tx)/(9*270); % numero de tramas

    OldPointer = uint16(0);
    LastPointer = uint16(0);
    FirstPointer = uint16(0);

    Imagenes = uint8(zeros(1,260*297*3));

    CUNew = uint8(zeros(9,260));
    CUOld = uint8(zeros(9,260));

    for iter = 1:Npack
        
        STMS = uint8(zeros(9,270));
        STMS = replaceRowWise(STMS, 1:270*9, tx,((iter-1)*270*9 + 1):iter*270*9); % cargar en STM la primera trama

        H1 = STMS(4,1);
        H2 = STMS(4,4);
        H3 = uint8([0 0 0]);

        H1H2 = typecast([H2 H1],'uint16');
        OldPointer = LastPointer;
        LastPointer = H1H2;

        STM = uint8(zeros(9,260));
        STM = replaceRowWise(STM,1:9*260,STMS(1:9,11:270),1:9*260);

        if iter == 1 % primera trama
            FirstPointer = bitand(H1H2, hex2dec('03FF')); % primer puntero
            CUOld = replaceRowWise(CUOld,1:260*6 - FirstPointer*3,STM,260*3+FirstPointer*3+1:260*9);
        else % tramas restantes
            justification = bitand(LastPointer,hex2dec('9000'));
            if justification == hex2dec('9000') % si hay justificacion
                justPos = positiveJustificationHappens(OldPointer,LastPointer);
                if justPos == 1 %justificacion positiva
                    CUOld = replaceRowWise(CUOld,260*6-FirstPointer*3+1:260*9-3*FirstPointer,STM,1:260*3);
                    FirstPointer = FirstPointer + 1;
                    CUOld = replaceRowWise(CUOld,260*9-FirstPointer*3-2:260*9,STM, 260*3+4:260*3+FirstPointer*3);
                    Imagenes = replaceRowWise(Imagenes, (iter-1)*260*9+1:iter*260*9, CUOld,1:260*9);
                    CUNew = replaceRowWise(CUNew,1:260*6-FirstPointer*3, STM, 260*3 + FirstPointer*3+1:260*9);
                    CUOld = CUNew;
                else % justifcacion negativa
                    CUOld = replaceRowWise(CUOld,260*6-FirstPointer*3+1:260*9-3*FirstPointer,STM,1:260*3);
                    CUOld = replaceRowWise(CUOld,260*9-FirstPointer*3+1:260*9-FirstPointer*3+3,H3,1:3);
                    FirstPointer = FirstPointer - 1;
                    CUOld = replaceRowWise(CUOld,260*9-FirstPointer*3+1:260*9,STM,260*3+1:260*3 + FirstPointer*3);
                    Imagenes = replaceRowWise(Imagenes, (iter-1)*260*9+1:iter*260*9, CUOld,1:260*9);
                    CUNew = replaceRowWise(CUNew,1:260*6-FirstPointer*3, STM, 260*3 + FirstPointer*3+1:260*9);
                    CUOld = CUNew;
                end % fin if justificacion positiva o negativa
            else % si no hay justificacion
                CUOld = replaceRowWise(CUOld, 260*6-FirstPointer*3+1:260*9, STM,1:260*3 + FirstPointer*3);
                Imagenes = replaceRowWise(Imagenes,(iter-1)*260*9+1:iter*260*9,CUOld, 1:260*9);
                CUNew = replaceRowWise(CUNew,1:260*6-FirstPointer*3, STM, 260*3 + FirstPointer*3 + 1:260*9);
                CUOld = CUNew;
            end % if justificacion
        end % fin if primera trama
    end % fin for
    Img3 = uint8(zeros(260,297,3));
    for iter = 1:3
        Img3(:,:,iter) = replaceRowWise(Img3(:,:,iter),1:297*260, Imagenes,260*297*(iter-1) + 1:297*260*iter);
        figure(iter), imshow(Img3(:,:,iter));
    end % fin for iter
    imgs = Img3;
end % fin funcion