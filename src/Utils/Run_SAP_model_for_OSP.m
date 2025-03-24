
function PROJECT_OSP = Run_SAP_model_for_OSP(PROJECT_OSP)
% Function Duties:
% This function runs the analysis of the SAP2000 model and retrieves all results 
% and variables, updating the PROJECT_OSP structure.
%
% INPUT:
%   PROJECT_OSP - Structure containing:
%       - PROJECT_OSP.config: Required configurations to run the model.
%       - PROJECT_OSP.geometry: Geometry structure obtained from read_geometry_sap_model.m.
%         The following variable is used:
%           - nodes (matrix of size nNodes x 4): Contains the names and coordinates 
%             of all joint objects (physical points, not meshed).
%
% OUTPUT:
%   PROJECT_OSP - Updated structure with the following fields:
%
%   PROJECT_OSP.geometry:
%       - dofs: Table of size (3 x nNodes) x 6 containing:
%           - Column "dofID": Number from 1 to 3 x nNodes.
%           - Columns U1, U2, U3: Set to 1 if the DOF measures in the corresponding direction.
%           - nodeLabel: Name of the point object to which the DOF is referred.
%           - nodeID: Number from 1 to nNodes (related to the column of the sensors variable).
%
%       - dofsElm: Table of size (6 x nNodesElm) x 9 containing:
%           - Column "dofID": Number from 1 to 6 x nNodesElm.
%           - Columns U1, U2, U3, R1, R2, R3: Set to 1 if the DOF measures in the corresponding direction.
%           - nodeLabel: Name of the point element to which the DOF is referred.
%           - nodeID: Number from 1 to nNodesElm (related to the column of the sensorsElm variable).
%           - Remark: if K, M matrices are properly read, the following 2
%           columns are added:
%              -> isRestrained: 0 if not restrained DOF, else 1
%              -> dofID_unrestrained: number from 1 to NunrestDOFs (NaN if
%              it is a restrained DOF)
%
%       - sensors: Matrix of size (3 x nNodes) x 4 containing:
%           - First column: Node ID from SAP2000 (a unique integer from 1 to nNodes, without jumps).
%             This ID is different from the node name, which belongs to the range 1 to N2 (where N2 >= nNodes). 
%             Some node names may be omitted.
%           - Columns 2-4: DOF representation, where each row corresponds to a DOF 
%             (e.g., [1, 0, 0] ? U1 (DOF in the x-direction)).
%
%       - sensorsElm: Matrix of size (6 x nNodesElm) x 4, analogous to "sensors", 
%         but related to all joint elements (i.e., all meshed points), not just joint objects.
%
%   PROJECT_OSP.modalprop:
%       - Mode_shape: Matrix of size (3 x nNodes, nmodes) containing only U1, U2, and U3 DOFs.
%       - Mode_shape_Elm: Matrix of size (6 x nNodesElm, nmodes), (U1 - R3
%       DOFs) for all joint elements
%       - Resonant_frequency: Vector of size nmodes.
%
%   PROJECT_OSP.matrices:
%       - M: Mass matrix for all joint elements (i.e., meshed points),
%       arranged w.r.t. dofID in dofsElm variable; having NaN values where
%       there is no information from that element (i.e. restrained nodes)
%       - K: Stiffness matrix for all joint elements (i.e., meshed points),
%       arranged w.r.t. dofID in dofsElm variable; having NaN values where
%       there is no information from that element (i.e. restrained nodes)
%       - joints: Table relating the mass and stiffness matrices originally
%       obtained by SAP2000 [used to rearrange M, K matrices and no further used]
%%
modalprop = [];
matrices = [];
%% Copy base database
file = PROJECT_OSP.config.SAP_model;
[filepath,name,ext] = fileparts(file);
if ~exist([filepath, filesep, 'log'], 'dir')
    mkdir([filepath, filesep, 'log'])
