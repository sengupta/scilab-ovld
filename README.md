Scilab module for overloading functions
=======================================

Scilab module for overloading functions when the first input argument
of a function is an object (more precisely an mlist).

Version 1.0 May, 2006
======================

Jean-Francois Magni: jean-francois.magni_at_onera.fr

Short description
=================

Basically

    foo(arg1,arg2,.....)

is replaced automatically by

    %typ_foo(arg1,arg2,.....)

if `arg1` is an `mlist` s.t. `typeof(arg1) = 'typ'` otherwise it is

    %old_foo(arg1,arg2,.....)

which is invoked (`%old_foo` is a copy of the pre-existing function `foo`)

This script creates all the relevant Scilab functions (`foo`, `%old_foo`).
Note that the list of overloaded function can be customized in the
updater.sce file.

This module is a complement to the Symbolic and LFR toolboxes

Installation
============
To Install this toolbox: (Scilab-4.0 or higher)

We Suppose here that <PATH> stands for the path to the directory
containing this README file.

1. Execute only once the following instruction within Scilab:
   `exec <PATH>/updater.sce`
2. Execute only once the following instruction within Scilab:
    `exec <PATH>/builder.sce`
3. Each times Scilab is launched, execute within Scilab:
    exec <PATH>/loader.sce
    It is better to execute loader.sce from the .scilab startup
    file for automatic loading. This file should be in
    `<HOME_DIRECTORY>\Scilab\scilab-x.x` (Windows) or
    `~/.Scilab/scilab-x.x (Unix/Linux)`.

Contents
========

* README.md          : this file
* LICENSE            : license agreement and disclaimer
* HISTORY            : history of updates
* updater.sce        : script generating all files required for overloading
* updaternew.sce     : newer version of updater.sce not tested
* builder.sce        : installation script
* loader.sce         : script for loading OVLD functions (see item 3 above)
* macros/            : directory of Scilab functions
    *   overloader.sci  : main function for overloading
    *   *.sci           : functions generated by the script updater.sce (generated)
    *   *.bin           : precompiled binary versions (generated)
    *   names           : table of functions (generated)
    *   lib             : scilab library binary save (generated)
* backup/
    *   overloader.sci  : backup of the function with same name located in macros/
