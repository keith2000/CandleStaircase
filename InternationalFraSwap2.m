clear all %#ok<CLSCR>
close all
drawnow



%currencyStr = 'ZAR';
%currencyCell = {'EUR', 'ZAR', 'GBP', 'CHF', 'USD'};
currencyCell = { 'EUR', 'ZAR', 'GBP', 'USD'};

%currencyStr = 'GBP';

%currencyStr = 'USD';


%currencyStr = '';


fraMaturityVec =   (3:24)/12;
swapMaturityVec = 1:30;



startDateVal = datenum('1017-05-01');
endDateVal = datenum('2009-05-01');

dateVector = startDateVal:endDateVal;


goodCount = 0;

for dateLoop = length(dateVector):-1:1
    
    
    for currencyLoop = 1:length(currencyCell)
        currencyStr = currencyCell{currencyLoop};
        
        tickerNameVec = BloombergFraSwapTickersForBlock( currencyStr,...
            struct('fraMaturityVec', fraMaturityVec, 'swapMaturityVec', swapMaturityVec)  );
        
        securityStrCell = {tickerNameVec.ticker};
        fieldStrCell = {'px_last'};
        
        
        
        
        dateVal = dateVector(dateLoop);
        
        if       IsBusinessDay( dateVal, 'WeekendsOnly' )
            
            dirname = [DropboxFairtreeNewlandsDir(), '\SharedRmbamHf\Data\Bloomberg\FraSwap\', currencyStr];
            
            MakeNewDirectory(dirname)
            filename = FormFilename('%s/FraSwapVec%s%s.mat',dirname, currencyStr, datestr(dateVal, 29)  );
            
            if exist(filename, 'file')
                if rand < 0.01
                fprintf('%s already exists\n',  filename )
                end
            else
                disp( currencyStr )
                disp(   qdatestr(dateVal)  )
                
                verbosityLevel = 0;
                
                %stop
                [bloomHistVec, responseHistStr] = ProfessorKettledrumRequest( securityStrCell , fieldStrCell, dateVal, dateVal, verbosityLevel );
                
                
                
                if ~isempty(bloomHistVec)
                    fraSwapVec = MergeBloomResponseWithFraSwapStruct( tickerNameVec, bloomHistVec, dateVal);
                    
                    logicalVec =  ~isnan([fraSwapVec.val]) & [fraSwapVec.isSwap];
                    fprintf('swap maturities: ')
                    fprintf('%d ', [fraSwapVec(logicalVec).maturityInYears] )
                    fprintf('\nFRA maturities: ')
                    logicalVec =  ~isnan([fraSwapVec.val]) & ~[fraSwapVec.isSwap];
                    fprintf('%d ', 12*[fraSwapVec(logicalVec).maturityInYears] )
                    breakline
                    
                    
                    save(filename, 'fraSwapVec')
                    fprintf('wrote %s\n',  filename )
                    goodCount = goodCount+1;
                end
            end
        end
        
    end
    
    if goodCount > 40
       %continue 
       break
    end
    
end
