function plot_geometry_modes(ax,PROJECT_OSP,nmode,extramp,anim)

style_to_plot_OSP_2

if nmode == 0
    modeplot = [];
else
   modeplot = PROJECT_OSP.modalprop.Mode_shape(:,nmode);
end
axes(ax);
children = get(ax, 'children');
delete(children(:));
set(ax, 'Color', 'none')
anim = 0;
Plot_Mode_Shape_OSP(PROJECT_OSP.geometry,modeplot,PROJECT_OSP,[],0,[],ax,extramp,anim)
view(ax, [-37.5, 30]);  % Adjust azimuth/elevation as needed
axis(ax, 'equal');      % Ensures consistent scaling

end