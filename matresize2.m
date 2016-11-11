function partfull = matresize2(submat,ind_i,ind_j,nb)
[r, c] = size(submat);
partfull = zeros(nb*7,nb*7);

partfull((ind_i-1)*3 + 1 : (ind_i-1)*3 + 3,... r1r1
    (ind_i-1)*3 + 1 : (ind_i-1)*3 + 3) = submat(1:3,1:3);

partfull((ind_i-1)*3 + 1 : (ind_i-1)*3 + 3,...r1p1
    (ind_j-1)*3 + 1 : (ind_j-1)*3 + 3) = submat(1:3,8:10);


partfull((ind_i-1)*3 + 1 : (ind_i-1)*3 + 3,...r1p1
    nb*3 + (ind_i-1)*4 + 1 : nb*3 + (ind_i-1)*4 + 4) = submat(1:3,4:7);

partfull((ind_i-1)*3 + 1 : (ind_i-1)*3 + 3,...r1p2
    nb*3 + (ind_j-1)*4 + 1 : nb*3 + (ind_j-1)*4 + 4) = submat(1:3,11:14);

partfull(nb*3 + (ind_i-1)*4 + 1 : nb*3 + (ind_i-1)*4 + 4,... p1p1
    nb*3 + (ind_i-1)*4 + 1 : nb*3 + (ind_i-1)*4 + 4) = submat(4:7,4:7);



partfull(nb*3 + (ind_i-1)*4 + 1 : nb*3 + (ind_i-1)*4 + 4,... p1r2
    (ind_j-1)*3 + 1 : (ind_j-1)*3 + 3) = submat(4:7,8:10);

partfull(nb*3 + (ind_i-1)*4 + 1 : nb*3 + (ind_i-1)*4 + 4,... p1p2
    nb*3 + (ind_j-1)*4 + 1 : nb*3 + (ind_j-1)*4 + 4) = submat(4:7,11:14);


partfull((ind_j-1)*3 + 1 : (ind_j-1)*3 + 3,... r2r2
    (ind_j-1)*3 + 1 : (ind_j-1)*3 + 3) = submat(8:10,8:10);


partfull((ind_j-1)*3 + 1 : (ind_j-1)*3 + 3,...r2p2
    nb*3 + (ind_j-1)*4 + 1 : nb*3 + (ind_j-1)*4 + 4) = submat(1:3,11:14);


partfull(nb*3 + (ind_j-1)*4 + 1 : nb*3 + (ind_j-1)*4 + 4,... p2p2
    nb*3 + (ind_j-1)*4 + 1 : nb*3 + (ind_j-1)*4 + 4) = submat(11:14,11:14);


partfull = [partfull(4:nb*3,4:nb*3)         partfull(4:nb*3,nb*3 + 5:end);
            partfull(nb*3 + 5:end,4:nb*3)   partfull(nb*3 + 5:end,nb*3 + 5:end)];

partfull = triu(partfull,1) + triu(partfull,1)' + diag(diag(partfull,0));
end