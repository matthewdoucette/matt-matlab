%Data Import Process

folder = 'Data';
% Example: folder = 'C:\Temp\Data';

sheetname = 'ISONE CA';

if strcmp(sheetname, 'ISONE CA')
    NEData = dataset('XLSFile', sprintf('%s\\2004_smd_hourly.xls',folder,yr), 'Sheet', 'NEPOOL');
else
    NEData = dataset('XLSFile', sprintf('%s\\2004_smd_hourly.xls',folder,yr), 'Sheet', sheetname);
end
NEData.Year = 2004 * ones(length(NEData),1);
   
for yr = 2005:2009
	x = dataset('XLSFile', sprintf('%s\\%d_smd_hourly.xls',folder,yr), 'Sheet', sheetname);
    x.Year = yr*ones(length(x),1);
    NEData = [NEData; x];
end

NEData.NumDate = datenum(NEData.Date, 'mm/dd/yyyy') + (NEData.Hour-1)/24;

save([folder '\' genvarname(sheetname) '_Data.mat'], 'NEData');