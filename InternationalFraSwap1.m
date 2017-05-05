clear all %#ok<CLSCR>
close all
drawnow
currencyStr = 'USD';
currencyStr = 'ZAR';
%currencyStr = 'EUR';



fraMaturityVec =   (1:48)/12;
swapMaturityVec = 1:30;

tickerNameVec = BloombergFraSwapTickersForBlock( currencyStr,...
    struct('fraMaturityVec', fraMaturityVec, 'swapMaturityVec', swapMaturityVec)  );

securityStrCell = {tickerNameVec.ticker};
fieldStrCell = {'px_last'};

startDateVal = datenum('2012-01-20');
endDateVal = datenum('2017-01-20');

dateVector = startDateVal:endDateVal;

for dateLoop = length(dateVector):-1:1
    
    
    dateVal = dateVector(dateLoop);
    
    if       IsBusinessDay( dateVal, 'WeekendsOnly' )
        
        verbosityLevel = 0;
        [bloomHistVec, responseHistStr] = ProfessorKettledrumRequest( securityStrCell , fieldStrCell, dateVal, dateVal, verbosityLevel );
        
        
        
        
         disp(  qdatestr(dateVal) )
         
         
         stop
%         if isempty(bloomHistVec)
%             disp('nothing')
%             stop
%         else
%             disp('something')
%         end
        
        
    end
    
    
    
end
