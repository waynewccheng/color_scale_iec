classdef ColorScale
    %Class for colorscale
    %   for IEC
    
    properties
        rgb
        lab
        lch
        lab_diff
        lch_diff
        n
    end
    
    methods
        
        function obj = ColorScale (data)
            % data is a k*3 colormap like
            %
            %     US = [
            %         0 0 0; % black
            %         128   0 128; % purple
            %         0 0 255; % blue
            %         0 128   0; % green
            %         255 255   0; % yellow
            %         255 165   0; % orange
            %         255 0 0; % red
            %         255 0 0; % red
            %         ];
            %
            
            % should have some check here
            
            obj.n = size(data,1);
            obj.rgb = data;
            
            % to CIELAB
            obj.lab = rgb2lab(obj.rgb/255,'ColorSpace','srgb','WhitePoint','d65');
            
            % to CIELCH
            obj.lch = obj.lab;
            for i = 1:obj.n
                a = obj.lab(i,2);              % a*
                b = obj.lab(i,3);              % b*
                rad = atan2(b,a);              % angle = hue
                chrm = (a.^2 + b.^2) .^ 0.5;   % radius = chroma
                obj.lch(i,3) = rad * 180 / pi;     % from radian to degree
                obj.lch(i,2) = chrm;               % chroma
            end
            
            % CIELAB diff
            v1 = obj.lab(1:obj.n,:);
            v2 = obj.lab([2:obj.n 1],:);
            obj.lab_diff = abs(v1 - v2);
            
            % CIELCH diff
            % be careful with hue
            v1 = obj.lch(1:obj.n,:);
            v2 = obj.lch([2:obj.n 1],:);
            obj.lch_diff = abs(v1 - v2);

        end
        
        function display (obj)
            sRGB = obj.rgb
            
            CIELAB = obj.lab
            
            CIELCH = obj.lch
            
            obj.lab_diff

            obj.lch_diff
        end
    end
    
end

