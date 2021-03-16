function [hp] = positiveJustificationHappens(OldPointer, LastPointer)
    IOld = bitand(OldPointer, bin2dec('0000001010101010'));
    ILast = bitand(LastPointer, bin2dec('0000001010101010'));

    if (IOld == ILast)
        hp = 1;
    else 
        hp = 0;
    end
end