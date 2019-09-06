clf

mybar(1,2,6,[0 .5 .5])
axis([0 10 0 10])

function mybar (x, y1, y2, color)
    barwidth = 1;
    rectangle('Position',[x y1 x+barwidth y2],'FaceColor',color)
end