end
ofile = fullfile(filepath, 'log', 'Base_model_iter.xlsx');
ofilesdb = fullfile(filepath, 'log', 'Base_model_iter.sdb');
% List with the sheet names
% sheets = spreadsheetDatastore([pwd '\' ofile]);
status = copyfile(file,ofile);

%% Launch SAP analysis

%set the following flag to true to attach to an existing instance of the program otherwise a new instance of the program will be started
AttachToInstance = false(); % true(); %

% set the following flag to true to manually specify the path to SAP2000.exe
% this allows for a connection to a version of SAP2000 other than the latest installation
% otherwise the latest installed version of SAP2000 will be launched
SpecifyPath = false(); % true(); %

% if the above flag is set to true, specify the path to SAP2000 below
ProgramPath = PROJECT_OSP.config.SAP_Dir;
% full path to API dll
% set it to the installation folder
APIDLLPath = PROJECT_OSP.config.SAP_dll_Dir;


%% create API helper object

a = NET.addAssembly(APIDLLPath);
try
    helper = SAP2000v1.Helper;
    version_name = 'SAP2000v1';
    helper = NET.explicitCast(helper,[version_name,'.cHelper']);
catch
    helper = SAP2000v20.Helper;
    version_name = 'SAP2000v20';
    helper = NET.explicitCast(helper,[version_name,'.cHelper']);
end

if AttachToInstance
    % attach to a running instance of Sap2000
    SapObject = helper.GetObject('CSI.SAP2000.API.SapObject');
    SapObject = NET.explicitCast(SapObject,[version_name,'.cOAPI']);
    
else
    if SpecifyPath
        % create an instance of the SapObject from the specified path
        SapObject = helper.CreateObject(ProgramPath);
    else
        % create an instance of the SapObject from the latest installed SAP2000
        SapObject = helper.CreateObjectProgID('CSI.SAP2000.API.SapObject');
    end
    SapObject = NET.explicitCast(SapObject,[version_name,'.cOAPI']);
    % start Sap2000 application
    SapObject.ApplicationStart;
end
helper = 0;

%% hide Sap2000 application (faster execution)
% SapObject.Hide;
%% create SapModel object
SapModel = NET.explicitCast(SapObject.SapModel,[version_name,'.cSapModel']);


%% create SapModel object
File = NET.explicitCast(SapModel.File,[version_name,'.cFile']);

%% Identify original units
pre_units

%% load and existing model
%     File.OpenFile([pwd '\' ofile]);
File.OpenFile(ofile);
% unlock model%
ret = SapModel.SetModelIsLocked(false);


ret = SapModel.SetModelIsLocked(false);
if ~isfield(PROJECT_OSP.config,'Nmodes')
    PROJECT_OSP.config.Nmodes = 12;
end
nmodes = PROJECT_OSP.config.Nmodes;

%% SIMULATION
LoadPatterns = NET.explicitCast(SapModel.LoadPatterns,[version_name,'.cLoadPatterns']);
LoadCases = NET.explicitCast(SapModel.LoadCases,[version_name,'.cLoadCases']);
LC = NET.explicitCast(LoadCases.ModalEigen,[version_name,'.cCaseModalEigen']);
ret = LC.SetCase("MODAL");  % create the load case in case it does not exist
ret = LC.SetNumberModes("MODAL", nmodes, 1);

%% READ GEOMETRY
read_geometry_sap_model

PROJECT_OSP.geometry = geometry;

%% SET ANALYSIS OPTIONS FOR GENERATING K and M matrices
% Remark: the "correct" way would be to get the variables (SolverType,...)
% through GetSolverOption_3 and then to update changing only StiffCase; but
% variables are not getting updated with Get (I don't know why)
SolverType = 1; % Advanced Solver
SolverProcessType = 0; % Auto
NumberParallelRuns = 0; % Auto
ResponseFileSizeMaxMB = -1; % Auto
NumberAnalysisThreads = -1; % Auto
StiffCase = 'MODAL'; % CHANGE IF REQUIRED; NECESSARY TO BE ABLE TO READ K AND M MATRICES (TO OUTPUT .TXE, .TXM...)
Analyze = NET.explicitCast(SapModel.Analyze,[version_name,'.cAnalyze']);
ret = Analyze.SetSolverOption_3(SolverType, SolverProcessType, NumberParallelRuns, ResponseFileSizeMaxMB, NumberAnalysisThreads, StiffCase);

if ret == 1
    msg = 'Analysis options were not updated; .TXE, .TXM, .TXK files (used for M, K matrices) might not be generated';
    warning(msg)
end

%% run model (this will create the analysis model)
Analyze = NET.explicitCast(SapModel.Analyze,[version_name,'.cAnalyze']);

ret = Analyze.SetRunCaseFlag("All", false, true);
ret = Analyze.SetRunCaseFlag("MODAL", true);

ret = Analyze.RunAnalysis();

%% Get the geometry of joint ELEMENTS (i.e. of meshed objects)
PointElm = NET.explicitCast(SapModel.PointElm,[version_name,'.cPointElm']);
[ret, numPoints, MyName] = PointElm.GetNameList(0, NET.createArray('System.String', 1));

% Loop through each node by index and retrieve its name and coordinates
node_coordinates = cell(numPoints, 4);  % Columns: Node ID, X, Y, Z
for i = 1:numPoints
    pointName = MyName(i);
    % Get coordinates of the node (point)
    x = zeros(1, 1, 'double');
    y = zeros(1, 1, 'double');
    z = zeros(1, 1, 'double');
    [ret, x, y, z] = PointElm.GetCoordCartesian(pointName,x,y,z);  % Get Cartesian coordinates
    if ret == 0
        node_coordinates{i, 1} = char(pointName);  % Node ID
        node_coordinates{i, 2} = x;          % X Coordinate
        node_coordinates{i, 3} = y;          % Y Coordinate
        node_coordinates{i, 4} = z;          % Z Coordinate
    else
        warning('Could not retrieve coordinates for node %s.', pointName);
    end
end
PROJECT_OSP.geometry.nodesElm = node_coordinates;

%% Get modal results
AnalysisResults = NET.explicitCast(SapModel.Results,'SAP2000v1.cAnalysisResults');
AnalysisResultsSetup = NET.explicitCast(AnalysisResults.Setup,'SAP2000v1.cAnalysisResultsSetup');

NumberResults = 0;
Obj = NET.createArray('System.String',2);
ObjSta = NET.createArray('System.Double',1);
Elm = NET.createArray('System.String',2);
ElmSta = NET.createArray('System.Double',1);
ACase = NET.createArray('System.String',2);
LoadCase = NET.createArray('System.String',2);
StepType = NET.createArray('System.String',2);
StepNum = NET.createArray('System.Double',2);
Value = NET.createArray('System.Double',2);
PointElm = NET.createArray('System.String',2);
U1 = NET.createArray('System.Double',2);
U2 = NET.createArray('System.Double',2);
U3 = NET.createArray('System.Double',2);
R1 = NET.createArray('System.Double',2);
R2 = NET.createArray('System.Double',2);
R3 = NET.createArray('System.Double',2);
F1 = NET.createArray('System.Double',2);
F2 = NET.createArray('System.Double',2);
F3 = NET.createArray('System.Double',2);
M1 = NET.createArray('System.Double',2);
M2 = NET.createArray('System.Double',2);
M3 = NET.createArray('System.Double',2);
P = NET.createArray('System.Double',2);
V2 = NET.createArray('System.Double',2);
V3 = NET.createArray('System.Double',2);
T = NET.createArray('System.Double',2);
Period = zeros(1, 1, 'double');
Frequency = zeros(1, 1, 'double');
CircFreq = zeros(1, 1, 'double');
EigenValue = zeros(1, 1, 'double');
% ElmSta = NET.createArray('System.Double',2);
% ObjSta = NET.createArray('System.Double',2);
% ---- MODAL

ret = AnalysisResultsSetup.DeselectAllCasesAndCombosForOutput;
ret = AnalysisResultsSetup.SetCaseSelectedForOutput('MODAL');
[ret, NumberResults, Obj, Elm, ACase, StepType, StepNum, U1, U2, U3, R1, R2, R3] = AnalysisResults.ModeShape("ALL", SAP2000v1.eItemTypeElm.GroupElm, NumberResults, Obj, Elm, LoadCase, StepType, StepNum, U1, U2, U3, R1, R2, R3);
clear Mode_shape
%% A) MODAL RESULTS FOR POINT ELEMENTS (i.e. full mesh)
% Ensure that there are results
if NumberResults == 0
    [ret, NumberResults, Obj, Elm, ACase, StepType, StepNum, U1, U2, U3, R1, R2, R3] = AnalysisResults.ModeShape("All", SAP2000v1.eItemTypeElm.GroupElm, NumberResults, Obj, Elm, LoadCase, StepType, StepNum, U1, U2, U3, R1, R2, R3);
    if NumberResults == 0 % In case it is called All instead of ALL
        errordlg('A group named "ALL", containing all SAP2000 elements, is required. Please define this group and re-run the analysis.', 'Error');
        return
    end
end

% Preallocate
n_modes = StepNum(NumberResults);
n_dofs = NumberResults * 6/n_modes;
Mode_shape_Elm = zeros(n_dofs, n_modes); % Preallocating
sensorsElm = zeros(n_dofs, 7); % Preallocate with zeros
dofsElm = cell(n_dofs, 9); % Preallocate cells for table data

% Assign values
cont = 0;
contb = 0;
modeiter = 1;
geometry = PROJECT_OSP.geometry;
for i = 1:StepNum.Length
    node = char(Elm(i));
    nodesel = find(strcmp(geometry.nodesElm(:, 1), node)); % id number of the node in nodesElm
    if modeiter == StepNum(i)
        cont = cont+1;
    else
        cont = 1;
        modeiter = StepNum(i);
    end
    startIdx = (cont - 1) * 6 + 1;
    Mode_shape_Elm(startIdx:startIdx+5, StepNum(i)) = [U1(i), U2(i), U3(i), R1(i), R2(i), R3(i)];
    
    % Only process if it's the first step
    if StepNum(i) == 1
        for dofIdx = 1:6
            contb = contb + 1;
            sensorsElm(contb, :) = [nodesel, (1:6 == dofIdx)];
            logicalDofs = (1:6 == dofIdx);
            dofsElm(contb, :) = {contb, logicalDofs(1), logicalDofs(2), logicalDofs(3), logicalDofs(4), logicalDofs(5), logicalDofs(6), node, nodesel};
        end
    end
end
dofsElm = cell2table(dofsElm, 'VariableNames', {'dofID', 'U1', 'U2', 'U3', 'R1', 'R2', 'R3', 'nodeLabel', 'nodeID'});
%% MODAL RESULTS FOR POINT OBJECTS (i.e. points drawn)
% Preallocate memory for Mode_shape and Mode_shape_cand
n_modes = StepNum(NumberResults);
n_points = NumberResults/n_modes; % Number of data points
Mode_shape = zeros(3 * n_points, n_modes); % Preallocate Mode_shape array
Mode_shape_cand = zeros(3 * n_points, n_modes); % Preallocate Mode_shape_cand array
sensors = zeros(3 * n_points, 4);
dofs = cell(3 * n_points, 6);

% Assign values
cont = 0;
contb = 0;
modeiter = 1;
poscand = 0;
for i = 1:StepNum.Length
    if strncmp(char(Elm(i)), '~', 1) % Omit if it is a meshed point
        continue;
    end
    node = str2double(char(Elm(i)));
    nodesel = find(geometry.nodes(:, 1) == node);
    storecandidate = ~isempty(find(ismember(candiateNodes, nodesel), 1));
    if modeiter == StepNum(i)
        cont = cont + 1;
    else
        poscand = 0;
        cont = 1;
        modeiter = StepNum(i);
    end
    startIdx = (cont - 1) * 3 + 1;
    if storecandidate == 1
        poscand = poscand + 1;
        Mode_shape_cand(startIdx:startIdx + 2, StepNum(i)) = [U1(i); U2(i); U3(i)];
    end
    Mode_shape(startIdx:startIdx + 2, StepNum(i)) = [U1(i); U2(i); U3(i)];
    if StepNum(i) == 1
        for dofIdx = 1:3
            contb = contb + 1;
            sensors(contb, :) = [nodesel, (1:3 == dofIdx)];
            logicalDofs = (1:3 == dofIdx);
            dofs(contb, :) = {contb, logicalDofs(1), logicalDofs(2), logicalDofs(3), node, nodesel};
        end
    end
end

% Maintain only the first contb rows of dofs, Mode_shape, and sensors
dofs = cell2table(dofs(1:contb, :), 'VariableNames', {'dofID', 'U1', 'U2', 'U3', 'nodeLabel', 'nodeID'});
Mode_shape = Mode_shape(1:contb, :);
sensors = sensors(1:contb, :);
%% Retrieve rest of modal properties
[ret, NumberResults, ACase, StepType, StepNum, Period, Frequency,CircFreq, EigenValue] = AnalysisResults.ModalPeriod(NumberResults, LoadCase, StepType, StepNum, Period, Frequency, CircFreq, EigenValue);
clear Resonant_frequency
for i=1:StepNum.Length
    Resonant_frequency(i) = Frequency(i);
end
if storecandidate == 0
    Mode_shape_cand = Mode_shape; % does not include meshed points
end

% Save data
modalprop.Resonant_frequency = Resonant_frequency;
modalprop.Mode_shape = Mode_shape;
modalprop.Mode_shape_cand = Mode_shape_cand;
modalprop.Mode_shape_Elm = Mode_shape_Elm;
PROJECT_OSP.modalprop = modalprop;

PROJECT_OSP.geometry.sensors = sensors;
PROJECT_OSP.geometry.sensorsElm = sensorsElm;
PROJECT_OSP.geometry.dofs = dofs;
PROJECT_OSP.geometry.dofsElm = dofsElm;


%% Get K and M matrices
dofsElm = PROJECT_OSP.geometry.dofsElm;
PROJECT_OSP.geometry.dofsElm = dofsElm;

try
    if size(dofsElm,1)<PROJECT_OSP.config.K_M_matrices.MaxDOFs_K_M
        FilePath_joint = strrep(ofile, '.xlsx', '.TXE');
        joints = get_joint_matrix_index(FilePath_joint);
        FilePath_K = strrep(ofile, '.xlsx', '.TXK');
        K = get_M_K_matrix(FilePath_K);
        FilePath_M = strrep(ofile, '.xlsx', '.TXM');
        M = get_M_K_matrix(FilePath_M);
        
        % Find correspondance between sensors and the joints in SAP2000
        [K_rearranged, correspondance] = arrange_M_K_matrix(dofsElm, joints, K);
        [M_rearranged, correspondance] = arrange_M_K_matrix(dofsElm, joints, M);
        
        % Frequency check (works fine!)
        %f = diag(sqrt((Mode_shape_Elm' * K_rearranged * Mode_shape_Elm)/(Mode_shape_Elm' * M_rearranged * Mode_shape_Elm))/(2*pi))
        
        % Save a variable indicating the restrained DOFs
        restrainedDofs = find(all(K_rearranged == 0, 2));
        dofsElm.isRestrained = zeros(size(K_rearranged,1), 1);
        dofsElm.isRestrained(restrainedDofs) = 1;
        unrestrainedDofs = find(dofsElm.isRestrained == 0);
        dofsElm.dofID_unrestrained = NaN*ones(size(K_rearranged,1),1);
        dofsElm.dofID_unrestrained(unrestrainedDofs) = 1:length(unrestrainedDofs);
        PROJECT_OSP.geometry.dofsElm = dofsElm;
        PROJECT_OSP.config.K_M_matrices.success = 1;  % affects fill_tables_OSP
    else
        disp('The system is too large to read the stiffness and mass matrices!!');
        joints = [];
        K_rearranged = [];
        M_rearranged = [];
        PROJECT_OSP.config.K_M_matrices.success = -1;  % affects fill_tables_OSP
    end
catch   % In case the reading of the matrices fails
    disp('Error reading stiffness and mass matrices; only EFI will be available');
    joints = [];
    K_rearranged = [];
    M_rearranged = [];
    PROJECT_OSP.config.K_M_matrices.success = 0;  % affects fill_tables_OSP
end
%% Save data
matrices.joints = joints;
matrices.M = M_rearranged;
matrices.K = K_rearranged;
PROJECT_OSP.matrices = matrices;

%% close Sap2000
SapObject.ApplicationExit(false());
end
