clear all %#ok<CLSCR>
close all
drawnow
currencyStr = 'ZAR';
currencyStr = 'EUR';

%currencyStr = 'GBP';

%currencyStr = 'USD';


%currencyStr = 'CHF';


fraMaturityVec =   (3:48)/12;
swapMaturityVec = 1:30;

tickerNameVec = BloombergFraSwapTickersForBlock( currencyStr,...
    struct('fraMaturityVec', fraMaturityVec, 'swapMaturityVec', swapMaturityVec)  );

securityStrCell = {tickerNameVec.ticker};
fieldStrCell = {'px_last'};

startDateVal = datenum('2016-03-01');
endDateVal = datenum('2017-02-20');

dateVector = startDateVal:endDateVal;

for dateLoop = length(dateVector):-1:1
    
    
    dateVal = dateVector(dateLoop);
    
    if       IsBusinessDay( dateVal, 'WeekendsOnly' )
        
        verbosityLevel = 0;
        [bloomHistVec, responseHistStr] = ProfessorKettledrumRequest( securityStrCell , fieldStrCell, dateVal, dateVal, verbosityLevel );
        
        
        fraSwapVec = MergeBloomResponseWithFraSwapStruct( tickerNameVec, bloomHistVec, dateVal);
        
        logicalVec =  ~isnan([fraSwapVec.px_last]) & [fraSwapVec.isSwap];
        fprintf('swap maturities: ')
        fprintf('%d ', [fraSwapVec(logicalVec).maturityInYears] )
        fprintf('\nFRA maturities: ')
        logicalVec =  ~isnan([fraSwapVec.px_last]) & ~[fraSwapVec.isSwap];
        fprintf('%d ', 12*[fraSwapVec(logicalVec).maturityInYears] )
        breakline
        
        
        
        
        
        
        stop
        %         if isempty(bloomHistVec)
        %             disp('nothing')
        %             stop
        %         else
        %             disp('something')
        %         end
        
        
    end
    
    
    
end
