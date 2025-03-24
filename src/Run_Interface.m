%% Run_Interface.m
% Main function which is executed to run the OSP-SAP interface

% -----------------------------------------------------------------------------------------------------------
% OSP-SAP: A MATLAB graphical user interface for optimal sensor placement using SAP2000
% Authors
% Antonio L\'{o}pez-Cuervo, Antonio S., Garc\'{i}a-Mac\'{i}as, Enrique, Castro-Triguero, Rafael, and Chiach\'{i}o-Ruano, Juan.
% February, 2025. 
%
% Download the latest release from [Github](https://github.com/asanchezlc/OSP-SAP).
%
% If you use OSP-SAP in your research, please cite:
% @article{yourcitation, author = {L\'{o}pez-Cuervo, Antonio S. and Garc\'{i}a-Mac\'{i}as, Enrique and Castro-Triguero, Rafael and Chiach\'{i}o-Ruano, Juan}, title = {OSP-SAP: A MATLAB graphical user interface for optimal sensor placement using SAP2000}, journal = {SoftwareX}, year = {2025}, doi = {--} } -->
% -----------------------------------------------------------------------------------------------------------


function Run_Interface()
    clear
    clc

    addpath(genpath('Algorithms'));
    addpath(genpath('Utils'));

    % Default Path Addresses
    % Path to SAP2000
    global PROJECT_OSP;
    PROJECT_OSP.config.SAP_Dir = 'C:\Program Files\Computers and Structures\SAP2000 23\SAP2000.exe';
    % Full path to API dll
    PROJECT_OSP.config.SAP_dll_Dir = 'C:\Program Files\Computers and Structures\SAP2000 23\SAP2000v1.dll';
    % Target DOFs
    PROJECT_OSP.config.Target_DOFs = [1,1,1];
    % Max. number of DOFs allowed for K, M matrices
    PROJECT_OSP.config.K_M_matrices.MaxDOFs_K_M = 10000;
    
    assignin('base', 'PROJECT_OSP', PROJECT_OSP);

    % Run GUI
    OSP_GUI
end