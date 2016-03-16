# matlab_loadflow_newton-raphson
This is a newton-raphson powerflow solution which I wrote in MATLAB for a Power Systems Analysis course at University of Washington. The algorithm is not super sophisticated. It can handle three bus-types:
 - Slack - voltage magnitude and angle specified
 - PQ - real and reactive power specified
 - PV - real power and voltage magnitude specified

# Test Systems
There are two test systems preprogrammed. To run both of them, use the command
```
runall
```
Viewing the contents of the `runall.m` file will show the order to call functions in.

# Data Inputs
Inputs are expected in two matrixes. Examples are availabe in the two test system files `tsa.m` and `tsb.m`.
**Branch Data**
Columns:
 - From Bus Number
 - To Bus Number
 - Branch Resistance
 - Branch Reactance
 - Branch Shunt Resistance (not sure I have terminology correct on this one)
 - Branch Shunt Capacitance (not sure I have terminology correct on this one)
 
**Bus Data**
Columns:
 - Bus Number
 - Type: 1 = slack, 2 = PQ, 3 = PV
 - Bus Generated Real Power: 0 if unknown
 - Bus Generated Reactive Power: 0 if unknown
 - Bus Real Power Load: 0 if unknown
 - Bus Reactive Power Load: 0 if unknown
 - Bus Volage Magnitude: set to start value if unknown (1.0 for flat start)
 - Bus Voltage Angle in radians: set to start value if unknown (0.0 for flat start)
 - Bus Conductance (G of the admittance Y=G+jB)
 - Bus Susceptance (B of the admittance Y=G+jB)

# Running NRPF
Once the bus and branch data are read in, the main Newton-Raphson Power Flow (NRPF) function can be called. It has several optional inputs shown in all caps:
```
[results]=nrpf(busdata,branchdata,PRINT_ITERS,THRESH,ITER_MAX,FREEZE_JAC)
[results]=nrpf(busdata,branchdata,PRINT_ITERS,THRESH,ITER_MAX)
[results]=nrpf(busdata,branchdata,PRINT_ITERS,THRESH)
[results]=nrpf(busdata,branchdata,PRINT_ITERS)
[results]=nrpf(busdata,branchdata)
```
 - `PRINT_ITERS` will print all iteration data if set to 1, defaults to 0
 - `THRESH` is the power mismatch threshold, defaults to 0.001
 - `ITER_MAX` is the maximum number of iterations, defaults to 10
 - `FREEZE_JAC` only calculates the jacobian the first time around. This was to answer a specific question in the final project really.

# Interpreting Results
The results returned from the nrpf function is a MATLAB `containers.Map` object. It contains the following keyed data:
 - `ybus` - ybus matrix
 - `pmatrix` - if PRINT_ITERS is set to 1, this contains the matrix that is printed for the last iteration
 - `iter_` - a nested map containing data for each iteration where the _ is the number of the iteration
    - `jacobian` - the jacobian for that iteration
    - `Pmm` - the real power mismatch for that iteration
    - `Qmm` - the reactive power mismatch for that iteration
    - `V` - the new voltage magnitude for that iteration
    - `T` - the new voltage angle (in radians) for that iteration 
    

# Sample Data Run
Get data from *Test System A* and run powerflow on it.
```
[busdata,branchdata]=tsa(); 
[results]=nrpf(busdata,branchdata);
```

Display the ybus matrix:
```
results('ybus')
```

Display the jacobian from the second iteration:
```
iter2=results('iter2');
iter2('jacobian')
```

Print all results data to the console:
```
print_nrpf(results);
```

# Regression Test
A regression test along with data for the test allows verifying that changes to the algorithm do not break it.
```
nrpf_test();
```
A successful run will print:
```
Regression test passed!
```
