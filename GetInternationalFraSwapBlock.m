function fraSwapBlock = GetInternationalFraSwapBlock( startDayVal, endDayVal, currencyStr )

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

bestFilename = FormFilename('%s\SharedRmbamHf\Data\Keith\%s_%s.mat', DropboxFairtreeNewlandsDir(), mfilename, currencyStr );
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
    dataBlock(indVecA, :) =  bestStruct.the29Block(indVecB, :);
end

remainingDateVec = setdiff(dateVector, overLapVec);

for dateLoop = 1:length(remainingDateVec)
    %ProgressBar( dateLoop , length(remainingDateVec));
    filename = FormFilename('%s/DiscountFraSwap%s.mat', dirname, datestr( remainingDateVec(dateLoop), 29 ) );
    disp(filename)
    clear loadStruct;
    loadStruct  = load(filename);
    
    if datenum('2006-11-03')==remainingDateVec(dateLoop)
        loadStruct.the29Vec(1) = 0.08776 ; %special case: missing jibar
    end
    if datenum('2005-07-04')==remainingDateVec(dateLoop)
        loadStruct.the29Vec(end) = 0.074675 ; %special case: missing 30y
    end
    
    if any(  isnan(loadStruct.the29Vec)  )
        loadStruct.the29Vec = Fixed29VecFromNan29Vec( loadStruct.the29Vec );
    end
    
    
    
    assert(all( ~isnan( loadStruct.the29Vec ) ));
    the29Block(dateVector==remainingDateVec(dateLoop), :) = loadStruct.the29Vec ;
end

if ~isempty(remainingDateVec)
    %we've added some data: let's save it
    save(bestFilename, 'the29Block', 'dateVector');
    fprintf('saved %s\n',bestFilename )
end


fraSwapBlock.dateVector = dateVector;
fraSwapBlock.data = the29Block;

