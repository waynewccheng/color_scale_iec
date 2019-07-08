%% Color Belt
%  Q: What are the colors with the most chroma in the sRGB colro space?
%  A: color belt
%  6/26/2019
%  7/5/2019: rewrite classes

classdef ColorBelt < handle
    
    % need to inherit from handle superclass to pass the properties
    % https://www.mathworks.com/help/matlab/matlab_oop/static-data.html
    
    properties
        n
        rgb
        lab
        ColorSpace = 'srgb';
        WhitePoint = 'd65';
    end
    
    methods
        
        function plot3D (obj)
            hold on
            for k = 1:obj.n-1
                plot3(obj.lab(k:k+1,2),obj.lab(k:k+1,3),obj.lab(k:k+1,1),...
                    '-','Color',double(obj.rgb(k,:))/255)
            end
            xlabel('CIELAB a*')
            ylabel('CIELAB b*')
            zlabel('CIELAB L*')
            grid on
            axis([-150 150 -150 150 0 100])
        end
        
    end
    
    methods (Static, Access=public)
        
        function obj = ColorBelt (colorspace)
            
            if nargin == 1
                obj.ColorSpace = colorspace;
            end
            
            obj.rgb = ColorBelt.create_color_belt_rgb(obj);
            
            obj.lab = ColorBelt.create_color_belt_lab(obj);
            
        end
        
        function lab = create_color_belt_lab (obj)
            % convert from RGB to CIELAB
            
            lab = rgb2lab(obj.rgb,'ColorSpace',obj.ColorSpace,'WhitePoint',obj.WhitePoint);
            
        end
        
        function rgb = create_color_belt_rgb (obj)
            % construct the color belt
            
            obj.n = 256*6;
            
            rgb = uint8(zeros(obj.n,3));
            
            k = 0;
            
            % from red to yellow
            for i = 0:255
                k = k + 1;
                rgb(k,:) = [255 i 0];
            end
            
            % from yellow to green
            for i = 0:255
                k = k + 1;
                rgb(k,:) = [255-i 255 0];
            end
            
            % from green to cyan
            for i = 0:255
                k = k + 1;
                rgb(k,:) = [0 255 i];
            end
            
            % from cyan to blue
            for i = 0:255
                k = k + 1;
                rgb(k,:) = [0 255-i 255];
            end
            
            % from blue to magenta
            for i = 0:255
                k = k + 1;
                rgb(k,:) = [i 0 255];
            end
            
            % from magenta to red
            for i = 0:255
                k = k + 1;
                rgb(k,:) = [255 0 255-i];
            end
            
        end
        
        function loadData
            load(ColorBeltClass.filename,'obj')
            n = size(obj.de00,1);
            
            clf
            
            subplot(5,1,1)
            hold on
            for i = 1:n
                plot(i,obj.de00(i,1),'.','MarkerEdgeColor',obj.rgb1(i,:)/255)
            end
            set(gca,'XTick',[])
            ylabel('{\Delta}E')
            axis([1 n 0 0.5])
            title('{\Delta}E for each step')
            
            subplot(5,1,2)
            hold on
            for i = 1:n
                plot(i,obj.de00_accu(i,1),'.','MarkerEdgeColor',obj.rgb1(i,:)/255)
            end
            set(gca,'XTick',[])
            ylabel('Accumulated {\Delta}E from Red')
            axis([1 n 0 obj.dE_max])
            title(sprintf('Max %sE = %.0f','{\Delta}',obj.dE_max))
            
            subplot(5,1,3)
            hold on
            for i = 1:n
                plot(i,obj.de00_accu_seg(i,1),'.','MarkerEdgeColor',obj.rgb1(i,:)/255)
            end
            xticks([1:256:n])
            xticklabels({'red','yellow','green','cyan','blue','magenta'})
            ylabel('Accumulated {\Delta}E per Segment')
            title(sprintf('Max %sE = %.0f + %.0f + %.0f + %.0f + %.0f + %.0f','{\Delta}',...
                obj.de00_accu_seg(256*1-1,1),...
                obj.de00_accu_seg(256*1+1,1),...
                obj.de00_accu_seg(256*3-1,1),...
                obj.de00_accu_seg(256*3+1,1),...
                obj.de00_accu_seg(256*5-1,1),...
                obj.de00_accu_seg(256*5+1,1)))
            axis([1 n 0 160])
            
            subplot(5,1,4)
            hold on
            plot(obj.rgb1(:,1),'r')
            plot(obj.rgb1(:,2),'g')
            plot(obj.rgb1(:,3),'b')
            set(gca,'XTick',[])
            ylabel('R/G/B Values')
            axis([1 n 0 255])
            
            subplot(5,1,5)
            hold on
            for i = 1:obj.dE_max
                ji = obj.jindex(i,1);
                plot(i,ji,'.','MarkerEdgeColor',obj.rgb1(ji,:)/255)
            end
            %            plot(obj.jindex)
            xlabel('{\Delta}E')
            ylabel('Index')
            axis([1 obj.dE_max 0 n])
            
            saveas(gcf,'finding.png')
        end
        
    end
    
end




