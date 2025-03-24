% File Duties
% 1) If mass matrix was read, enables 4 OSP methods, otherwise only EFI
% 2) Populates table showing mode shapes frequencies and boxes to select them
% 3) Populates nodes table

%% 1) OSP METHOD
handles.popupmenu3.Value = 1;
if PROJECT_OSP.config.K_M_matrices.success ~= 1
    text_opt(1) =  {'EFI'  };
    if PROJECT_OSP.config.K_M_matrices.success == -1
        message = sprintf('Unable to read stiffness and mass matrices due to the high system size (more than %d DOFs); only the EFI method will be available.', ...
    PROJECT_OSP.config.K_M_matrices.MaxDOFs_K_M-1);
    elseif PROJECT_OSP.config.K_M_matrices.success == 0
        message = 'Error reading stiffness and mass matrices; only EFI method will be available' ;
    end
    warndlg(message, 'OSP - Available algorithms')
else
    text_opt(1) =  {'EFI'  };
    text_opt(2) =  {'KEMRO'};
    text_opt(3) =  {'SEMRO'};
    text_opt(4) =  {'EFIWM'};
end
handles.popupmenu3.String = text_opt;

%% 2) Mode shapes table
modenumber = 1:1:nmodes;
modenumber = modenumber';
Select = logical(ones(nmodes,1));
Frequencies = PROJECT_OSP.modalprop.Resonant_frequency';
T = table(modenumber,Select,Frequencies);
PROJECT_OSP.config.Table = T;

handles.uitable1.Data = table2cell(T);

handles.text12.String = num2str(PROJECT_OSP.geometry.Nsetups);
handles.text13.String = num2str(size(PROJECT_OSP.geometry.References,1));
handles.text11.String = num2str(numel(PROJECT_OSP.geometry.nodes,1));

%% 3) Nodes table
handles.uitable3.Data = PROJECT_OSP.geometry.nodes;
handles.popupmenu7.String = {};
if PROJECT_OSP.geometry.Nsetups>0
    handles.popupmenu7.String(1) = {'Nodes'};
    for ijji = 1:PROJECT_OSP.geometry.Nsetups
        handles.popupmenu7.String(ijji+1) = {['Setup-',int2str(ijji)]};
    end
    handles.popupmenu7.String(length(handles.popupmenu7.String)+1) = {'References'};
else
    handles.popupmenu7.String = {'Nodes'};
end
handles.popupmenu7.Value = 1;