function createCylinderDXF(radius, height, fid)
    % Create cylinder data
    [X, Y, Z] = cylinder(radius);
    Z = Z * height; % Scale to height


    % Loop through cylinder points to create DXF entities
    for i = 1:size(X, 2)
        % Bottom circle
        fprintf(fid, '0\nLINE\n');
        fprintf(fid, '8\n0\n'); % Layer
        fprintf(fid, '10\n%f\n', X(1, i));
        fprintf(fid, '20\n%f\n', Y(1, i));
        fprintf(fid, '30\n%f\n', Z(1, i));
        fprintf(fid, '11\n%f\n', X(1, mod(i, size(X, 2)) + 1));
        fprintf(fid, '21\n%f\n', Y(1, mod(i, size(Y, 2)) + 1));
        fprintf(fid, '31\n%f\n', Z(1, mod(i, size(Z, 2)) + 1));
    end

    for i = 1:size(X, 2)
        % Top circle
        fprintf(fid, '0\nLINE\n');
        fprintf(fid, '8\n0\n'); % Layer
        fprintf(fid, '10\n%f\n', X(2, i));
        fprintf(fid, '20\n%f\n', Y(2, i));
        fprintf(fid, '30\n%f\n', Z(2, i));
        fprintf(fid, '11\n%f\n', X(2, mod(i, size(X, 2)) + 1));
        fprintf(fid, '21\n%f\n', Y(2, mod(i, size(Y, 2)) + 1));
        fprintf(fid, '31\n%f\n', Z(2, mod(i, size(Z, 2)) + 1));
    end

end

