% Q: how to optimize the color scale proposed by IEC MT41
% uncompleted!

function color_scale_optimize

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

% convert to CIELAB
rgb_space = 'srgb'
lab = rgb2lab(c/255,'ColorSpace',rgb_space);

% improve lightness
lab_new = lab;
for i = 0:7
    l_new = 100/7*i;
    lab_new(i+1,1) = l_new;
end

rgb2 = lab2rgb(lab_new)*255;


%
rgblab = [c lab];
xlswrite('rgblab.xlsx',rgblab)



% xlswrite('dE.xlsx',dE_allpair)


% 3D plot
figure('Units','inches','Position',[2 2 8 8])

subplot(2,2,1)

plot_color_scale(lab)

view(-25,15)


%%
%figure('Units','inches','Position',[2 2 4 4])

subplot(2,2,3)

plot_color_scale(lab)

view(0,90)

%%
%figure('Units','inches','Position',[2 2 4 4])

subplot(2,2,2)

plot_color_scale(lab)
view(0,0)


subplot(2,2,4)

plot_color_scale(lab_new)
view(-25,15)

%% 3D plot
    function plot_color_scale (lab)
        
        rgb = lab2rgb(lab);
        rgb = max(rgb,0);
        rgb = min(rgb,1);
        rgb = (double(rgb)*255);
        
        hold on
        
        for k = 1:8
            plot3(lab(k,2),lab(k,3),lab(k,1),'o',...
                'MarkerFaceColor',rgb(k,:)/255,...
                'MarkerEdgeColor',[0 0 0],...
                'MarkerSize',15)
            
            step = k-1;
            txt = sprintf('#%d',step);
            text(lab(k,2)+10,lab(k,3),lab(k,1),txt)
        end
        
        plot3(lab(:,2),lab(:,3),lab(:,1),':k')
        
        grid on
        axis([-100 100 -100 100 0 100])
        axis square
        xlabel('CIELAB a*')
        ylabel('CIELAB b*')
        zlabel('CIELAB L*')
        
        %saveas(gcf,'t3.png')
    end

%% dE
    function dE_allpair = dE (lab)
        dE_allpair = zeros(8,8);
        for k = 1:8
            for j = 1:8
                lab1 = lab(k,:);
                lab2 = lab(j,:);
                dE = sum((lab1-lab2).^2).^0.5;
                dE_allpair(k,j) = dE;
            end
        end
    end
end

