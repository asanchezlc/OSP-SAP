


function [] = create_references_SAP(FileName,PROJECT_OSP,nref) 
%% Function Duties
% Create references in a SAP2000 model; references are the sensors that
% won't move in a multi-setup AVT.
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
ret = LC.SetNumberModes("MODAL", nmodes, 1);

%% Configure "References" load pattern
LoadPatternNum = 0; % Define the variable that will hold the number of load pattern names
LoadPatternNames = NET.createArray('System.String', 1); % Create an empty .NET string array with an initial size of 1
[ret, LoadPatternNum, LoadPatternNames] = LoadPatterns.GetNameList(LoadPatternNum, LoadPatternNames);

refPatternAdded = 0;
if LoadPatternNum==1 & LoadPatternNames(1) == "References" % Delete the References and create a new one
       ret = LoadPatterns.Add('aux', SAP2000v1.eLoadPatternType.Dead, 0, false())
       ret = LoadCases.Delete(LoadPatternNames(1))
       ret = File.Save(FileName)
       LoadPatternNames = NET.createArray('System.String', 1);
       LoadCases = NET.explicitCast(SapModel.LoadCases,[version_name,'.cLoadCases']);
       ret = LoadPatterns.Delete("References")
       ret = LoadPatterns.Add('References', SAP2000v1.eLoadPatternType.Dead, 0, false())
       if ret
           refPatternAdded = 1;
       end
       ret = LoadCases.Delete('aux')
       ret = LoadPatterns.Delete('aux')
else
    for i=1:LoadPatternNum
       if LoadPatternNames(i) == "References"
           ret = LoadCases.Delete(LoadPatternNames(i));
           ret = LoadPatterns.Delete(LoadPatternNames(i));
           ret = LoadPatterns.Add('References', SAP2000v1.eLoadPatternType.Dead, 0, false());
           if ret
               refPatternAdded = 1;
           end
           break
       end
    end
end

if ~refPatternAdded
    ret = LoadPatterns.Add('References', SAP2000v1.eLoadPatternType.Dead, 0, false());
end

%% Assign forces in References load pattern
% For references, select the sensors with highest Ed
sensorsOSP = PROJECT_OSP.geometry.sensorsOSP;
for i=1:length(PROJECT_OSP.OSP_results.LISTADO_SETUP{7,1})
    if length(PROJECT_OSP.OSP_results.LISTADO_SETUP{7,1}{i}) == length(sensorsOSP(:,1))
        index = i;
        break
    end
end
EdValues = PROJECT_OSP.OSP_results.LISTADO_SETUP{7,1}{index};
[~, sortedIndices] = sort(-EdValues);
references = sensorsOSP(sortedIndices(1:nref),:);

PointObj = NET.explicitCast(SapModel.PointObj,[version_name,'.cPointObj']);
PointLoadValue = NET.createArray('System.Double',6);

for ij=1:nref
    for i = 1 : 6
        PointLoadValue(i) = 0.0;
    end
    PointLoadValue(1) = references(ij,2);
    PointLoadValue(2) = references(ij,3);
    PointLoadValue(3) = references(ij,4);
    ret = PointObj.SetLoadForce(num2str(references(ij,1)), 'References', PointLoadValue);
end

%% SAVE
ret = File.Save(FileName);

%% CLOSE
ret = SapObject.ApplicationExit(false());



end