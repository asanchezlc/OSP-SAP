function WindowScrollWheelCallback_pan(src,eventdata, axis)

clickType = eventdata.Source.SelectionType;

% set the zoom facor
if eventdata.VerticalScrollCount < 0
    % increase the magnification
    zoom_factor = 1.05;
else 
    % decrease the magnification
    zoom_factor = 0.95;
end
% camera zoom
camzoom(axis,zoom_factor)
end