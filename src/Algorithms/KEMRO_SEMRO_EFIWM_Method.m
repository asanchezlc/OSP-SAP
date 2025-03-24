
%% PART 1: DISCARD RESTRAINED DOFS FROM K,M, dof_setup, dir_setup, nodes_setup
% Retrieve variables
dofs = PROJECT_OSP.geometry.dofs;
dofsElm = PROJECT_OSP.geometry.dofsElm;
K = PROJECT_OSP.matrices.K;
M = PROJECT_OSP.matrices.M;

% Get which dof_setup_Elm (variable dof_setup but referred to all point elements)
aux_setup = [dofs.nodeID(dof_setup), dofs.U1(dof_setup), dofs.U2(dof_setup), dofs.U3(dof_setup)];
[isMember,dof_setup_Elm] = ismember(aux_setup,[dofsElm.nodeID, dofsElm.U1, dofsElm.U2, dofsElm.U3],'rows');
dof_setup_Elm = dof_setup_Elm.';

% Get the unrestrainedDofs
[K_unr, M_unr, unrestrainedDofs]=get_unrestrained_K_M(K, M);

% Remove from dof_setup_Elm the restrained dofs
indices_dof_setup_restrained = find(dofsElm.isRestrained(dof_setup_Elm)==1);
%dof_setup_Elm_restrained = dof_setup_Elm(indices_dof_setup_restrained);
dof_setup_Elm(indices_dof_setup_restrained) = []; % unrestrained
dir_setup(indices_dof_setup_restrained) = []; % unrestrained
nodes_setup(indices_dof_setup_restrained) = []; % unrestrained

% Get the dof_setup unrestrained (from dof_setup_Elm)
aux_setup_Elm = [dofsElm.nodeID(dof_setup_Elm), dofsElm.U1(dof_setup_Elm), dofsElm.U2(dof_setup_Elm), dofsElm.U3(dof_setup_Elm)];
[isMember,dof_setup] = ismember(aux_setup_Elm,[dofs.nodeID, dofs.U1, dofs.U2, dofs.U3],'rows');
dof_setup = dof_setup.';

% Retrieve the SlaveDofs (all not belonging to dof_setup_Elm, with ID for only unrestrained)
NonSlaveDofs = dofsElm.dofID_unrestrained(dof_setup_Elm);
SlaveDofs = dofsElm.dofID_unrestrained(find(dofsElm.isRestrained==0));
SlaveDofs(NonSlaveDofs)=[];

% Get reduced matrix and rename variables
[KR,MR,T,Kss]=GuyanReduction(K_unr,M_unr,SlaveDofs);
OSP = dof_setup;
Phi = MOD1;
Phi(indices_dof_setup_restrained, :) = []; % the same as: PROJECT_OSP.modalprop.Mode_shape_Elm(dof_setup_Elm,:);
LISTA_GRL1(indices_dof_setup_restrained, :) = []; 
% Frequency check (only works if the set of nodes is high enough
%f = diag(sqrt((Phi' * KR * Phi)/(Phi' * MR * Phi))/(2*pi));

%% PART 2: CLEAR VARIABLES COMING FROM PREVIOUS SETUPS
clear Edserie
clear minED
clear del_DOF
clear LISTA_OSP_C
clear surv_DOF_C
clear surv_dir
clear surv_nodes_C

%% PART 3: OSP ALGORITHM (KEMRO, SEMRO & EFIWM)
% n_modes <= nº sensors
j = length(OSP);
detFIM = zeros(j,1);
m = max(size(Phi,2),numel(pos_ref_in_setup));
for i=1:j-m
    if c2 == 1 % KEMRO
        Q = Phi'*MR*Phi;
        [U] = chol(MR);
        detFIM(i) = det(Q);
        [Psi,Lambda] = eig(Q);
        Ed = diag((U*Phi)*Psi*inv(Lambda)*Psi'*(U*Phi)');        
    elseif c3 == 1 % SEMRO
        Q = Phi'*KR*Phi;
        [U] = chol(KR);
        detFIM(i) = det(Q);
        [Psi,Lambda] = eig(Q);
        Ed = diag((U*Phi)*Psi*inv(Lambda)*Psi'*(U*Phi)');       
    elseif c4 == 1 % EFIWM
        Q = Phi'*MR*Phi;
        detFIM(i) = det(Q);
        [Psi,Lambda] = eig(Q);
        Ed = diag((MR^0.5)*Phi*Psi*inv(Lambda)*Psi'*Phi'*(MR^0.5)');
    end
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
    OSP(I) = [];
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
    [KR,MR,T,Kss]=GuyanReduction(KR,MR,I);
end



