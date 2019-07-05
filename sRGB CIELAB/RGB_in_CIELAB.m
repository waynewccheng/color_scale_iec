% Q: How to show the color gamut boundaries of sRGB in CIELAB?

%

function RGB_in_CIELAB (rgb_space, interval_step, wall_transparency)

% user parameters
% rgb_space = 'adobe-rgb-1998';
% interval_step = 5;                      % resolution of the mesh
% wall_transparency = 0.2;

% constants used by subroutines
interval = 0:interval_step:255;
interval_rev = 255:-interval_step:0;


% 3D plot

% fg = figure('Units','inches','Position',[2 2 8 8]);

hold on

if 1
    % draw the 6 walls
    plot_wall(prep_rgb_wall_rg);
    plot_wall(prep_rgb_wall_gb);
    plot_wall(prep_rgb_wall_rb);
    plot_wall(prep_rgb_wall_r);
    plot_wall(prep_rgb_wall_g);
    plot_wall(prep_rgb_wall_b);
end

if 1
    % add primary lines
    rgb_primary = prep_rgb_primary;
    lab_primary = rgb2lab(rgb_primary/255,'ColorSpace',rgb_space);
    show_as_lines(lab_primary,rgb_primary)
end

if 1
% add primary lines
rgb_chroma = prep_rgb_chroma;
lab_chroma = rgb2lab(rgb_chroma/255,'ColorSpace',rgb_space);
show_as_lines(lab_chroma,rgb_chroma)
end

if 1
% add custom data if needed
rgb_original = prep_rgb_sample_original;
lab_original = rgb2lab(rgb_original/255,'ColorSpace',rgb_space);
show_as_balls(lab_original,rgb_original)
end

if 0
% show the Z-axis
quiver3(0,0,0,0,0,100,0,'k')
end

grid on

% add labels
xlabel('CIELAB a*')
ylabel('CIELAB b*')
zlabel('CIELAB L*')

% change background to gray because white background cannot show 255,255,255
ax = gca;
ax.Color = [1 1 1]*0.85;


view(-25,15)

% turn on the rotation button
rotate3d on

return

%
% generate an animated GIF
%
    function create_animation
        
        % fix the camera view
        axis vis3d
        
        filename = 'color_scale_in_CIELAB.gif'
        
        for n = 1:360/10
            
            camorbit(10,0,'data',[0 0 1])
            
            % Capture the plot as an image
            frame = getframe(gcf);
            im = frame2im(frame);
            [imind,cm] = rgb2ind(im,256);
            
            % Write to the GIF File
            if n == 1
                imwrite(imind,cm,filename,'gif', 'Loopcount',inf);
            else
                imwrite(imind,cm,filename,'gif','WriteMode','append');
            end
            
        end
        
    end

