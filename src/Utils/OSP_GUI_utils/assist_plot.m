%% assist_plot.m
% File used to assist the plot of geometry on the GUI

%%
xlim(handles.axes2,'auto');
ylim(handles.axes2,'auto');
zlim(handles.axes2,'auto');

if strcmp(handles.popupmenu1.String(handles.popupmenu1.Value),'Modal Analysis')
    set(handles.slider1,'visible','on')
    set(handles.pushbutton13,'enable','on')
    set(handles.popupmenu2,'visible','on');
    set(handles.popupmenu2,'enable','on');
    if isequal(cell2mat(handles.popupmenu1.String(handles.popupmenu1.Value)),'Modal Analysis')
        modeplot = handles.popupmenu2.Value;
        extramp = handles.slider1.Value;
        plot_geometry_modes(handles.axes2,PROJECT_OSP,modeplot,extramp,handles.pushbutton13.Value);
    end
    
elseif strcmp(handles.popupmenu1.String(handles.popupmenu1.Value),'Undeformed')
    set(handles.popupmenu2,'visible','off');
    set(handles.pushbutton13,'enable','off');
    set(handles.slider1,'visible','off');
    if isfield(PROJECT_OSP,'geometry')
        % Plot geometry
        extramp = handles.slider1.Value;
        plot_geometry_modes(handles.axes2,PROJECT_OSP,0,extramp,handles.pushbutton13.Value);
        
        if isfield(PROJECT_OSP,'OSP_results')
            if isfield(PROJECT_OSP.OSP_results,'LISTADO_SETUP')
                if size(PROJECT_OSP.OSP_results.LISTADO_SETUP,2)>1
                    if handles.radiobutton26.Value == 1
                        set(handles.uipanel4,'visible','on');
                    else
                        set(handles.uipanel4,'visible','off');
                    end
                else
                    set(handles.uipanel4,'visible','off');
                end
            end
        end
        if isfield(PROJECT_OSP,'modalprop')
            nmodes = PROJECT_OSP.config.Nmodes;
            for i=1:nmodes
                text(i) = {['Mode ',int2str(i)]};
            end
            
            handles.popupmenu2.String = text;
            set(handles.popupmenu1,'enable','on')
            %         set(handles.popupmenu2,'enable','on')
        end
    end
end
h = rotate3d;
h.Enable = 'on';
setAllowAxesRotate(h,handles.axes2,true);
setAllowAxesRotate(h,handles.axes1,false);
setAllowAxesRotate(h,handles.axes4,false);
assignin('base','PROJECT_OSP',PROJECT_OSP)