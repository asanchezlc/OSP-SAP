%% read_geometry_sap_model.m
% -------------------------------------------------------------------------
% SCRIPT DUTIES:
% This script retrieves geometric data from a SAP2000 model, including:
%
% 1) Nodes Information:
%     - `nodes` (matrix of size nNodes x 4): Contains the names and coordinates
%       of all point objects (physical points, not meshed).
%
% 2) Beam (Line) Elements:
%     - `Lines` (matrix of size nLines x 2): Each row contains the start and end node IDs
%       of a beam element.
%     - `Lines_Id` (vector of size nLines x 1): Stores the name (ID) of each line 
%       (corresponding start and end nodes are in `Lines`).
%
% 3) Candidate Nodes:
%     - `candiateNodes` (vector of size Ncand x 1): 
%       - If the "Candidate_DOFs" group exists, it retrieves its nodes.
%       - Otherwise, it retrieves nodes from "Setup_i" groups.
%       - if References exist, it includes them
%
% 4) Setups:
%     - `Nsetups` (scalar): Number of node groups named "Setup_i".
%     - `Setup_i` variables (`geometry.Setup_1`, `geometry.Setup_2`, etc.):
%       - Each contains the nodes in a specific setup group.
%
% 5) Reference Nodes:
%     - `References` (matrix of size nRef x 4): Nodes that have a load assigned
%       in the "References" load pattern (if defined).
%       - Column 1: Node ID
%       - Columns 2-4: Direction of applied load ([1 0 0], [0 1 0], or [0 0 1])

%% Coordinates of nodes
PointObj = NET.explicitCast(SapModel.PointObj,[version_name,'.cPointObj']);
MyName = NET.createArray('System.String', 1);
[ret, numPoints, MyName] = PointObj.GetNameList(0, MyName);

% Initialize cell array to store node coordinates
node_coordinates = cell(numPoints, 4);  % Columns: Node ID, X, Y, Z

% Loop through each node by index and retrieve its name and coordinates
for i = 1:numPoints
    pointName = MyName(i);
    % Get coordinates of the node (point)
    x = zeros(1, 1, 'double');
    y = zeros(1, 1, 'double');
    z = zeros(1, 1, 'double');
    [ret, x, y, z] = PointObj.GetCoordCartesian(pointName,x,y,z);  % Get Cartesian coordinates
    if ret == 0
        node_coordinates{i, 1} = str2double(char(pointName));  % Node ID
        node_coordinates{i, 2} = x;          % X Coordinate
        node_coordinates{i, 3} = y;          % Y Coordinate
        node_coordinates{i, 4} = z;          % Z Coordinate
    else
        warning('Could not retrieve coordinates for node %s.', pointName);
    end
end

%% Beam elements
FrameObj = NET.explicitCast(SapModel.FrameObj,[version_name,'.cFrameObj']);
MyName = NET.createArray('System.String', 1);
[ret, numFrames, MyName] = FrameObj.GetNameList(0, MyName);

% Initialize cell array
frame_connectivity = cell(numFrames, 3);  % Columns: Node ID, X, Y, Z

% Loop through each node by index and retrieve its name and coordinates
for i = 1:numFrames
    Framename = MyName(i);
    % Get coordinates of the node (point)
    node1 = System.String(' ');
    node2 = System.String(' ');
    [ret, node1, node2] = FrameObj.GetPoints(Framename,node1,node2);  % Get Cartesian coordinates
    if ret == 0
        frame_connectivity{i, 1} = str2double(char(Framename));  % Node ID
        frame_connectivity{i, 2} = str2double(char(node1));          % node1
        frame_connectivity{i, 3} = str2double(char(node2));          % node2
    else
        warning('Something went wrong');
    end
end

geometry.nodes = cell2mat(node_coordinates);
geometry.Lines = cell2mat(frame_connectivity(:,2:end));
geometry.Lines_Id = frame_connectivity(:,1);


%% Get nodes candidates
groupName = 'Candidate_DOFs';
PointObj = NET.explicitCast(SapModel.PointObj,[version_name,'.cPointObj']);
NumberNames = 0;
NumberGroups = 0;
NodeNames = NET.createArray('System.String', 1000);  % Preallocate .NET string array
[ret, NumberNames, NodeNames] = PointObj.GetNameList(NumberNames, NodeNames);
NumberNames = double(NumberNames);

% Initialize cell array to store nodes belonging to the specified group
candiateNodes = [];

% Loop through each node and check if it belongs to the specified group
for i = 1:NumberNames
    nodeName = char(NodeNames(i));  % Convert .NET string to MATLAB string
    
    % Check the group membership of the node
    [ret, NumberGroups, nodeGroups] = PointObj.GetGroupAssign(nodeName, NumberGroups, MyName);
    if ret == 0
        % Convert the returned groups to a MATLAB string array
        nodeGroups_f = cell(NumberGroups, 1);
        for j = 1:NumberGroups
            nodeGroups_f{j} = char(nodeGroups(j));  % Convert to MATLAB string
        end
        
        % Check if the specified group name is in the list of groups
        if any(strcmp(nodeGroups_f, groupName))
            candiateNodes(end + 1) = str2double(nodeName);  % Add node to the list if in the group
        end
    else
        warning('Could not retrieve group information for node %s.', nodeName);
    end
end

geometry.candiateNodes = candiateNodes;
if length(candiateNodes) > 0
    PROJECT_OSP.config.SAP2000_groups.existsCandidateDOFs = 1;
