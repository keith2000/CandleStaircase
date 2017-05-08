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

disp('aa')
tickerNameVec = BloombergFraSwapTickersForBlock( currencyStr,...
    struct('fraMaturityVec', fraMaturityVec, 'swapMaturityVec', swapMaturityVec)  );

disp('aa')
securityStrCell = {tickerNameVec.ticker};
fieldStrCell = {'px_last'};

startDateVal = datenum('2016-03-01');
endDateVal = datenum('2017-02-20');

dateVector = startDateVal:endDateVal;

disp('aa')

for dateLoop = length(dateVector):-1:1
    
    
    dateVal = dateVector(dateLoop);
    
    if       IsBusinessDay( dateVal, 'WeekendsOnly' )
        
        dirname = [DropboxFairtreeNewlandsDir(), '\SharedRmbamHf\Data\Bloomberg\FraSwap\', currencyStr];
        
        MakeNewDirectory(dirname)
        filename = FormFilename('%s/FraSwapVec%s%s.mat',dirname, currencyStr, datestr(dateVal, 29)  );
        
        if exist(filename, 'file')
            fprintf('%s already exists\n',  filename )
        else
            
            
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
            
            
            save(filename, 'fraSwapVec')
            fprintf('wrote %s\n',  filename )
            
        end
        %stop
        %         if isempty(bloomHistVec)
        %             disp('nothing')
        %             stop
        %         else
        %             disp('something')
        %         end
        
        
    end
    
    
    
end
