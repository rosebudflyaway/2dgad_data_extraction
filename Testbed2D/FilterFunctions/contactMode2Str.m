function str = contactMode2Str(cm)

if cm == 8 || cm < 0
    str = 'Invalid';
else
    a1 = floor(cm/4);
    a2 = floor((cm - a1*4)/2);
    a3 = cm - a1*4 - a2*2;
    str = ['[' num2str(a1) ' ' num2str(a2) ' ' num2str(a3) ']'];
end

end