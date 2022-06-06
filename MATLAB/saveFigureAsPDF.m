function saveFigureAsPDF(fig, path)
set(fig, 'PaperPosition', [-3.25 0 40 20])
set(fig, 'PaperSize', [33.4 20]);
% set(fig, 'PaperPosition', [-1.25 0 40 20])
% set(fig, 'PaperSize', [37.4 23]);
saveas(fig, path, 'pdf')
end