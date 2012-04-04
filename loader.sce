mode(-1);
libname='OVLD'
libtitle='Function Overloader Module';

// Get the absolute path to this file -> DIR
[units,typs,nams]=file();
clear units typs
for k=size(nams,'*'):-1:1
  l=strindex(nams(k),'loader.sce');
  if l<>[] then
    DIR=part(nams(k),1:l($)-1);
    break
  end
end

// Path to files to be loaded
if ~MSDOS then // Unix
  if part(DIR,1)<>'/' then DIR=getcwd()+'/'+DIR,end
  MACROS=DIR+'macros/'
else // Windows
  if part(DIR,2)<>':' then DIR=getcwd()+'\'+DIR,end
  DIR=strsubst(DIR,'/','\');
  MACROS=DIR+'macros\'
end

// Load the library
execstr(libname+'=lib(""'+MACROS+'"")')

// Clean environment
clear fd err nams DIR DIR2 libname libname_ext libtitle mess
