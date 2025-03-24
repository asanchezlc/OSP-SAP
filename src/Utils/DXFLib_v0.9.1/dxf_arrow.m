function dxf_arrow(FID,vect,node_sel,length_arr,width_arr,widtharrow_arr,heightarrow_arr)
%DXF_POINT Store arrows in DXF file.

%   Copyright Enrique García Macías
%   $1/11/24

option = 0;

xini = node_sel;
xfin = xini+vect*length_arr/2;
X = [xini(1),xfin(1)]';
Y = [xini(2),xfin(2)]';
Z = [xini(3),xfin(3)]';

if option == 1 % Lines
    fprintf(FID.fid,'0\n');
    fprintf(FID.fid,'POLYLINE\n');
    
    dxf_print_layer(FID);
    fprintf(FID.fid,'66\n');  % entities follow (not necessary)
    fprintf(FID.fid,'1\n');
    dxf_print_point(FID,0,0.0,0.0,0.0); % dummy point before vertices
    
    % 8 = This is a 3D polyline
    % 16 = This is a 3D polygon mesh
    % 32 = The polygon mesh is closed in the N direction
    % 64 = The polyline is a polyface mesh
    
    fprintf(FID.fid,'70\n');
    fprintf(FID.fid,'8\n');
    dxf_print_vertex(FID, [X Y Z],32);
    dxf_print_seqend(FID);
    
else  % Cylinders
    FID = dxf_primitive(FID,'cylinder',0, 0,0,width_arr/10,xini,xfin);
    xini = xfin;
    xfin = xini+vect*heightarrow_arr/2;
    X = [xini(1),xfin(1)]';
    Y = [xini(2),xfin(2)]';
    Z = [xini(3),xfin(3)]';
    FID = dxf_primitive(FID,'cone',0, 0,0,(width_arr+widtharrow_arr)/10,xini,xfin);
end

end