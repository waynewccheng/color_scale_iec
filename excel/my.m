mydata=[1 2; 3 4];
clf
figure(1)
hold on
for i = 1:2
    h=bar(mydata(:,i),'stacked');
% 
%     if mydata(i) < 0.2
%         set(h,'FaceColor','k');
%     elseif mydata(i) < 0.6
%         set(h,'FaceColor','b');
%     else
%         set(h,'FaceColor','r');
%     end
end
hold off
