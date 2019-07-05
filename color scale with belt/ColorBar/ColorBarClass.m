%   Analyzing the color difference in a Matlab colormap
%   Q: Which colormap in Matlab is the best?
%   A: Plot the (1) color difference for each step, (2) the accumulated
%   color difference, (3) the RGB components of the colormap, and (4) the
%   color step (index) should be used if even color difference is desired

classdef ColorBarClass < handle
    
    % need to inherit from handle superclass to pass the properties
    % https://www.mathworks.com/help/matlab/matlab_oop/static-data.html
    
    properties (Constant)
        step = 1;
        filename = 'color_bar_data.mat';
    end
    
    properties
        rgb1
        rgb2
        de00
        de00_accu
        jindex
    end
    
    methods (Static, Access=public)
        

        function obj = ColorBarClass (colorbarname)
            
            if  nargin < 1
                colorbarname = 'parula';
            end
            
            % create the color belt
            n = 256;
            obj.rgb1 = zeros(n,3);
            obj.rgb1 = eval(sprintf('%s(n)',colorbarname));
            
            % shift rgb1 to obtain rgb2
            obj.rgb2 = zeros(n,3);
            obj.rgb2(1:end-1,:) = obj.rgb1(2:end,:);
            %            obj.rgb2(end,:) = obj.rgb1(1,:);
            
            % calcualte dE
            obj.de00 = zeros(n-1,1);
            for i = 1:n-1
                obj.de00(i,1) = ColorBarClass.rgb2deltae00(obj.rgb1(i,:),obj.rgb2(i,:));
            end
            
            % calcualte accumulated dE
            obj.de00_accu = zeros(n-1,1);
            for i = 1:n-1
                obj.de00_accu(i,1) = sum(obj.de00(1:i,1));
            end
            
            dE_max = floor(obj.de00_accu(end,1));

            % dE to index
            obj.jindex = zeros(dE_max,1);
            [t2,ia,ic] = unique(obj.de00_accu);
            for de = 1:dE_max
                j = interp1(t2,ia,de,'linear','extrap');
                j2 = round(j);
                j2 = max(j2,1);
                j2 = min(j2,n-1);
                obj.jindex(de) = j2;
            end
            
            % plot
            
            clf
            
            subplot(4,1,1)
            hold on
            for i = 1:n-1
                plot(i,obj.de00(i,1),'.','MarkerEdgeColor',obj.rgb1(i,:))
            end
            set(gca,'XTick',[])
            ylabel('{\Delta}E')
            axis([1 n-1 0 max(obj.de00(:,1))])
            title('{\Delta}E for each step')
            
            subplot(4,1,2)
            hold on
            for i = 1:n-1
                plot(i,obj.de00_accu(i,1),'.','MarkerEdgeColor',obj.rgb1(i,:))
            end
            set(gca,'XTick',[])
            ylabel('Accumulated {\Delta}E')
            axis([1 n-1 0 max(obj.de00_accu(:,1))])
            title(sprintf('Max %sE = %.0f','{\Delta}',obj.de00_accu(end,1)))
            
            subplot(4,1,3)
            hold on
            plot(obj.rgb1(:,1),'r')
            plot(obj.rgb1(:,2),'g')
            plot(obj.rgb1(:,3),'b')
            set(gca,'XTick',[])
            ylabel('R/G/B Values')
            axis([1 n-1 0 1])
            title(colorbarname)
            
            subplot(4,1,4)
            hold on
            for i = 1:dE_max
                ji = obj.jindex(i,1);
                plot(i,ji,'.','MarkerEdgeColor',obj.rgb1(ji,:))
            end
