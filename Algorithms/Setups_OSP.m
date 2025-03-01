
%% Run the chosen OSP algorithm
MOD = PROJECT_OSP.modalprop.Mode_shape;
MOD1 = MOD(dof_setup,sel_modes); % select only target dofs and target modes
[bool,index_dof_setup] = ismember(dof_setup,dofs_matrix);
LISTA_GRL1 = LISTA_GRL(index_dof_setup,:);

c1 = strcmp('EFI',method);
c2 = strcmp('KEMRO',method);
c3 = strcmp('SEMRO',method);
c4 = strcmp('EFIWM',method);

if c1 == 1
    EFI_Method
else
    KEMRO_SEMRO_EFIWM_Method
end

