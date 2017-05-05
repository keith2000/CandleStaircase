function fraSwapVec = MergeBloomResponseWithFraSwapStruct( tickerNameVec, bloomHistVec, dateVal)


%bloomHistVec

%dateVal = 736715;

fraSwapVec = [];

for jj = 1:length(tickerNameVec)
   
    temp = tickerNameVec(jj);

    temp.dateVal = dateVal;
    
    temp.px_last = NaN;
    
    thisStruct = bloomHistVec(  strcmp( {bloomHistVec.security}, temp.ticker )  );
    %stop
    if ~isempty(thisStruct)
        if thisStruct.fieldVec.date == dateVal
            temp.px_last = thisStruct.fieldVec.px_last/100;
        end
    end
        
        
   fraSwapVec = [fraSwapVec, temp];
   % stop
    
end