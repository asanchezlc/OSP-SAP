%% loadproject_OSP.m
% File duties: it is initialized when the GUI is launched

%%
if isfield(PROJECT_OSP,'config')
    if isfield(PROJECT_OSP.config,'SAP_model')
        handles.pushbutton1.String =  PROJECT_OSP.config.SAP_model;
        set(handles.pushbutton12,'enable','on');
    else
        set(handles.pushbutton12,'enable','off');
    end
    if isfield(PROJECT_OSP.config,'SAP_Dir')
        handles.pushbutton2.String = PROJECT_OSP.config.SAP_Dir;
    end
    if isfield(PROJECT_OSP.config,'SAP_dll_Dir')
        handles.pushbutton3.String = PROJECT_OSP.config.SAP_dll_Dir;
    end
    if isfield(PROJECT_OSP.config,'Table')
        handles.uitable1.Data = table2cell(PROJECT_OSP.config.Table);
    end
    if ~isfield(PROJECT_OSP.config,'Target_DOFs')
        PROJECT_OSP.config.Target_DOFs = [1,1,1];
    end
    if isfield(PROJECT_OSP.config,'Table')
        handles.radiobutton1.Value = PROJECT_OSP.config.Target_DOFs(1);
        handles.radiobutton2.Value = PROJECT_OSP.config.Target_DOFs(2);
        handles.radiobutton3.Value = PROJECT_OSP.config.Target_DOFs(3);
    end
end

if isfield(PROJECT_OSP,'config')
    if isfield(PROJECT_OSP.config,'nmodes')
        handles.edit2.String = int2str(PROJECT_OSP.config.nmodes);
    end
end

if isfield(PROJECT_OSP,'OSP_results')
%     set(handles.popupmenu1,'visible','off')
    set(handles.popupmenu2,'visible','off')
    set(handles.slider1,'visible','off')
    set(handles.togglebutton2,'visible','on')
end
if isfield(PROJECT_OSP,'geometry')
    if isfield(PROJECT_OSP.geometry,'Nsetups')
        if PROJECT_OSP.geometry.Nsetups>0
            set(handles.popupmenu6,'visible','on');
            handles.popupmenu6.String = {};
            for ij = 1:PROJECT_OSP.geometry.Nsetups
                handles.popupmenu6.String(ij) = {['Setup ',int2str(ij)]};
            end
            handles.popupmenu6.Value = 1;
        end
    else
        PROJECT_OSP.geometry.Nsetups = 0;
    end
end
if isfield(PROJECT_OSP,'config')
    if isfield(PROJECT_OSP.config,'method')
        handles.text15.String = PROJECT_OSP.config.method;
    end
end

if isfield(PROJECT_OSP,'OSP_results')  % EGM - 21_11_24
    set(handles.pushbutton7,'enable','on');
    set(handles.pushbutton21,'enable','on');
    if isfield(PROJECT_OSP.OSP_results,'LISTADO_SETUP')
        if size(PROJECT_OSP.OSP_results.LISTADO_SETUP,2)>1
            nsetups = size(PROJECT_OSP.OSP_results.LISTADO_SETUP,2);
            for i = 1:nsetups
                eval(['set(handles.radiobutton',int2str(3+i),',''visible'',''on'');'])
            end
        end
    end
end

if isfield(PROJECT_OSP,'Style_Options')
    if ~isfield(PROJECT_OSP.Style_Options.styleplot,'Plotsetups')
        PROJECT_OSP.Style_Options.styleplot.Plotsetups = ones(PROJECT_OSP.geometry.Nsetups,1);
    end
end

if isfield(PROJECT_OSP,'geometry')
    if isfield(PROJECT_OSP.geometry,'References')
        if ~isempty(PROJECT_OSP.geometry.References)
            set(handles.radiobutton27,'visible','on');
        end
    end
end

%% PLOT

if isfield(PROJECT_OSP,'geometry')
    % Plot geometry
    
    axis(handles.axes2,'equal');
    view(handles.axes2,3)
    plot_geometry_modes(handles.axes2,PROJECT_OSP,0,1,0);
    
    
    if isfield(PROJECT_OSP.geometry,'candiateNodes')
        set(handles.pushbutton6,'enable','on');
    end
    
    if isfield(PROJECT_OSP,'modalprop')
        nmodes = PROJECT_OSP.config.Nmodes;
        for i=1:nmodes
            text(i) = {['Mode ',int2str(i)]};
        end
        
        handles.popupmenu2.String = text;
        set(handles.popupmenu1,'enable','on')
        %         set(handles.popupmenu2,'enable','on')
        
        h = rotate3d;
        h.Enable = 'on';
        setAllowAxesRotate(h,handles.axes2,true);
        setAllowAxesRotate(h,handles.axes1,false);
    end
end


axis off

% Create the 3 arrows for the coordinates [they will be children of axes3]
axes(handles.axes3);
children = get(handles.axes3, 'children');
delete(children);

hold(handles.axes3,'on')
daspect(handles.axes3,[1 1 1])
vert = [0 0 0;0.2 0 0;0.2 0.2 0;0 0.2 0;0 0 0.2;0.2 0 0.2;0.2 0.2 0.2;0 0.2 0.2];
fac = [1 2 6 5;2 3 7 6;3 4 8 7;4 1 5 8;1 2 3 4;5 6 7 8];
patch('Vertices',vert,'Faces',fac,'FaceVertexCData',summer(6),'EdgeCOlor','none','FaceColor','flat')
% arrow3([0,0,0],[0.7,0,0],'-r2',4,8)
% arrow3([0,0,0],[0,0.7,0],'-b2',4,8)
% arrow3([0,0,0],[0,0,0.7],'-g2',4,8)
arrow3([0,0,0],[0.7,0,0],'-g2',4,8)
arrow3([0,0,0],[0,0.7,0],'-b2',4,8)
arrow3([0,0,0],[0,0,0.7],'-r2',4,8)
hold off
xlim([-0.1,1.3])
ylim([-0.1,1.3])
zlim([-0.1,1.3])
axis off
drawnow

link = linkprop([handles.axes2,handles.axes3],{'View'});
setappdata(hObject,'StoreTheLink',link);
