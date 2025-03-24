function [K_unr, M_unr, unrestrainedDofs]=get_unrestrained_K_M(K, M)
%{
Function Duties:
Returns the K, M matrices for non-restrained DOFs.
%}
%% Get unrestrained K & M matrices
restrainedDofs = find(all(K == 0, 2));
unrestrainedDofs = 1:size(K,1);
unrestrainedDofs(restrainedDofs)=[];
K_unr = K(unrestrainedDofs, unrestrainedDofs);
M_unr = M(unrestrainedDofs, unrestrainedDofs);

end