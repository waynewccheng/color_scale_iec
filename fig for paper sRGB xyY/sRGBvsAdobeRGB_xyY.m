%% Color gamut comparison between sRGB and AdobeRGB 
%  Show the color gamuts of both sRGB and AdobeRGB in the CIE xyY color space
%  using RGB_in_xyY()
%  for paper derived from data shared with DICOM WG26
%  to demonstrate limited color gamut of sRGB for H&E stained slides

step = 5;
fg = figure('Units','inches','Position',[2 2 8 8]);
hold on
RGB_in_xyY('srgb',step,1)
RGB_in_xyY('adobe-rgb-1998',step,0.1)
view(-50,23)
saveas(gcf,'xyY.png')