%
% show one of the 6 walls
%
    function plot_wall (rgb)
        
        lab = rgb2lab(rgb/255,'ColorSpace',rgb_space);
        surf(lab(:,:,2),lab(:,:,3),lab(:,:,1),rgb/255,...
            'EdgeColor','none','FaceAlpha',wall_transparency)
    end


    function rgb = prep_rgb_wall_rg
        
        rgb = zeros(255/interval_step,255/interval_step,3);
        
        for i = interval
            k1 = i/interval_step + 1;
            for j = interval
                k2 = j/interval_step + 1;
                
                rgb(k1,k2,:) = [i j 0];
            end
        end
        
    end


    function rgb = prep_rgb_wall_gb
        
        rgb = zeros(255/interval_step,255/interval_step,3);
        
        for i = interval
            k1 = i/interval_step + 1;
            for j = interval
                k2 = j/interval_step + 1;
                
                rgb(k1,k2,:) = [0 i j];
            end
        end
        
    end

    function rgb = prep_rgb_wall_rb
        
        rgb = zeros(255/interval_step,255/interval_step,3);
        
        for i = interval
            k1 = i/interval_step + 1;
            for j = interval
                k2 = j/interval_step + 1;
                
                rgb(k1,k2,:) = [i 0 j];
            end
        end
        
    end


    function rgb = prep_rgb_wall_r
        
        rgb = zeros(255/interval_step,255/interval_step,3);
        
        for i = interval
            k1 = i/interval_step + 1;
            for j = interval
                k2 = j/interval_step + 1;
                
                rgb(k1,k2,:) = [255 i j];
            end
        end
        
    end

    function rgb = prep_rgb_wall_g
        
        rgb = zeros(255/interval_step,255/interval_step,3);
        
        for i = interval
            k1 = i/interval_step + 1;
            for j = interval
                k2 = j/interval_step + 1;
                
                rgb(k1,k2,:) = [i 255 j];
            end
        end
        
    end

    function rgb = prep_rgb_wall_b
        
        rgb = zeros(255/interval_step,255/interval_step,3);
        
        for i = interval
            k1 = i/interval_step + 1;
            for j = interval
                k2 = j/interval_step + 1;
                
                rgb(k1,k2,:) = [i j 255];
            end
        end
        
    end

    function rgb = prep_rgb_primary
        
        rgb = zeros(255/15,3);
        k = 0;
        
        if 1
            % gray
            for i = interval
                k = k + 1;
                rgb(k,:) = [i i i];
            end
        end
        
        if 1
            % red
            for i = interval
                k = k + 1;
                rgb(k,:) = [i 0 0];
            end
            for i = interval
                k = k + 1;
                rgb(k,:) = [255 i i];
            end
            
            % green
            for i = interval
                k = k + 1;
                rgb(k,:) = [0 i 0];
            end
            for i = interval
                k = k + 1;
                rgb(k,:) = [i 255 i];
            end
            
            % blue
            for i = interval
                k = k + 1;
                rgb(k,:) = [0 0 i];
            end
            for i = interval
                k = k + 1;
                rgb(k,:) = [i i 255];
            end
        end
        
        if 1
            % yellow
            for i = interval
                k = k + 1;
                rgb(k,:) = [i i 0];
            end
            for i = interval
                k = k + 1;
                rgb(k,:) = [255 255 i];
            end
            
            % cyan
            for i = interval
                k = k + 1;
                rgb(k,:) = [0 i i];
            end
            for i = interval
                k = k + 1;
                rgb(k,:) = [i 255 255];
            end
            
            % magenta
            for i = interval
                k = k + 1;
                rgb(k,:) = [i 0 i];
            end
            for i = interval
                k = k + 1;
                rgb(k,:) = [255 i 255];
            end
            
        end
        
    end

%
% colors with the largest chroma
%
    function rgb = prep_rgb_chroma
        
        rgb = zeros(255/15,3);
        k = 0;
        
        for i = interval
            k = k + 1;
            rgb(k,:) = [255 i 0];
        end
        
        for i = interval_rev
            k = k + 1;
            rgb(k,:) = [i 255 0];
        end
        
        for i = interval
            k = k + 1;
            rgb(k,:) = [0 255 i];
        end
        
        for i = interval_rev
            k = k + 1;
            rgb(k,:) = [0 i 255];
        end
        
        for i = interval
            k = k + 1;
            rgb(k,:) = [i 0 255];
        end
        
        for i = interval_rev
            k = k + 1;
            rgb(k,:) = [255 0 i];
        end
        
    end
end


function rgb = prep_rgb_sample_original

rgb_ass = [0 1 2 3 4 5];
rgb = zeros(6,3);

for i = 1:6
    x = rgb_ass(i);
    rgb(i,:) = rgb_belt(x)*255; 
end

% rgb = [0 0 0;
%     096 000 080;
%     096 096 176;
%     080 192 080;
%     224 224 080;
%     208 144 000;
%     255 0 0;
%     255 255 255
%     ];
end


function show_as_balls (lab,rgb)
% show balls
for k = 1:size(lab,1)
    
    plot3(lab(k,2),lab(k,3),lab(k,1),'o',...
        'MarkerFaceColor',rgb(k,:)/255,...
        'MarkerEdgeColor',rgb(k,:)/255,...
        'MarkerSize',15)
    
    if 1
        % add text labels
        step = k-1;
        txt = sprintf('#%d',step);
        text(lab(k,2)+10,lab(k,3),lab(k,1),txt)
    end
    
end

end

function show_as_lines (lab,rgb)
% show lines

for k = 1:size(lab,1)-1
    
    plot3(lab(k:k+1,2),lab(k:k+1,3),lab(k:k+1,1),'-',...
        'Color',rgb(k,:)/255)
    
end

end

