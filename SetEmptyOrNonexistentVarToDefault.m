function SetEmptyOrNonexistentVarToDefault( varNameStr, defaultValue )


%we want to do something like this
% if ~exist('lenThresh', 'var'), lenThresh = []; end
% if isempty(lenThresh), lenThresh = 5; end %allows either an empty array or no specified input to mean use the default value
% BUT we don't want to specify the var name more than once. This is asking
% for trouble if one copies and pastes. E.g. One forgets to change one
% instance. Although eval is evil, in this case it's use is considered


assert( all( ischar(varNameStr) ) )

evalStr = sprintf( 'if ~exist(''%s'', ''var''), %s = []; end', varNameStr, varNameStr );
evalin('caller', evalStr);


isVarEmpty = evalin( 'caller', sprintf('isempty(%s)', varNameStr));

if isVarEmpty
       assignin('caller',   varNameStr,defaultValue  );
 
end


%evalStr = sprintf( 'if isempty(%s), %s = ; end', varNameStr, varNameStr );


