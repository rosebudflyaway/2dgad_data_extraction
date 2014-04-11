1. Download the mex interface for PATH from:
     ftp://ftp.cs.wisc.edu/math-prog/solvers/path/matlab/
    The relevant (4) files are:
       pathlcp.m        (for all machines)
       pathmcp.m        (for all machines)
and
       lcppath.dll      (for PC)
       mcppath.dll      (for PC)
       lcppath.mexglx   (for Linux)
       mcppath.mexglx   (for Linux)
       lcppath.mexsol   (for Solaris)
       mcppath.mexsol   (for Solaris)

   Save the mex interface (above 4 files) to a place on your MATLAB path
    e.g. on a PC:
        c:\matlabR12\toolbox\local\*
   or to your current working directory.

For small problems you should be ready to go.  For larger problems, read on...
        
2. Set the PATH_LICENSE_STRING environment variable to the string that
   was provided by Michael Ferris (or use the temporary one that is
   found in the file LICENSE in this directory).
   
   On a PC:
      set PATH_LICENSE_STRING="license_string"

   On LINUX/Solaris using csh:
      setenv PATH_LICENSE_STRING="license_string"

   On LINUX/Solaris using bash:
      export PATH_LICENSE_STRING="license_string"

3. Start up matlab and try the following:

   x = pathlcp(speye(500),-ones(500,1));
   type logfile.tmp

This should give the output something like:

>> type logfile.tmp

Path 4.6.02: Matlab Link
500 row/cols, 500 non-zeros, 0.20% dense.

Could not open options file: path.opt
Using defaults.
Path 4.6.02 (Thu Jul 18 07:24:01 2002)
Written by Todd Munson, Steven Dirkse, and Michael Ferris

MCPR: Zero:     0 Single:   500 Double:     0 Forced:     0

 ** EXIT - solution found.

Major Iterations. . . . 0
Minor Iterations. . . . 0
Restarts. . . . . . . . 0
Crash Iterations. . . . 0
Gradient Steps. . . . . 0
Function Evaluations. . 0
Gradient Evaluations. . 0
Total Time. . . . . . . 0.010000
Residual. . . . . . . . 0.000000e+000
Postsolved residual: 0.0000e+000

>> 

Please contact Michael Ferris (ferris@cs.wisc.edu) 
or Todd Munson (tmunson@mcs.anl.gov) if
you require further information.
