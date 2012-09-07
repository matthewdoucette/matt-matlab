function dates = filterDates(startDate, endDate, N, X, Y)
% 0. Check inputs
assert(all(N>0) || all(N<0) || isscalar(N)&&N==0, 'N must be all positive integers, all negative integers or scalar 0');
assert(isnumeric(X) && all(X>=1) && all(X<=7) || ischar(X) && ~isempty(X) && any(lower(X(1))=='bwhd'), 'X must be an integer between 1 & 7 or character B, W, H or D');
assert(isnumeric(Y) && all(Y>=1) && all(Y<=12)|| ischar(Y) && ~isempty(Y) && any(lower(Y(1))=='ym'), 'Y must be an integer between 1 & 12 or character Y or M');

% 1. Convert startDate and endDate into their numeric representations
startDate = datenum(startDate);
endDate = datenum(endDate);

[yr1,mo1] = datevec(startDate);
[yr2,mo2] = datevec(endDate);
if ischar(Y) && lower(Y(1)) == 'y' 
    
    sd = datenum([yr1,1,1])-1-max(abs(N))-7;
    ed = datenum([yr2+1,1,1])+max(abs(N))+7;
else
    sd = datenum([yr1,mo1,1])-1-max(abs(N))-7; 
    ed = datenum([yr2,mo2+1,1])+max(abs(N))+7;
end
allDates = sd:ed;

if isnumeric(X)
    ind = ismember(weekday(allDates), X);
elseif lower(X) == 'b'
    ind = isbusday(allDates);
elseif lower(X) == 'w'
    ind = ismember(weekday(allDates), 2:6);
elseif lower(X) == 'h'
    ind = ismember(allDates,holidays);
else
    ind = true(size(allDates));
end
allDates = allDates(ind);
[yr,mo] = datevec(allDates);

if isnumeric(Y)
    allDates = allDates(ismember(mo, Y));
    [yr,mo] = datevec(allDates);
    ind = find(diff(mo)~=0 | diff(yr)~=0)+1; % Find the index of date where the month changes (this is the first of that month)
    if all(N < 0)
        ind = union(ind, length(allDates)+1); % Tack on last+1 index
    elseif all(N > 0)
        ind = union(ind, 1); % Tack on first index
    end
end

if ischar(Y) && lower(Y) == 'y'
    ind = find(diff(yr)~=0)+1;
elseif ischar(Y) && lower(Y) == 'm'
    ind = find(diff(mo)~=0 | diff(yr)~=0)+1;
end
 
if all(N == 0)
    finalInd = 1:length(allDates); % Return all matching dates
else
    finalInd = bsxfun(@plus, ind, N(:)); % Really just ind + N for different sizes of ind and N
    finalInd = finalInd(:);
    if all(N > 0)
        finalInd = finalInd - 1; % Offset because of 1 based indexing
    end
end
finalInd = finalInd(finalInd>0 & finalInd<=length(allDates)); % Remove invalid indices (this is okay because of the safety buffer)


allDates = allDates(finalInd);
dates = allDates(allDates>=startDate & allDates<=endDate);
