function save_to_cad(FileName,PROJECT_OSP)
%% Function Duties
% Export the geometry + sensors location to a .dxf file

%%
vc='kymcrgbadefhijlnpqstuvzw';                     % valid color codes
cn=[0.00,0.00,0.00; 1.00,1.00,0.00; 1.00,0.00,1.00; 0.00,1.00,1.00;
%                r               g               b               a
    1.00,0.00,0.00; 0.00,1.00,0.00; 0.00,0.00,1.00; 0.42,0.59,0.24;
%                d               e               f               h
    0.25,0.25,0.25; 0.00,0.50,0.00; 0.70,0.13,0.13; 1.00,0.41,0.71;
%                i               j               l               n
    0.29,0.00,0.51; 0.00,0.66,0.42; 0.50,0.50,0.50; 0.50,0.20,0.00;
%                p               q               s               t
    0.75,0.75,0.00; 1.00,0.50,0.00; 0.00,0.75,0.75; 0.80,0.34,0.00;
%                u               v               z               w
    0.50,0.00,0.13; 0.75,0.00,0.75; 0.38,0.74,0.99; 1.00,1.00,1.00];

FID = dxf_open(FileName);

%% Nodes and lines
nodes = PROJECT_OSP.geometry.nodes;
Lines = PROJECT_OSP.geometry.Lines;

%% Save points
FID = dxf_set(FID,'Color',[0 0 0],'Layer',1);
dxf_point(FID,nodes(:,2),nodes(:,3),nodes(:,4));

%% Save lines
FID = dxf_set(FID,'Color',[1 1 0],'Layer',2);
for i=1:size(Lines,1)
    rowIndex_1 = find(nodes(:,1) == Lines(i,1));
    rowIndex_2 = find(nodes(:,1) == Lines(i,2));
    X = [nodes(rowIndex_1,2); nodes(rowIndex_2,2)];
    Y = [nodes(rowIndex_1,3); nodes(rowIndex_2,3)];
    Z = [nodes(rowIndex_1,4); nodes(rowIndex_2,4)];
    dxf_polyline(FID,X,Y,Z);
end

%% Save sensors
styleOSPsensorsColor = ['b','r','m','c','r','g','z','a','d','e','f','h','i','j','l','n','p','q','s','t','u','v','k'];

% Labels
insertLabels = 1;
if isfield(PROJECT_OSP.OSP_results,'node_sel')
    node_sel = PROJECT_OSP.OSP_results.node_sel;
else
    insertLabels = 0;
end
if isfield(PROJECT_OSP.OSP_results,'dir_sel')
    dir_sel = PROJECT_OSP.OSP_results.dir_sel;
else
    insertLabels = 0;
end
if isfield(PROJECT_OSP.geometry,'References')
    References = PROJECT_OSP.geometry.References;
else
    References = [];
end
if insertLabels
    labels = PROJECT_OSP.OSP_results.labels;
end

% plot
if isfield(PROJECT_OSP,'OSP_results')
    if isfield(PROJECT_OSP.OSP_results,'node_sel')
        for j = 1:size(PROJECT_OSP.OSP_results.dir_sel,2)
            setup = j;
            iiii = strfind(vc,styleOSPsensorsColor(j));
            colour = cn(iiii,:);
            FID = dxf_set(FID,'Color',[colour(1) colour(2) colour(3)],'Layer',2+setup);
            for i = 1:size(PROJECT_OSP.OSP_results.dir_sel,1)
                % Don't plot if it is a ref. (will be plotted at the end)
                if labels{i,j}.isRef
                    continue
                end
                % A) Plot arrow
                dir_arrow = PROJECT_OSP.OSP_results.dir_sel(i,j);
                node_index = find(nodes(:,1) == PROJECT_OSP.OSP_results.node_sel(i,j));
                node_sel = nodes(node_index,:);
                if dir_arrow == 1
                    vect = [1,0,0];
                elseif dir_arrow == 2
                    vect = [0,1,0];
                else
                    vect = [0,0,1];
                end
                vect = vect/norm(vect);
                length_arr = PROJECT_OSP.Style_Options.styleplot.CADsensors.length;
                width_arr = PROJECT_OSP.Style_Options.styleplot.CADsensors.width;
                widtharrow_arr = PROJECT_OSP.Style_Options.styleplot.CADsensors.widtharrow;
                heightarrow_arr = PROJECT_OSP.Style_Options.styleplot.CADsensors.heightarrow;
                dxf_arrow(FID,vect,node_sel(2:end),length_arr,width_arr,widtharrow_arr,heightarrow_arr);
                
                % B) Plot label
                if PROJECT_OSP.Style_Options.labelplot.CAD_labels == 1
                    if labels{i,j}.display(1)
                        X = node_sel(2);
                        Y = node_sel(3);
                        Z = node_sel(4);
                        text = ['Ch. ' num2str(labels{i,j}.ch(1)) '; U' num2str(labels{i,j}.direction(1))];
                        fontsize = PROJECT_OSP.Style_Options.labelplot.CADFontsize;
                        dxf_text(FID, X, Y, Z, text,'TextHeight',fontsize);
                    end
                end
                
            end
        end
    end
end

if isfield(PROJECT_OSP.geometry,'References') & ~PROJECT_OSP.config.runGlobalOSP
    nlayer = PROJECT_OSP.geometry.Nsetups+3;
    FID = dxf_set(FID,'Color',[1 1 0],'Layer',nlayer);
    identityMatrix = eye(3);
    for j = 1:size(PROJECT_OSP.geometry.References,1)
        vect = PROJECT_OSP.geometry.References(j,2:end);
        node_index = find(References(j,1) == nodes(:,1));
        node_sel = nodes(node_index,:);
        vect = vect/norm(vect);
        length_arr = PROJECT_OSP.Style_Options.styleplot.CADsensors.length;
        width_arr = PROJECT_OSP.Style_Options.styleplot.CADsensors.width;
        widtharrow_arr = PROJECT_OSP.Style_Options.styleplot.CADsensors.widtharrow;
        heightarrow_arr = PROJECT_OSP.Style_Options.styleplot.CADsensors.heightarrow;
        dxf_arrow(FID,vect,node_sel(2:end),length_arr,width_arr,widtharrow_arr,heightarrow_arr);
        % B) Plot label
        if PROJECT_OSP.Style_Options.labelplot.CAD_labels == 1
            % Get the channel
            for i=1:size(labels,1)
                if (labels{i,1}.node == References(j,1) & all(identityMatrix(labels{i,1}.direction, :) == References(j, 2:4)))
                    break
                end
            end
            X = node_sel(2);
            Y = node_sel(3);
            Z = node_sel(4);
            text = ['Ch. ' num2str(labels{i,1}.ch(1)) '; U' num2str(labels{i,1}.direction(1))]; % {i,1} because we plot the references only for the first setup (the remaining have the same references, of course)
            fontsize = PROJECT_OSP.Style_Options.labelplot.CADFontsize;
            dxf_text(FID, X, Y, Z, text,'TextHeight',fontsize);
        end
    end
end

% Close DXF file.
dxf_close(FID);

% Show message specifying file path
msgbox(['Document saved to: ', FileName], 'Save Confirmation', 'help');

end