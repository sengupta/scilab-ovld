// This script is used for generating all the files required for making
// overloadable a given list of Scilab functions. Let 'foo' be the name of a
// function belonging to this list:
//   - when 'foo' is invoked with its first argument being an object (mlist)
//     of type 'typ', it is the function '%typ_foo' which will be invoked instead
//     of the standard Scilab function 'foo'
//   - otherwise, it is the standard Scilab function which will be invoked but
//     this function has been renamed '%old_foo'.
//  In addition, it is possible to make overloadable some functions which
//  are not (yet) standard functions. This feature is necessary for
//  functions which might be applied to various kinds of objects.
//
//  The lists of considered functions can be customized below.
//
//  This script
//  - copies in macros/ the standard functions 'foo' renamed as '%old_foo' in
//    which the first line of the function has also been updated.
//  - generates a dummy function '%old_foo' in case 'foo' was not a standard
//    Scilab function.
//  - generates in both cases a new function 'foo' which call the function
//    'overloader' for invoking the relevant form of 'foo' (e.g., %old_foo
//    or %sym_foo or %lfr_foo...).

// TO DO:
// 1- only one list of function
//        if built-in function -> do nothing (warning) use whereis('spec')
//        if non-existing function -> send it to new_func array
// 2- compare the Scilab version which was used for writing overloaded functions
//        and the running Scilab version -> if different, ask to re-use this script

mode(-1);

////////////////////////////////////////////////////////////////////////////////
// To be customized
////////////////////////////////////////////////////////////////////////////////

// List of existing functions to be made overloadable
old_func = [...
'diff';...
'eval';...
'gcd';...
'horner';...
'isempty';...
'lcm';...
'null';...
'rank';...
'rref';...
'trace'];

// List of non-Scilab functions likely to be applied to several objects
new_func = [...
'colspace';...
'expand';...
'eig';...
'dbl';...
'factor';...
'integ';...
'limit';...
'simple';...
'symsum';...
'taylor'];

////////////////////////////////////////////////////////////////////////////////
// Preliminaries
////////////////////////////////////////////////////////////////////////////////

clear OVLD

// Absolute path of the present file
[units,typs,nams]=file();
clear units typs
for k=size(nams,'*'):-1:1
  l=strindex(nams(k),'updater.sce');
  if l<>[] then
    DIR=part(nams(k),1:l($)-1);
    break
  end
end

if MSDOS sslash = '\' else sslash = '/'; end;

////////////////////////////////////////////////////////////////////////////////
// File generation %old_<existing files>
////////////////////////////////////////////////////////////////////////////////

// Absolute paths of existing functions (paths) to be overloaded and
// absolute paths of created functions (newpaths and all_paths)
jj = 1;
kk = [];
for ii = 1:maxi(size(old_func));
   path_and_fichier = get_function_path(old_func(ii));
   if ~isempty(path_and_fichier);
      // Existing file
      paths(jj) = path_and_fichier;
      // File to be created
      newpaths(jj) = DIR+'macros'+sslash+'%old_'+old_func(ii)+'.sci';
      all_paths(jj) = DIR+'macros'+sslash+old_func(ii)+'.sci';
      all_func(jj) = old_func(ii);
      kk(jj) = ii;
      jj = jj + 1;
   end;
end;
old_func = old_func(kk);

// Read file, change function name to %old_foo and copy file to new location
for ii = 1:length(kk);

   u1=file('open',paths(ii),'unknown');
   content = read(u1,-1,1,'(a)');
   file('close',u1);

   content(1) = strsubst(content(1),old_func(ii)+'(','%old_'+old_func(ii)+'(');

   u2=file('open',newpaths(ii),'unknown');
   write(u2,content,'(a)');
   file('close',u2);

end;

////////////////////////////////////////////////////////////////////////////////
// File generation %old_<new files>
////////////////////////////////////////////////////////////////////////////////

for ii = 1:maxi(size(new_func));

   newpaths(ii) = DIR+'macros'+sslash+'%old_'+new_func(ii)+'.sci';
   all_paths(length(kk)+ii) = DIR+'macros'+sslash+new_func(ii)+'.sci';
   all_func(length(kk)+ii) = new_func(ii);

   content = [];
   content(1,1) = 'function [varargout] = %old_'+new_func(ii)+'(varargin)';
   content(2,1) = 'error(''Function defined only for some objects'')';
   content(3,1) = 'endfunction';

   u2=file('open',newpaths(ii),'unknown');
   write(u2,content,'(a)');
   file('close',u2);

end;

////////////////////////////////////////////////////////////////////////////////
// File generation : called function
////////////////////////////////////////////////////////////////////////////////

for ii = 1:maxi(size(all_func));

   content = [];
   content(1,1) = 'function varargout = '+all_func(ii)+'(varargin)';
   content(2,1) = 'varargout = overloader('''+all_func(ii)+''',argn(1),varargin)';
   content(3,1) = 'endfunction';

   u3=file('open',all_paths(ii),'unknown');
   write(u3,content,'(a)');
   file('close',u3);

end;

////////////////////////////////////////////////////////////////////////////////
// Message
////////////////////////////////////////////////////////////////////////////////

write(%io(2),'Now execute the following lines');
write(%io(2),'exec('''+DIR+'builder.sce'');');
write(%io(2),'exec('''+DIR+'loader.sce'');');

clear DIR content sslash u1 u2 u3 old_func new_func all_func newpaths all_paths ii jj k