else
    PROJECT_OSP.config.SAP2000_groups.existsCandidateDOFs = 0;
end

%% Setups
PROJECT_OSP.config.SAP2000_groups.existsSetups = 0;
cond = 1;
cont_setups = 1;
while cond == 1 % Saves the nodes in Setup_i in the variable geometry.Setup_i
    groupName = ['Setup_',int2str(cont_setups)];
    PointObj = NET.explicitCast(SapModel.PointObj,[version_name,'.cPointObj']);
    NumberNames = 0;
    NumberGroups = 0;
    NodeNames = NET.createArray('System.String', 1000);  % Preallocate .NET string array
    [ret, NumberNames, NodeNames] = PointObj.GetNameList(NumberNames, NodeNames);
    NumberNames = double(NumberNames);
    
    % Initialize cell array to store nodes belonging to the specified group
    candiateNodes_Setup_i = [];
    
    % Loop through each node and check if it belongs to the specified group
    for i = 1:NumberNames
        nodeName = char(NodeNames(i));  % Convert .NET string to MATLAB string
        
        % Check the group membership of the node
        [ret, NumberGroups, nodeGroups] = PointObj.GetGroupAssign(nodeName, NumberGroups, MyName);
        if ret == 0
            % Convert the returned groups to a MATLAB string array
            nodeGroups_f = cell(NumberGroups, 1);
            for j = 1:NumberGroups
                nodeGroups_f{j} = char(nodeGroups(j));  % Convert to MATLAB string
            end
%             nodeGroups_f
            % Check if the specified group name is in the list of groups
            if any(strcmp(nodeGroups_f, groupName))
                candiateNodes_Setup_i(end + 1) = str2double(nodeName);  % Add node to the list if in the group
            end
        else
            warning('Could not retrieve group information for node %s.', nodeName);
        end
    end
    
    if ~isempty(candiateNodes_Setup_i)
        eval(['geometry.Setup_',int2str(cont_setups),' = candiateNodes_Setup_i;']);
        cont_setups = cont_setups+1;
        PROJECT_OSP.config.SAP2000_groups.existsSetups = 1;
    else
        cond = 0;
    end
end
geometry.Nsetups = cont_setups-1;

count_ref = 1;
References = [];
if cont_setups > 1  % Look for references
    % Retrieve load information for joints (points)
    [ret, NumberNames, NodeNames] = PointObj.GetNameList(NumberNames, NodeNames);
    for i = 1:NodeNames.Length
        pointName = NodeNames(i);
        NumberItems = 0; %
        PointName = NET.createArray('System.String', 2);
        LoadPat = NET.createArray('System.String', 2);
        LCStep = NET.createArray('System.Int32', 2);
        CSys = NET.createArray('System.String', 2);
        F1 = NET.createArray('System.Double', 2);
        F2 = NET.createArray('System.Double', 2);
        F3 = NET.createArray('System.Double', 2);
        M1 = NET.createArray('System.Double', 2);
        M2 = NET.createArray('System.Double', 2);
        M3 = NET.createArray('System.Double', 2);
        
        % Retrieve all point loads
        [ret,NumberItems, PointName, LoadPat, LCStep, CSys, F1, F2, F3, M1, M2, M3] = PointObj.GetLoadForce(char(pointName), NumberItems, PointName, LoadPat, LCStep, CSys, F1, F2, F3, M1, M2, M3, SAP2000v1.eItemType.Objects);
        
        if NumberItems > 0
            for ijij = 1:LoadPat.Length
                if strcmp(char(LoadPat(ijij)),'References')
                    if F1(ijij) == 1
                        vector = [1,0,0];
                        References(count_ref,1) = str2double(char(PointName(1)));
                        References(count_ref,2:4) = vector;
                        count_ref = count_ref+1;
                    end
                    if F2(ijij) == 1
                        vector = [0,1,0];
                        References(count_ref,1) = str2double(char(PointName(1)));
                        References(count_ref,2:4) = vector;
                        count_ref = count_ref+1;
                    end
                    if F3(ijij) == 1
                        vector = [0,0,1];
                        References(count_ref,1) = str2double(char(PointName(1)));
                        References(count_ref,2:4) = vector;
                        count_ref = count_ref+1;
                    end
                end
            end
        end
    end
    geometry.References = References;
    
    % Create candiateNodes_Setups (all nodes in setups) and insert references
    candiateNodes_Setups = [];
    for i = 1:geometry.Nsetups % Saves all nodes in geometry.Setup_i in candiateNodes_Setups
        candiateNodes_Setups = [candiateNodes_Setups,eval(['geometry.Setup_',int2str(i)'])];
    end
    if size(References,1)>0  % add references to candiate nodes
        candiateNodes_Setups = [candiateNodes_Setups,geometry.References(:,1)']';
        candiateNodes_Setups = unique(candiateNodes_Setups);
    end
    candiateNodes_Setups = candiateNodes_Setups.';
    geometry.candiateNodes_Setups = candiateNodes_Setups;  % save all setup nodes as candidates
else
    geometry.References = [];
    geometry.candiateNodes_Setups = [];
end

if ~isempty(geometry.References)
    if size(geometry.References,1)>nmodes
        f = warndlg(['The number of references is larger than the number of modes! ',int2str(size(geometry.References,1)-nmodes),' have been omitted'],'Warning');
        geometry.References = geometry.References(1:nmodes,:);
    end
end


