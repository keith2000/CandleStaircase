function fraSwapBlock = GetInternationalFraSwapBlock( startDayVal, endDayVal, currencyStr )

%fraSwapBlock = GetInternationalFraSwapBlock( datenum('1-jan-2014'), datenum('1-feb-2014'), 'GBP' )

SetEmptyOrNonexistentVarToDefault('startDayVal', datenum('1-jan-2004'))
SetEmptyOrNonexistentVarToDefault('endDayVal', fix(now-1))
SetEmptyOrNonexistentVarToDefault('currencyStr', 'ZAR')

assert( startDayVal==fix(startDayVal)  )
assert( endDayVal==fix(endDayVal)  )

dateVector = BusinessDateRange( startDayVal, endDayVal, 'ExcludeWeekendsOnly');


%stop

%dataBlock = NaN( numel(dateVector), 29 );


dirname = [DropboxFairtreeNewlandsDir(), '\SharedRmbamHf\Data\Bloomberg\FraSwap\'];
%C:\Dropbox (Fairtree Newlands)\SharedRmbamHf\Data\Bloomberg\FraSwap\ZAR

bestFilename = FormFilename('%s\SharedRmbamHf\Data\Keith\%s_%s.mat', dirname, mfilename, currencyStr )
if exist(bestFilename, 'file')
    bestStruct = load(bestFilename);
else
    bestStruct.dateVector = [];
    bestStruct.data = [];
end


[overLapVec, indVecA, indVecB] =  intersect( dateVector, bestStruct.dateVector );
%indVecA
%indVecB
if ~isempty(indVecB)
    dataBlock(indVecA, :) =  bestStruct.data(indVecB, :);
end

remainingDateVec = setdiff(dateVector, overLapVec);

for dateLoop = 1:length(remainingDateVec)
    %ProgressBar( dateLoop , length(remainingDateVec));
    %"C:\Dropbox (Fairtree Newlands)\SharedRmbamHf\Data\Bloomberg\FraSwap\ZAR\FraSwapVecZAR1998-12-10.mat"
    filename = FormFilename('%s/%s/FraSwapVec%s%s.mat', dirname, currencyStr, currencyStr, datestr( remainingDateVec(dateLoop), 29 ) )
    if ~exist(filename, 'file')
       error('%s does not exist: code for generating it still to be implemented.') 
    end
    
    disp(filename)
    clear loadStruct;
    loadStruct  = load(filename);
    
    dataBlock(dateVector==remainingDateVec(dateLoop), :) = loadStruct.the29Vec ;
    
    tempsave, stop
end

if ~isempty(remainingDateVec)
    %we've added some data: let's save it
    save(bestFilename, 'the29Block', 'dateVector');
    fprintf('saved %s\n',bestFilename )
end


fraSwapBlock.dateVector = dateVector;
fraSwapBlock.data = dataBlock;

