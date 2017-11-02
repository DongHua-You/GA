%{
brief: Using xData(vertical acc.) to find heelstrike moments.







%}
function HS = findHS(xData, drawFlag)

%% parameter
xData_1 = [];
xData_2 = [];
xData_3 = [];
sgn = [];
sgn_1 = [];
sample = 1:length(xData);
L = length(xData);

%% struct template
HS.candidate_locs = [];
HS.discrete_locs = [];
HS.continue_locs = [];

%% algorithm
% (1) Remove the DC signal and normalize by minmum value of xData to
% "xData_1". (Signal will up side down)
% xData_1 = (xData-mean(xData))./min(xData);
xData_1 = (xData-mean(xData));
xData_1 = xData_1./abs(min(xData_1));

% (2) The gaol is the negative number. So it filter the positive number.
for i=1:L
    if (xData_1(i)<0)
        xData_2(i) = xData_1(i);
    else
        xData_2(i) = 0;
    end
end

% (3) Normalize signal "xData_2" to "xData_3"
xData_3 = xData_2./abs(min(xData_2));

% (4) The filter is be shown below
% Definition: X = xData_3
% Formula: TH(threshold) = mean(X|x~=0)
%  /--sgn = 1  if x<TH 
% |
%  \--sgn = 0  if x>TH
TH = mean(xData_3(find(xData_3~=0))) - std(xData_3(find(xData_3~=0)));
for i=1:L
    if xData_3(i) < TH
        sgn(i) = 1;
    else
        sgn(i) = 0;
    end
end
        
%(5) Merge the some part of sgn which the vertical is too small.
%  sgn:  ______---________----_______--_--______---______---_______
%                                    (merge)
%        ______---________----_______-----______---______---_______
count = 0;
sgn_1 = sgn;
for i=1:L
    if sgn(i) == 0
        count = count + 1;
    else
        if count < 25
            sgn_1(i-count:i) = 1;
        end
        count = 0;
    end
end

% (6) find the range of HS candidate
% figure    :      ____________---------____________---------___________
% sgn       :      0  0  0  0  1  1  1  0  0  0  0  1  1  1  0  0  0  0
% locs      :      1  2  3  4  5  6  7  8  9  10 11 12 13 14 15 16 17 18
% locs_start:                  5                    12 
% locs_end  :                        7                    14
% HS.candidate_locs:           5  6  7              12 13 14

count_start = 1;
count_end = 1;
for i=1:L-1
    if ( i==1 && sgn_1(i)==1 )
        locs_start(count_start) = i+1;
        count_start = count_start + 1;
    elseif( sgn_1(i)==0 && sgn_1(i+1)==1)
        locs_start(count_start) = i+1;
        count_start = count_start + 1;
    elseif (sgn_1(i)==1 && sgn_1(i+1)==0)
        locs_end(count_end) = i;
        count_end = count_end + 1;
    end
end

for i=1:length(locs_start)
    HS.candidate_locs{i} = locs_start(i):locs_end(i);
end

% (7) find the HS
for i=1:length(HS.candidate_locs)
    [ value ptr ] = min(xData(HS.candidate_locs{i}));
    HS.discrete_locs(i) = HS.candidate_locs{i}(ptr);
end


% (8) filter the dicrete heelstrike
idx_HS_start = 1;
idx_HS_end = length(HS.discrete_locs);

count = 2;
for i=1:length(HS.discrete_locs)-1
    diff = HS.discrete_locs(i+1) - HS.discrete_locs(i);
    if ( diff > 100 )
        idx_HS_end(count) = i;
        idx_HS_start(count) = i+1;
        count = count + 1;
    end
end
idx_HS_start = sort(idx_HS_start);
idx_HS_end   = sort(idx_HS_end);

idx_hs_locs = [];
count = 1;
for i=1:length(idx_HS_start)
    if ( abs(idx_HS_start(i)-idx_HS_end(i)) > 5 )
        idx_hs_locs{count}  = [ idx_HS_start(i):idx_HS_end(i) ];
        count = count + 1;
    end
end

for i=1:length(idx_hs_locs)    
    HS.continue_locs{i} = HS.discrete_locs(idx_hs_locs{i});
end

%
HS.sgn = sgn_1;

%% figure
if drawFlag
    figure()
    subplot(411)
    plot(sample,xData);
    title('a_x(k)');
    subplot(412)
    plot(sample,xData_1);
    title('a_x^*(k)');
    subplot(413)
    plot(sample,xData_2);
    title('a_x^*^*(k)');
    subplot(414)
    plot(sample,xData_3);
    title('a_x^*^*^*(k)');
    
    figure
    subplot(211)
    plot(sample,xData,sample,xData.*sgn_1');
    subplot(212)
    hold on
    plot(sample,sgn);
    plot(sample,sgn_1);
    ylim([-1.5,1.5]);
    hold off
    title('sgn');
    legend('sgn','sgn_1');
    
    figure
    hold on
    plot(sample, xData);
    plot(HS.discrete_locs, xData(HS.discrete_locs), '*');
    
    for i=1:size(HS.continue_locs,2)
        plot( [ HS.continue_locs{1,i}(1), HS.continue_locs{1,i}(1) ], [max(xData), min(xData)], 'g' );
        plot( [ HS.continue_locs{1,i}(end), HS.continue_locs{1,i}(end) ], [max(xData), min(xData)], 'g' );
    end
    
    legend('Accelerate','Heelstrike');
end

end
    