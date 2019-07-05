% Q: visualize the color scale proposed by IEC MT41
% 

% proposed RGB
c = [0 0 0;
    096 000 080;
    096 096 176;
    080 192 080;
    224 224 080;
    208 144 000;
    255 0 0;
    255 255 255
    ];

c = [0 0 0;
    000 255 255;
    000 255 150;
    135 255 0;
    255 240 0;
    255 150 0;
    255 0 0;
    255 255 255
    ];

c = [0 0 0;
    0 60 255;
    0 165 255;
    0 255 255;
    75 255 0;
    255 210 0;
    255 0 0;
    255 255 255
    ];
% 
% c = [0 0 0;
%     255 0 165;
%     0 30 255;
%     0 165 255;
%     0 255 195;
%     255 225 0;
%     255 0 0;
%     255 255 255
%     ];

% convert to CIELAB
lab = rgb2lab(c/255);

% 
rgblab = [c lab];
xlswrite('rgblab.xlsx',rgblab)

% dE
dE_allpair = zeros(8,8);
for i = 1:8
for j = 1:8
    lab1 = lab(i,:);
    lab2 = lab(j,:);
    dE = sum((lab1-lab2).^2).^0.5;
    dE_allpair(i,j) = dE;
end
end

xlswrite('dE.xlsx',dE_allpair)


% 3D plot
figure('Units','inches','Position',[2 2 4 4])

hold on
for i = 1:8
    plot3(lab(i,2),lab(i,3),lab(i,1),'o',...
        'MarkerFaceColor',c(i,:)/255,...
        'MarkerEdgeColor',[0 0 0],...
        'MarkerSize',15)
    
    step = i-1;
    txt = sprintf('#%d',step);
    text(lab(i,2)+10,lab(i,3),lab(i,1),txt)
end

plot3(lab(:,2),lab(:,3),lab(:,1),':k')

grid on
%axis([-100 100 -100 100 0 100])
axis square
xlabel('CIELAB a*')
ylabel('CIELAB b*')
zlabel('CIELAB L*')

view(-25,15)

saveas(gcf,'t1.png')

%%
figure('Units','inches','Position',[2 2 4 4])

%subplot(2,2,3)

hold on
for i = 1:8
    plot3(lab(i,2),lab(i,3),lab(i,1),'o',...
        'MarkerFaceColor',c(i,:)/255,...
        'MarkerEdgeColor',[0 0 0],...
        'MarkerSize',15)
    
    step = i-1;
    txt = sprintf('#%d',step);
    text(lab(i,2)+10,lab(i,3),lab(i,1),txt)
end

plot3(lab(2:7,2),lab(2:7,3),lab(2:7,1),':k')

grid on
axis([-100 100 -100 100 0 100])
axis square
xlabel('CIELAB a*')
ylabel('CIELAB b*')
zlabel('CIELAB L*')

view(0,90)
saveas(gcf,'t2.png')

%%
figure('Units','inches','Position',[2 2 4 4])

%subplot(2,2,2)
hold on
for i = 1:8
    plot3(lab(i,2),lab(i,3),lab(i,1),'o',...
        'MarkerFaceColor',c(i,:)/255,...
        'MarkerEdgeColor',[0 0 0],...
        'MarkerSize',15)
    
    step = i-1;
    txt = sprintf('#%d',step);
    text(lab(i,2)+10,lab(i,3),lab(i,1),txt)
end

plot3(lab(:,2),lab(:,3),lab(:,1),':k')

grid on
axis([-100 100 -100 100 0 100])
axis square
xlabel('CIELAB a*')
ylabel('CIELAB b*')
zlabel('CIELAB L*')

view(0,0)
saveas(gcf,'t3.png')



