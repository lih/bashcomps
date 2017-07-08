% BASHCOMPS(1) Bash libraries | A completion helper library
% Marc Coiffier
% Friday, September 26 2014

USAGE
=====

**source /usr/share/bash/bashcomps.shl**

DESCRIPTION
===========

Bashcomps is a completion helper library for Bash commands. It allows
for easy and powerful completion specifications through the use of
simili-"parser combinators".

For example, you can easily define completions for lists of words or
sequences thereof :

    # An example of function to complete
    function myCmd() {
       case "$1" in
         add)
           shift
           for col; do echo "$col"; done > file
           ;;
         delete)
           shift
           for col; do grep -vF "$col" file > file.new; mv file.new file; done
           ;;
         list-colors)
           cat file
           ;;
       esac 
    }

    source /usr/share/bash/bashcomps.shl
    # Now for the completions
    function C.color() { C.wordOf 5 red green blue black white "$@"; }
    function C.myCmd() {
        C.alt C.wordOf 2 add delete \
              C.repeat C.color
        C.alt C.wordOf 1 list-colors :
    }
    C.defcomp C.myCmd myCmd

FUNCTIONS
=========

The `/usr/share/bash/bashcomps.shl` file defines a few useful functions for defining your own completions :

Core interface
--------------

C.defcomp

:   **Usage**: C.defcomp EXPR COMMAND...
    
    Sets the completion of the given COMMANDs to be the evaluation of EXPR.

C.alt

:   **Usage**: C.alt TAIL...
    
    Defines a completion alternative, usually one of several. All
    alternatives matching a completion prefix will be taken into account
    when generating suggestions.

C.repeat

:   **Usage**: C.repeat TAIL...
    
    Completes the given TAIL ad infinitum. 

C.suffixed, C.describing, C.normal

:   **Usage**: (C.suffixed SUFF|C.describing DESC|C.normal) TAIL...
    
    Sets or unsets the suffixes to be used when completing TAIL. This
    feature can be used to complete compound constructs, such as URLs, and/or
    annotate completions with short descriptions :
    
        function C.url() {
            C.suffixed '://' C.describing Protocol C.wordOf 2 http https \
              C.describing Hostname C.suffixed '/' C.hostname \
              C.normal "$@"
        }

C.argument, C.return

:   **Usage**: C.argument (flag|opt|word) COMMAND ARG...
    
    **Usage**: C.return TAIL...
    
    This is the heart of all completion functions. The C.argument function extracts
    the next argument according to its expected shape, then runs `COMMAND
    WORD ARG...` if it succeeds. COMMAND is expected to generate completions for
    the word in the `SUGGESTIONS` array, then call C.return with the remaining completion
    specifications. Thus the usual skeleton of a C.argument command is :
    
        function C.compSkel() {
            local word="$1" ; shift
    
            ... some code filling 'SUGGESTIONS' here ...
    
            C.return "$@"
        }


Helper functions
----------------

C.wordOf, C.flagOf, C.optOf

:   **Usage**: C.(word|flag|opt)Of N WORD1 ... WORDN TAIL...
    
    Completes a word, flag or option among the given N alternatives. Flags
    and options are treated differently for completion of single-character
    flags, so choose carefully : options require arguments whereas flags
    do not.
    
    After completing that word, these functions go on to completing the TAIL
    command if specified, enabling context-specific completions.

C.fileIn

:   **Usage**: C.fileIn (-?|N TEST1 ... TESTN) DIRECTORY TAIL...
    
    Completes file names verifying the given test, rooted at DIRECTORY.
    
    The test can be any standard Bash file test flag (such as '-d', '-f',
    '-r' and the like) or a command prefix, in which case the command
    **TEST1 ... TESTN FILENAME** must return non-zero on files that should
    be excluded.



