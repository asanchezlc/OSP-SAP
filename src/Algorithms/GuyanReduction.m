function [KR,MR,T,Kss]=GuyanReduction(K,M,SlaveDofs)
%{
Function Duties: Guyan reduction or Static reduction
With this method, the reduced model tries to reproduce 
the natural freq.s of full model.

K , M : Full order (except restrained DOFs) Stiffness & Mass Matrices 
SlaveDofs : Dofs to be deattached from system (all of them
non-restrained);
KR, MR : Reduced stiffness & Mass Matrices
T : Transformation Matrix
Kss : Slave Stiffness Matrix 

REMARK:
K, M are NOT the matrices directly read from SAP2000, but the matrices
related to UNRESTRAINED dofs.
Analogously, SlaveDofs do not refer to all the element dofs, but only the
unrestrained ones.
%}

Dof = length(K(:,1));
index =1:Dof ;
index(SlaveDofs) =[];

Kmm=zeros(length(index),length(index));
Mmm=zeros(length(index),length(index));
Kss=zeros(length(SlaveDofs),length(SlaveDofs));
Mss=zeros(length(SlaveDofs),length(SlaveDofs));
Ksm=zeros(length(SlaveDofs),length(index));
Msm=zeros(length(SlaveDofs),length(index));
Kms=zeros(length(index),length(SlaveDofs));
Mms=zeros(length(index),length(SlaveDofs));

for ii = 1 : length(index)
    for ij = 1 : length(index)
        Mmm(ii,ij) = M(index(ii),index(ij)) ; 
        Kmm(ii,ij) = K(index(ii),index(ij)) ;        
    end
end


for ii = 1 : length(SlaveDofs)
    for ij = 1 : length(SlaveDofs)
        Mss(ii,ij) = M(SlaveDofs(ii),SlaveDofs(ij)) ;  
        Kss(ii,ij) = K(SlaveDofs(ii),SlaveDofs(ij)) ;    
    end
end

for ii = 1 : length(SlaveDofs)
       for ij = 1 : length(index)
           Msm(ii,ij) =  M(SlaveDofs(ii),index(ij)) ;  
           Ksm(ii,ij) =  K(SlaveDofs(ii),index(ij)) ;             
       end
end
 
for ii = 1 : length(index)
       for ij = 1 : length(SlaveDofs)
           Mms(ii,ij) =  M(index(ii),SlaveDofs(ij)) ;  
           Kms(ii,ij) =  K(index(ii),SlaveDofs(ij)) ;             
       end
end


 P = - inv(Kss)*Ksm;
 T = [ eye(length(index)); P ];
 
 K=[Kmm Kms; Ksm Kss];
 M=[Mmm Mms; Msm Mss];
 
 MR = T'*M*T;
 KR = T'*K*T;
 
 %% Check - works fine! [at least for nodes = PROJECT_OSP.geometry.nodes(:,1).')]
%  K = PROJECT_OSP.matrices.K;
%  restrainedDofs = find(all(K == 0, 2));
%  unrestrainedDofs = 1:size(K,1);
%  unrestrainedDofs(restrainedDofs)=[];
%  Mode_shape_Elm = PROJECT_OSP.modalprop.Mode_shape_Elm;
%  Phi_unr = Mode_shape_Elm(unrestrainedDofs,:);
%  Phi = Phi_unr(index, :);
%  f = diag(sqrt((Phi' * KR * Phi)/(Phi' * MR * Phi))/(2*pi));

end