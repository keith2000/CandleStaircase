function ratingStr = ImdbExtractRatingString( contentStr )


ratingStr = '';

matchCell = regexp(contentStr, 'strong title=".*?user ratings"', 'match');

if ~isempty(matchCell)
    
    ratingStr = matchCell{1}(15:end);
    
    ratingStr = [ratingStr(1:3), '/10 ', ratingStr(4:end-1)];
    
end

