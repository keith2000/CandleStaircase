function theAddress = ImdbAddressFromSearchStr(  searchStr )


warning( 'off', 'MATLAB:urlread:ReplacingSpaces' )



SetEmptyOrNonexistentVarToDefault('searchStr', clipboard('paste') );

disp(searchStr)

urlStr = sprintf('http://www.imdb.com/find?ref_=nv_sr_fn&q=%s&s=all', searchStr);
searchPageStr = urlread(urlStr);
strOut = StandardStringStrip( searchPageStr, '</a>Titles</h3>', 'findMoreMatches');

disp(strOut)


ttStr = StandardStringStrip( strOut, '="/title/', '/?ref');
disp(ttStr)


theAddress = sprintf('http://www.imdb.com/title/%s/', ttStr );

disp(theAddress)
clipboard('copy', theAddress );

[descriptionStr, thisStr] = ImdbDescriptionString( theAddress );
disp(searchStr)
disp( WrapText( descriptionStr, 99) )

%disp(thisStr)

contentStr = urlread(theAddress);
ratingStr = ImdbExtractRatingString( contentStr );

disp(ratingStr)