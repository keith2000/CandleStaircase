function listCell_ = GenDependencyList( theM_file, levelVal, levelThresh, varargin )

%»» orignally authored by KF 2017-02-20 11h38:
%e.g. DependencyList('BloomIntratest1')
%lists all local (that is, Dropbox) dependencies for your M-file
%Useful if you need to copy/move them


lenThresh = 5;
matchStr = 'Dropbox';
verbosityLevel = 1;
badCell = {'examples', 'optimization','connect', 'Debug','startup', 'scratch', 'lload', 'rogle', 'google', 'cprintf', 'count', 'color', 'Color', 'Contents', 'MyPalette', 'boundary', 'normal', 'ensure', 'test', 'stop', 'com'};
VararginModifyDefaults( varargin{:} )

if ~exist('levelVal', 'var')
    levelVal = 0;
end

if ~exist('levelThresh', 'var')
    levelThresh = 10;
end

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

wordCell = regexp(bigStr, '\W', 'split');

wordCell = unique( wordCell );

for wordLoop = 1:length( wordCell )
    
    if length(wordCell{wordLoop}) >= lenThresh
        
        thisStr = which(  wordCell{wordLoop}  );
        
        if ~isempty( strfind(thisStr, matchStr) )
            
            [~, fPart, ~] = fileparts(thisStr);
            
            if strcmp(fPart,wordCell{wordLoop}) %test for case "trancheSize"~="TrancheSize"
                if ~ismember(  wordCell{wordLoop}, listCell )
                    if ~ismember(  wordCell{wordLoop}, badCell )
                        
                        
                        currentSize = length(listCell);
                        
                        listCell{end+1} = wordCell{wordLoop};
                        subListCell = DependencyList( wordCell{wordLoop}, levelVal+1, levelThresh, 'matchStr', matchStr  );
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