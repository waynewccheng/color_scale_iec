%% Color Belt
%  Q: how many dE on the color belt?
%  6/26/2019

classdef ColorBeltDivideClass < handle
    
    % need to inherit from handle superclass to pass the properties
    % https://www.mathworks.com/help/matlab/matlab_oop/static-data.html
    
    properties (Constant)
        step = 1;                            % calculate dE between rgb and rgb+step
        filename = 'color_belt_data.mat';    % save the result in a file
    end
    
    properties
        rgb1                                 % the color belt
        jindex
        rgb_final
    end
    
    methods 
        
        function obj = ColorBeltDivideClass (target_dE)
            
            % create the color belt
            obj.rgb1 = ColorBeltDivideClass.color_belt_create;
            
            % calcualte dE
            obj.jindex(1) = 1;
            for j = 2:6
                k = obj.search_dE(obj.jindex(j-1),target_dE)
                obj.jindex(j) = k;
            end
            
            obj.jindex
            for i = 1:6
                obj.rgb_final(i,:) = obj.rgb1(obj.jindex(i),:);
            end
            
            save('ColorBeltDivideData','obj')
        end

        function r = search_dE (obj, j, dE)
            n = 256*6;
            i = j+1;
            error_min = 1000;
            while i<=j+n/2
                i2 = i;
                if i2 > n
                    i2 = i2 - n;
                end
                dE_i = ColorBeltDivideClass.rgb2deltae00(obj.rgb1(j,:),obj.rgb1(i2,:));
                error_i = abs(dE_i - dE);
                if error_i < error_min
                    error_min = error_i;
                    candidate = i;
                    i = i + 1;
                else
                    i = i + 1;
                    % break immediately when the error goes up
%                    break;
                end
            end
            r = candidate;
            if r > n
                r = r - n;
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
            axis([1 n 0 1.2])
            title('{\Delta}E for each step')
            
            subplot(5,1,2)
            hold on
            for i = 1:n
                plot(i,obj.de00_accu(i,1),'.','MarkerEdgeColor',obj.rgb1(i,:)/255)
            end
            set(gca,'XTick',[])
            ylabel('Accumulated {\Delta}E from Red')
            axis([1 n 0 505])
            title(sprintf('Max %sE = %.0f','{\Delta}',obj.de00_accu(end,1)))

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

            subplot(5,1,5)
            hold on
            for i = 1:500
                ji = obj.jindex(i,1);
                plot(i,ji,'.','MarkerEdgeColor',obj.rgb1(ji,:)/255)
            end
%            plot(obj.jindex)            
            xlabel('{\Delta}E')
            ylabel('Index')
            
            subplot(5,1,4)
            hold on
            plot(obj.rgb1(:,1),'r')
            plot(obj.rgb1(:,2),'g')
            plot(obj.rgb1(:,3),'b')
            set(gca,'XTick',[])
            ylabel('R/G/B Values')
            axis([1 n 0 255])
            
            saveas(gcf,'finding.png')
        end
        
        function plotResult (obj)
            
            clf
            subplot(1,2,1)
            hold on
            plot(obj.x_range,obj.de_array(1,obj.x_range+1),'r.')
            plot(obj.x_range,obj.de_array(2,obj.x_range+1),'y.')
            plot(obj.x_range,obj.de_array(3,obj.x_range+1),'g.')
            plot(obj.x_range,obj.de_array(4,obj.x_range+1),'c.')
            plot(obj.x_range,obj.de_array(5,obj.x_range+1),'b.')
            plot(obj.x_range,obj.de_array(6,obj.x_range+1),'m.')
            xlabel('DDL')
            ylabel('{\Delta}E')
            axis([0 255 0 1.2])
            
            subplot(1,2,2)
            hold on
            plot(obj.x_range,obj.de_accu(1,obj.x_range+1),'r.')
            plot(obj.x_range,obj.de_accu(2,obj.x_range+1),'y.')
            plot(obj.x_range,obj.de_accu(3,obj.x_range+1),'g.')
            plot(obj.x_range,obj.de_accu(4,obj.x_range+1),'c.')
            plot(obj.x_range,obj.de_accu(5,obj.x_range+1),'b.')
            plot(obj.x_range,obj.de_accu(6,obj.x_range+1),'m.')
            xlabel('DDL')
            ylabel('Accumulated {\Delta}E')
            
        end
    end
    
    methods (Static, Access=protected)
        
        %% Color belt creator
        function rgb = color_belt_create
            
            % construct the color belt
            rgb = zeros(256*6,3);
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
        
        %% dE2000: from CIELAB
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
        
        %% dE2000: from sRGB
        function dE00 = rgb2deltae00 (rgb1, rgb2)
            lab1 = rgb2lab(rgb1/255,'ColorSpace','sRGB','WhitePoint','d65');
            lab2 = rgb2lab(rgb2/255,'ColorSpace','sRGB','WhitePoint','d65');
            
            dE00 = ColorBeltDivideClass.lab2deltae00(lab1,lab2);
        end
        
    end
    
end




