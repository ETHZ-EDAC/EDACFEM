# EDACFEM

#### Short Description

Toolkit for MATLAB-based FEM calculations developed by the Engineering Design and Computing Laboratory (EDAC) at ETH Zurich.

#### Introduction

This work provides a linear truss and beam FE simulation environment written in MATLAB. The simulation environment supports linear truss elements, Euler-Bernoulli beam elements, and Timoshenko beam elements. It further supports the introduction of global accelerations such as gravity and truss buckling analysis. A variety of input methods are supported, these are specifically tailored towards simplifying the integration of the FE simulation environment in numerical optimization schemes. The code distinguishes itself through its fast simulation speeds even for large beam and truss structures in both 2D and 3D. With this environment, researchers and design practitioners can easily simulate the mechanical response of complex bar structures without the need for interfacing with commercial FE software through cumbersome APIs.

#### Project Layout

- `lib/elements`: contains beam and truss element implementations and solvers
- `lib/general`: contains helper functions for simulation and input
- `lib/plot`: contains plotting functions
- `src/examples`: set of examples showing the different input types
- `FEM_toolkit_examples.m`: file to run the examples provided
- `config.m`: file to configure the MATLAB path to include the toolbox

#### Requirements

Matlab 2020b or higher is required.

The additional package requirements for the beam calculations are:
- `MATLAB Parallel Computing Toolbox`

#### Installation

To run the toolbox, it only needs to be added to the MATLAB path. A configuration script `config.m` is provided to automate this step. This config script has three options as shown in `FEM_toolkit_examples.m`. 
- `permanent`: permanently adds the current toolbox location to the MATLAB path.
- `temp`: adds the current toolbox location to the MATLAB path until restart.
- `pass`: do nothing, user must manually add the toolbox to the MATLAB path.

#### Examples

To run the provided examples, just run the provided MATLAB script `FEM_toolkit_examples.m`.

#### Problem User Inputs

| Group | Name | Size | Unit | Description|
|----------|:----------:|:----------:|:----------:|----------|
| Geometry |	**p** |	[n x 2] <br/> [n x 3] |	mm |	Nodal coordinates of *n* nodes in 2D or 3D. |
| Geometry |	**b** |	[m x 2] |	- |	List of m pairs of node IDs connected by elements. |
| Load / Boundary |	**F**	| [i x 6] |	N <br/> Nmm <br/> mm <br/> rad |	List of *i* prescribed loads/moments/displacements/rotations in the form [ID type X Y Z mag]. See additional information in the section below for specifics.|
| Load / Boundary |	**C** |	[j x DOF] |	- |	List of *j* restricted displacements where DOF is the number of possible displacements and rotations dependent on the element and problem setting. For each DOF, the DOF can be fixed with an entry of 1. |
| Element Properties | *E* |	1 or m |	MPa |	Elastic modulus for all elements or each individual element. |
| Element Properties |	*A* |	1 or m |	mm<sup>2</sup> |	Cross-sectional area for all elements or each individual element. |
| Element Properties |	*ρ* |	1 or m |	t/mm<sup>3</sup> |	Density for all elements or each individual element. Only further used if selfweight is active. |
| Element Properties |	*ν* |	1 or m |	- |	Poisson’s ratio for all elements or each individual element. Only used for beam structures. |
| Options |	*elemType* |	- |	- |	Provide type ‘truss’ or type ‘beam’ |
| Options |	*elemSubtype* |	- |	- |	Provide type ‘linear’ for truss and type ‘eulerbernoulli’ or ‘timoshenko’ for beams. |
| Options |	*selfweight* |	Boolean |	- |	Toggle if structure shall be evaluated under selfweight |
| Options |	*g* |	[1 x 1] <br/> [1 x 3] |	mm/s<sup>2</sup> |	Gravity constant or gravity vector. Per default, the gravity points in negative z direction. Only needed if selfweight is active. |
| Options |	*Buckling* |	Boolean |	- |	Toggle if buckling evaluation shall be performed. Only supported for truss structures. |
| Options |	*Shape* |	- |	- |	Cross-sectional shape of the elements. Only ‘circle’ supported. Only needed if buckling is active. |

#### Boundary Conditions and Loads

- **Trusses:**
  - **C (2D):** [id X Y]
  - **C (3D):** [id X Y Z]
  - **F (2D):** [id type X Y 0 mag]
  - **F (3D):** [id type X Y Z mag]
  - **type:** 1: force, [&nbsp;], 3: displacement, [&nbsp;]

- **Beams:**
  - **C (3D):** [id X Y Z Alpha Beta Gamma] 
  - **F (3D):** [id type X Y Z mag]
  - **type:** 1: force, 2: moment, 3: displacement, 4: rotation

#### Authors

- Dr. Tino Stankovic 
- Dr. Tian 'Tim' Chen
- Dr. Thomas S. Lumpe 
- Joël N. Chapuis 
- Marc Wirth
- Andreas Walker
- Jonas Schwarz