function partfull = matresize(submat,ind_i,ind_j,nb)
    partfull = zeros(1,nb*14);
    partfull((ind_i-1)*3 + 1 : (ind_i-1)*3 + 3) = submat(1:3);
    partfull((ind_j-1)*3 + 1 : (ind_j-1)*3 + 3) = submat(8:10);
    
    partfull(nb*3 + (ind_j-1)*4 + 1 : nb*3 + (ind_j-1)*4 + 4) = submat(4:7);
    partfull(nb*3 + (ind_j-1)*4 + 1 : nb*3 + (ind_j-1)*4 + 4) = submat(11:14);
end