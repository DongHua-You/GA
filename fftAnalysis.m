
function [ fft_info ] = fftAnalysis( srcSignal, period, drawFlag)

% parameter
L = length(srcSignal);
% f = 100*(0:L/2)/L;
f = (1/period)*(0:L/2)/L;
f_srcSignal = fft(srcSignal);

% algorithm
%(1) reference from MATLAB fft function
p2 = abs(f_srcSignal/L);
p1 = p2(1:L/2+1);
p1(2:end-1) = 2*p1(2:end-1);

% show
if(drawFlag)
    figure, plot(f,p1);
end

fft_info = table(f', p1, 'VariableNames', {'frequency', 'power'});

end