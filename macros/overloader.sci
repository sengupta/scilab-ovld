function lout = overloader(fname,nout,listin)

//-----------------------------------------------------------------
// PURPOSE
// When  you  invoke a function with first argument being an object
// (more  precisely  an  mlist)  'overloader'  replaces the invoked
// function  by  the  right  one  adapted  to the considered object
// type.
//
// SYNOPSIS
// lout = overloader(fname,nout,lin)
//
// DESCRIPTION
// The function invoking 'overloader', say 'foo.sci' should be like
//       function varargout = foo(varargin)
//       varargout = overloader('foo',argn(1),varargin)
//       endfunction
// In that way, if the first argument is an mlist of type 'typ', it
// is  the  function '%typ_foo.sci' which is invoked, otherwise, it
// is  the  function '%old_foo.sci' (copy of the original 'foo.sci'
// file) which is invoked.
//
// All  required  files ('foo.sci', '%old_foo.sci') are genrated by
// excuting  the script 'updater.sce' of the root directory of this
// module.  It  remains  to  execute 'builder.sce' and 'loader.sce'
// from the same directory.
//
// This function has been written specifically for the Symbolic and
// the  LFR  toolboxes, so, it is not general. In particular, it is
// limited  to overloading functions with less than 10 input/output
// arguments.  In  addition,  checking hierarchy between objects is
// avoided  by  considering  only  the  type  of  the  first  input
// argument.  These  restrictions can easily be aleviated by tuning
// the code of this function.
//
// INPUT ARGUMENTS
// fname   String: name of the function being overloaded.
// nout    Integer:  number  of  output  arguments  of the invoking
//         function
// lin     List: varargin list of the invoking function
//
// OUTPUT ARGUMENTS
// lout    List: varargout list of the invoking function
//
// See also  updater.sce
//-----------------------------------------------------------------

   // Overloads only if 1st input argument is an mlist (type(varargin(1)) == 17)).
   // Prefix of invoked function:
   if type(listin(1)) == 17 then
      tp = typeof(listin(1));
   else
      tp = 'old';
   end;

   // For economy of CPU time, strings are not built on line

   // Input arguments -> string
   select length(listin)
      case 1 then  strin = '(listin(1))';
      case 2 then  strin = '(listin(1),listin(2))';
      case 3 then  strin = '(listin(1),listin(2),listin(3))';
      case 4 then  strin = '(listin(1),listin(2),listin(3),listin(4))';
      case 5 then  strin = '(listin(1),listin(2),listin(3),listin(4),listin(5))';
      case 6 then  strin = '(listin(1),listin(2),listin(3),listin(4),listin(5),listin(6))';
      case 7 then  strin = '(listin(1),listin(2),listin(3),listin(4),listin(5),listin(6),listin(7))';
      case 8 then  strin = '(listin(1),listin(2),listin(3),listin(4),listin(5),listin(6),listin(7),listin(8))';
      case 9 then  strin = '(listin(1),listin(2),listin(3),listin(4),listin(5),listin(6),listin(7),listin(8),listin(9))';
      case 10 then strin = '(listin(1),listin(2),listin(3),listin(4),listin(5),listin(6),listin(7),listin(8),listin(9),listin(10))';
      else error('Too many input arguments, tune the function overloader');
   end;

   // Output argument -> string
   select nout
      case 1 then  strout = '[out1]';
             strexout = 'lout(1)=out1;';
      case 2 then  strout = '[out1,out2]';
             strexout = 'lout(1)=out1;lout(2)=out2;';
      case 3 then  strout = '[out1,out2,out3]';
             strexout = 'lout(1)=out1;lout(2)=out2;lout(3)=out3;';
      case 4 then  strout = '[out1,out2,out3,out4]';
             strexout = 'lout(1)=out1;lout(2)=out2;lout(3)=out3;lout(4)=out4;';
      case 5 then  strout = '[out1,out2,out3,out4,out5]';
             strexout = 'lout(1)=out1;lout(2)=out2;lout(3)=out3;lout(4)=out4;lout(5)=out5;';
      case 6 then  strout = '[out1,out2,out3,out4,out5,out6]';
             strexout = 'lout(1)=out1;lout(2)=out2;lout(3)=out3;lout(4)=out4;lout(5)=out5;lout(6)=out6;';
      case 7 then  strout = '[out1,out2,out3,out4,out5,out6,out7]';
             strexout = 'lout(1)=out1;lout(2)=out2;lout(3)=out3;lout(4)=out4;lout(5)=out5;lout(6)=out6;lout(7)=out7;';
      case 8 then  strout = '[out1,out2,out3,out4,out5,out6,out7,out8]';
             strexout = 'lout(1)=out1;lout(2)=out2;lout(3)=out3;lout(4)=out4;lout(5)=out5;lout(6)=out6;lout(7)=out7;lout(8)=out8;';
      case 9 then  strout = '[out1,out2,out3,out4,out5,out6,out7,out8,out9]';
             strexout = 'lout(1)=out1;lout(2)=out2;lout(3)=out3;lout(4)=out4;lout(5)=out5;lout(6)=out6;lout(7)=out7;lout(8)=out8;lout(9)=out9;';
      case 10 then strout = '[out1,out2,out3,out4,out5,out6,out7,out8,out9,out10]';
             strexout = 'lout(1)=out1;lout(2)=out2;lout(3)=out3;lout(4)=out4;lout(5)=out5;lout(6)=out6;lout(7)=out7;lout(8)=out8;lout(9)=out9;lout(10)=out10;';
      else error('Too many output arguments tune the function overloader');
   end;

   // Ececute the function with prefix %old_ or %type_
   str2execute = strout+'=%'+tp+'_'+fname+strin;
   execstr(str2execute);

   // Put results in a list
   lout = list();
   execstr(strexout);

endfunction
