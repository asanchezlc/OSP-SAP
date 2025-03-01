%% EFI_Method.m

OSP = dof_setup;
Phi = MOD1;

%% CLEAR VARIABLES COMING FROM PREVIOUS SETUPS
clear Edserie
clear minED
clear del_DOF
clear LISTA_OSP_C
clear surv_DOF_C
clear surv_dir
clear surv_nodes_C

%% ALGORITMO EFI
% n_modes <= nº sensors
% nactivedofs = length(OSP);
j = length(OSP);
detFIM = zeros(j,1);
m = max(size(Phi,2),numel(pos_ref_in_setup));
for i=1:j-m
    Q = Phi'*Phi;
    detFIM(i) = det(Q);
    [Psi,Lambda] = eig(Q);
    Ed = diag(Phi*Psi*inv(Lambda)*Psi'*Phi');
    [C,I] = min(Ed);
    Ed2 = Ed;

    if ~isempty(pos_ref_in_setup) % if the reference were chosen to be removed, we assign high Ed for not to remove it
        while any(ismember(pos_ref_in_setup,I))
            Ed2(I) = 999999999;
            [C,I] = min(Ed2);
        end
    end
    
    Ed(I) = [];
    Edserie(i) = {Ed};
    minED(i) = C;
    OSP(I) = []; % we delete index I from OSP (i.e. dof_setup)
    nodes_setup(I) = []; % we delete index I from nodes_setup
    dir_setup(I) = []; % we delete index I from dir_setup
    del_DOF(i) = I;
    LISTA_GRL1(I,:) = [];
    
    LISTA_OSP_C(i) = {LISTA_GRL1};
    surv_DOF_C(i) = {OSP};
    surv_dir(i) = {dir_setup};
    surv_nodes_C(i) = {nodes_setup};
   
    Phi(I,:) = [];
    
    if ~isempty(pos_ref_in_setup)
        clear pos_ref_in_setup
        for ijijij = 1:numel(gdl_ref)
            pos_ref_in_setup(ijijij) = find(OSP == gdl_ref(ijijij) & nodes_setup == ref(ijijij));
        end
    end
end



