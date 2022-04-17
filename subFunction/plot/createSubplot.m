function ax = createSubplot(numRow,numCol)
    ax(numRow,numCol) = axes;
    for i = 1:numRow*numCol
        row = idivide(i-1,int16(numCol))+1;
        col = rem(i-1,int16(numCol))+1;
        ax(row,col) = subplot(numRow,numCol,i);
    end
end