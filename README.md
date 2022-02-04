# Estimate Human Stiffness, Damping, and Intention in a Collaborative Carrying Scenario - Master Thesis
This is my Master Thesis done at the Southern Danish University.


# Setting up MATLAB
Programs and packages (I have install to make it run):
* MATLAB R2021b *(newer version should also work)*
* Simulink
* Simulink 3D Animation
* Phase Array System Toolbox
* Simscape Multibody
* Simscape
* Computer Vision Toolbox
* Simulink Design Optimization
* Signal Processing Toolbox
* Simulink Control Design
* Robotics System Toolbox
* Optimization Toolbox
* Navigation Toolbox
* Image Processing Toolbox
* DSP System Toolbox
* Control System Toolbox
* MATLAB Support for MinGW-w64 C/C++ Compiler *(I use MinGW64 Compiler (C) on Windows)*

*All packages may not be necessary.*

When opening the simulink file [scene.slx](MATLAB/scene.slx) go to MODELLING > Mode Explorer > scene > Model Workspace, then press browse and make sure [scene_parameters.m](MATLAB/scene_parameters.m) is chosen and finally press "Reinitalize from Source".

To ensure that the correct environment file is chosen, double click on the VR Sink block, goto Simulation > Block Parameters... > browse, chose the [scene_environment.x3d](MATLAB/scene_environment.x3d) file. Press Apply and OK.