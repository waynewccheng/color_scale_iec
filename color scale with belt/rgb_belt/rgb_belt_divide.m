% divide the RGB belt into segments of dE
function scale = rgb_belt_divide (dE, x_from)



scale = x_from + [0 1 2 3 4 5 6];

for i = 2:7
    scale(i) = search_rgb_belt(scale(i-1),dE);
end

return

    function r = search_rgb_belt (x_from, distance)
        % resolution for searching
        resolution = 0.01;
        
        % convert x to rgb
        rgb_from = rgb_belt(x_from);
        
        % convert rgb to lab
        lab_from = rgb2lab(rgb_from,'ColorSpace','sRGB','WhitePoint','d65');
        
        % linear search
        error_min = 1000;
        candidate = -1;
        % prevent from warpping 
        for x = x_from:resolution:x_from+3
            x_round = mod(x,6);
            rgb = rgb_belt(x_round);
            lab = rgb2lab(rgb,'ColorSpace','sRGB','WhitePoint','d65');
            dE_x = deltae00(lab_from,lab);
            error_x = abs(dE_x - distance);
            if  error_x < error_min
                candidate = x_round;
                error_min = error_x;
            end
        end
        
        r = candidate
        return
    end
end
