function listCell_ = GenDependencyList( theM_file,  verbosityLevel, levelThresh, matchStr,  lenThresh, levelVal )

%e.g. GenDependencyList(  'InternationalFraSwap1' )
%e.g. GenDependencyList(  'InternationalFraSwap1', 99 )
%e.g. GenDependencyList(  'InternationalFraSwap1', 0 ) %no progress bar 
%e.g. GenDependencyList(  'InternationalFraSwap1', [], 22 ) %goes deeper. empty inputs take on their default values via SetEmptyOrNonexistentVarToDefault

%these are words to ignore. If a string or var name has the same name as a
%function then it will be picked up by GenDependencyList. Add to this list
%to force exclusion. (Note that the function name is arguably poorly named if this is the case.)
excludeCell = {'index', 'easter', 'examples', 'optimization','connect', 'Debug','startup', 'scratch', 'lload', 'rogle', 'google', 'cprintf', 'count', 'color', 'Color', 'Contents', 'MyPalette', 'boundary', 'normal', 'ensure', 'test', 'stop', 'com'};

SetEmptyOrNonexistentVarToDefault('levelVal', 0);
SetEmptyOrNonexistentVarToDefault('levelThresh', 10);
SetEmptyOrNonexistentVarToDefault('matchStr', 'Dropbox|GitHub' ); %assumes that user files live in a folder that regexp matches to either Dropbox or to GitHub
SetEmptyOrNonexistentVarToDefault('verbosityLevel', 1);
SetEmptyOrNonexistentVarToDefault('lenThresh', 5)

assert(all(ischar(theM_file)), 'theM_file must be a string containing the relevant function/script name')


persistent listCell; % we need a persistent variable because we are recursively entering functions but don't want to visit anything more than once
if 0==levelVal
    listCell = [];
end

% if ~exist('listCell', 'var')
%     listCell = [];
% end

if levelVal > levelThresh
    listCell_ = [];
    return
end

if verbosityLevel >= 2
    fprintf('%s, level %d\n', theM_file, levelVal)
end


filename = which( theM_file );

bigStr = ReadTextFileIntoString(filename);

bigStr=regexprep(bigStr, ['\%.*?', char(10)], char(10)); %strip comments

wordCell = regexp(bigStr, '\W', 'split');

wordCell = unique( wordCell );

for wordLoop = 1:length( wordCell )
    
    if length(wordCell{wordLoop}) >= lenThresh
        
        thisStr = which(  wordCell{wordLoop}  );
        [dPart, fPart, ~] = fileparts(thisStr);
        
        if ~isempty( regexp(dPart, matchStr, 'once') )
            
            
            
            if strcmp(fPart,wordCell{wordLoop}) %test for case "trancheSize"~="TrancheSize"
                if ~ismember(  wordCell{wordLoop}, listCell )
                    if ~ismember(  wordCell{wordLoop}, excludeCell )
                        
                        
                        currentSize = length(listCell);
                        
                        listCell{end+1} = wordCell{wordLoop};
                        %subListCell = GenDependencyList( wordCell{wordLoop}, levelVal+1, levelThresh, 'matchStr', matchStr  );
                        subListCell = GenDependencyList( wordCell{wordLoop}, verbosityLevel, levelThresh, matchStr,  lenThresh, levelVal+1 );
                         
                        %GenDependencyList( theM_file, levelVal, levelThresh, matchStr, verbosityLevel, excludeCell, lenThresh )

                        if ~isempty(subListCell)
                            listCell = [listCell, subListCell{:}];
                        end
                        listCell = unique(listCell);
                        
                        
                        if verbosityLevel >= 1
                            
                            if length(listCell) > currentSize
                                fprintf('*')
                            end
                        end
                        
                        
                    end
                end
            end
        end
    end
end

listCell_ = listCell;

if verbosityLevel >= 1    
    if 0==levelVal
        breakline
    end    
end