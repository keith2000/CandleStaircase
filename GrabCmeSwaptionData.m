

dateVector = fix( now-13:now-2 );

%dateVector = fix(now-99)
logicalVec = IsBusinessDay( dateVector, 'USD');
dateVector = dateVector( logicalVec );

for dateLoop = 1:length(dateVector),
    
    dateVal = dateVector(dateLoop);
    disp(  qdatestr(dateVal)  )
    
    
    %qq = urlread(CME_ATM_VolCube_20170328.csv')
    dirname = [DropboxFairtreeNewlandsDir(), '\SharedRmbamHf\Data\CME\Vol\'];
    MakeNewDirectory(dirname);
    
    
    fPart = sprintf('CME_ATM_VolCube_%s.csv', datestr(dateVal, 'yyyymmdd') );
    csvFilename = FormFilename('%s/%s', dirname, fPart);
    
    
    if exist(csvFilename, 'file')
        fprintf('%s already exists\n', csvFilename );
        
    else
        disp(  csvFilename  )
        
        urlStr = ['ftp://ftp.cmegroup.com/irs/', fPart];
        disp(urlStr)
        
        try
            responseStr = urlread(urlStr);
            
            WriteStringToTextFile(responseStr, csvFilename );
            fprintf('created %s\n', csvFilename );
        catch mE
            disp(mE)
        end
        
        
        
    end
end