clear all;
close all;

period = 0.01;
drawFlag = 0;

dirLoc = '/media/donghua/D/Gait_Data/data_v2/data';
fileName = 'mhai_normal_1061102.csv';

%% Read raw data and tranfer to Table format
T = readCsv2Table( dirLoc, fileName);
time_interval = diff(T.time); % calculate the time interval between two signals

%% Find the HS from the fearture of x-axis(vertical acc.)
HS = findHS(T.acc_x,1);

%% Use HHT to transform the time-domain signals to frequency-time domain signals. And analysis it.
for i=1:size(HS.continue_locs,2)
    % SGI : which means stable gait interval
    % Interval of SGI
    interval = HS.continue_locs{i}(1):HS.continue_locs{i}(end);
    
    % Time series :
    xTimeSeries{i,1} = table(T.time(interval), T.acc_x(interval), 'VariableNames', {'Time','Acc'});
    yTimeSeries{i,1} = table(T.time(interval), T.acc_y(interval), 'VariableNames', {'Time','Acc'});
    zTimeSeries{i,1} = table(T.time(interval), T.acc_z(interval), 'VariableNames', {'Time','Acc'});
    
    % Trans series :  
    xHHT{i,1} = hht(T.time(interval), T.acc_x(interval), period, 0);
    yHHT{i,1} = hht(T.time(interval), T.acc_y(interval), period, 0);
    zHHT{i,1} = hht(T.time(interval), T.acc_z(interval), period, 0);
end
clear interval

% assign value to table form
HHT.x = table(xTimeSeries, xHHT, 'VariableNames', {'TimeSeries','TransSeries'}); 
HHT.y = table(yTimeSeries, yHHT, 'VariableNames', {'TimeSeries','TransSeries'}); 
HHT.z = table(zTimeSeries, zHHT, 'VariableNames', {'TimeSeries','TransSeries'}); 
clear xTimeSeries yTimeSeries zTimeSeries
clear xHHT yHHT zHHT

%% 
for i=1:size(HS.continue_locs,2)
    % interval of SGI
    interval = HS.continue_locs{i}(1):HS.continue_locs{i}(end);

    % Time series :
    xTimeSeries{i,1} = table(T.time(interval), T.acc_x(interval), 'VariableNames', {'Time','Acc'});
    yTimeSeries{i,1} = table(T.time(interval), T.acc_y(interval), 'VariableNames', {'Time','Acc'});
    zTimeSeries{i,1} = table(T.time(interval), T.acc_z(interval), 'VariableNames', {'Time','Acc'});
    
    % Transform series :
    xFFT{i,1} = fftAnalysis(T.acc_x(interval), period, 0);
    yFFT{i,1} = fftAnalysis(T.acc_y(interval), period, 0);
    zFFT{i,1} = fftAnalysis(T.acc_z(interval), period, 0);
end

% assign value to table form
FFT.x = table(xTimeSeries, xFFT, 'VariableNames', {'TimeSeries','TransSeries'}); 
FFT.y = table(yTimeSeries, yFFT, 'VariableNames', {'TimeSeries','TransSeries'}); 
FFT.z = table(zTimeSeries, zFFT, 'VariableNames', {'TimeSeries','TransSeries'}); 
clear xTimeSeries yTimeSeries zTimeSeries
clear xFFT yFFT zFFT

%% draw image
if (drawFlag)
    
%    figure('Name','acc_data');
%    hold on
%    xlabel('time');
%    ylabel('magnitude');
%    subplot(311);
%    plot(T.time, T.acc_x, 'DisplayName', 'acc\_x');
%    legend('show');
%    subplot(312);
%    plot(T.time, T.acc_y, 'DisplayName', 'acc\_y');
%    legend('show');
%    subplot(313);
%    plot(T.time, T.acc_z, 'DisplayName', 'acc\_z');
%    legend('show');
   
end