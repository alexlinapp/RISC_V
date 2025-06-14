# RISC_V

# Setup

In the command prompt run:  

    cmd.exe /k "C:\Xilinx\Vivado\2024.2\settings64.bat"

To execute the program, run the following commands in order:

    xvlog --sv path-to-source-file
    xelab <top_module_name> -s <sim_name>
    xsim <sim_name> -runall

To view an interactive waveform:

    xsim <sim_name> -gui

To build add `UVM_HOME` to environment variables and run:

    xvlog --sv %UVM_HOME%/xlnx_uvm_package.sv

The `filelists.f` contains all the files to be compiled

Then run the `run.tcl` file:

    vivado -mode batch -source run.tcl -nolog -nojournal -notrace