%            plot(obj.jindex)            
            xlabel('{\Delta}E')
            ylabel('Index')
            
            saveas(gcf,sprintf('%s.png',colorbarname))
        end

    end
    
    methods (Static, Access=protected)
        
        function dE00 = lab2deltae00 (lab1, lab2)
            
            dEab = sum((lab2-lab1) .^ 2) .^ 0.5;
            
            %-------------------------------------------------------------------
            
            Lstar1 = lab1(1);
            astar1 = lab1(2);
            bstar1 = lab1(3);
            Cstar1 = ((astar1 .^ 2) + (bstar1 .^ 2)) .^ 0.5;
            
            Lstar2 = lab2(1);
            astar2 = lab2(2);
            bstar2 = lab2(3);
            Cstar2 = ((astar2 .^ 2) + (bstar2 .^ 2)) .^ 0.5;
            
            dL = Lstar1 - Lstar2;
            dCab = Cstar1 - Cstar2;
            dHab = (dEab .^ 2 - dL .^ 2 - dCab .^ 2) .^ 0.5;
            Lbar = (Lstar1+Lstar2)/2;
            
            dastar = astar1 - astar2;
            dbstar = bstar1 - bstar2;
            
            if 1
                kL = 1;
                K1 = 0.045;
                K2 = 0.015;
            else
                kL = 2;
                K1 = 0.048;
                K2 = 0.014;
            end
            
            SL = 1;
            SC = 1 + K1*Cstar1;
            SH = 1 + K2*Cstar1;
            
            kL = 1;
            kC = 1;
            kH = 1;
            
            dE94 = ((dL/kL/SL).^2 + (dCab/kC/SC).^2 + (dHab/kH/SH).^2) .^ 0.5;
            
            %     if 0
            %         kL = 1;
            %         K1 = 0.045;
            %         K2 = 0.015;
            %     else
            %         kL = 2;
            %         K1 = 0.048;
            %         K2 = 0.014;
            %     end
            %
            %     SL = 1;
            %     SC = 1 + K1*Cstar1;
            %     SH = 1 + K2*Cstar1;
            
            %    dE94 = ((dL/kL/SL).^2 + (dCab/kC/SC).^2 + (dHab/kH/SH).^2) .^ 0.5
            
            
            %-------------------------------------------------------------------
            dLprime = Lstar1 - Lstar2;
            Lbar = (Lstar1+Lstar2)/2;
            Cbar = (Cstar1+Cstar2)/2;
            aprime1 = astar1 + (astar1/2) * (1 - (Cbar.^7/(Cbar.^7+25.^7)).^0.5);
            aprime2 = astar2 + (astar2/2) * (1 - (Cbar.^7/(Cbar.^7+25.^7)).^0.5);
            
            Cprime1 = (aprime1 .^ 2 + bstar1 .^ 2) .^ 0.5;
            Cprime2 = (aprime2 .^ 2 + bstar2 .^ 2) .^ 0.5;
            Cbarprime = (Cprime1 + Cprime2) / 2;
            dCprime = Cprime2 - Cprime1;
            
            hprime1 = mod(atan2(bstar1,aprime1)*180/pi + 360, 360);
            hprime2 = mod(atan2(bstar2,aprime2)*180/pi + 360, 360);
            
            if (abs(hprime1 - hprime2) <= 180)
                dhprime = hprime2 - hprime1;
            else if hprime2 <= hprime1
                    dhprime = hprime2 - hprime1 + 360;
                else
                    dhprime = hprime2 - hprime1 - 360;
                end
            end
            
            dHprime = 2 * (Cprime1 * Cprime2) .^ 0.5 * sin(dhprime*pi/180/2);
            
            if abs(hprime1 - hprime2) > 180
                Hbarprime = (hprime1 + hprime2 + 360) / 2;
            else
                Hbarprime = (hprime1 + hprime2) / 2;
            end
            
            T = 1 - 0.17*cos((Hbarprime - 30)*pi/180) + ...
                0.24 * cos(2*Hbarprime * pi/180) + ...
                0.32 * cos ((3*Hbarprime + 6 ) * pi/180) -...
                0.20 * cos((4*Hbarprime - 63) * pi/180);
            
            SL = 1 + (0.015 * (Lbar - 50) .^ 2) / ((20+(Lbar - 50).^2).^0.5);
            
            SC = 1 + 0.045 * Cbarprime;
            
            SH = 1 + 0.015 * Cbarprime * T;
            
            RT = -2 * (Cbarprime .^ 7 / (Cbarprime.^7 + 25.^7)).^0.5 * sin((60 * exp(-((Hbarprime - 275)/25).^2))*pi/180);
            
            dE00 = ((dLprime/kL/SL).^2 + (dCprime/kC/SC).^2 + (dHprime/kH/SH).^2 + (RT*dCprime/kC/SC*dHprime/kH/SH)) .^ 0.5;
        end
        
        
        function dE00 = rgb2deltae00 (rgb1, rgb2)
            lab1 = rgb2lab(rgb1,'ColorSpace','sRGB','WhitePoint','d65');
            lab2 = rgb2lab(rgb2,'ColorSpace','sRGB','WhitePoint','d65');
            
            dE00 = ColorBarClass.lab2deltae00(lab1,lab2);
        end
        
    end
    
end




