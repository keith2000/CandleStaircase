%UsageCountTest1

dirname = 'C:\Dropbox (Personal)\KeithSvn\Matlab\Separation';

dirList = FullDir(  FormFilename('%s/*.m', dirname ) );

nameCell = cellfun (  @(xx)xx(1:end-2), {dirList.name}, 'un', 0 );


for jj = 1:length(nameCell)
    
    filename = which( nameCell{jj} );
    
%end
    
    disp(  filename )
    
    bigStr = ReadTextFileIntoString(filename);
    
    bigStr=regexprep(bigStr, ['\%.*?', char(10)], char(10)); %strip comments
    
    wordCell = regexp(bigStr, '\W', 'split');
    
end

