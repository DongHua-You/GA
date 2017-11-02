%{
brief: hilbert haung transform 

input:
(1) tData: time data
(2) axisData: (VT/AP/LT) data
(3) Ts: period
(4) drawFlag: draw or not
        
output: 


%}

function [ hht_info ] = hht(tData,axisData,Ts,drawFlag)

%---paramter
N = length(axisData);
%t = linspace(0,(N-2)*Ts,N-1);
t = linspace(0+tData(1),(N-2)*Ts+tData(1),N-1);

%---algorithm--- 
%(1) emd (empirical mode decomposition)
imf = emd(axisData);
    
%(2) 
for k = 1:length(imf)
   b{k} = sum(imf{k}.*imf{k});
   th{k} = angle(hilbert(imf{k}));
   amplitude{k} = abs(hilbert(imf{k}));
   d{k} = diff(th{k})/Ts/(2*pi);
end

%---plot
if(drawFlag)
    for i = 1:1
        figure
        plot(t,d{i},'.');
        set(gca,'XLim', [t(1),t(end)], 'YLim', [0 1/2/Ts]);
    end
end

%---assigment
% hht_info.energy = b;
% hht_info.time = t;
% hht_info.signal = axisData;
% hht_info.phase = th;
% hht_info.frequency = d;
% hht_info.amplitude = amplitude;

signal =axisData;
frequency = d;
energy = b';
time = t;
phase = th';
amplitude = amplitude';

hht_info = table(imf, energy, phase, amplitude);


