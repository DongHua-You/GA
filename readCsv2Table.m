%{
breif: 

The smart phone app is :
https://play.google.com/store/apps/details?id=de.lorenz_fenster.sensorstreamgps&hl=zh_TW

the file format is :
time sensor_id acc_x acc_y acc_z ... (reference from upon website)

%}
function Table = readCsv2Table(DirLoc, fileName)

% parameter

% read csv file
fileLoc = sprintf('%s/%s', DirLoc, fileName);
display(fileLoc);
% rawData = csvread(fileLoc);
rawData = readtable(fileLoc);

% time = rawData(:,1);
% acc_x = rawData(:,3);
% acc_y = rawData(:,4);
% acc_z = rawData(:,5);
% av_x = rawData(:,7);
% av_y = rawData(:,8);
% av_z = rawData(:,9);
%  
% Table = table(time, acc_x, acc_y, acc_z, av_x, av_y, av_z);

Table = table(rawData.time, rawData.x, rawData.y, rawData.z, rawData.gforce, ...
                'VariableNames', {'time','acc_x','acc_y','acc_z','g_force'});

end