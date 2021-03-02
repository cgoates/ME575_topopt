function IEN = getIEN( num_elem, ny )
dim = 2;

IEN = zeros( num_elem, 2^dim );

for e = 1:num_elem
    IEN(e,:) = getElemConnectivity( e, ny );
end

function nodes = getElemConnectivity( e, ny )
    i_ll = mod( e-1, ny );
    j_ll = floor( (e-1) / ny );
        
    nodes = zeros( 1, 2^dim );
    for j = [0,1]
        j_c = j_ll + j;
        for i = [0,1]
            i_c = i_ll + i;
            a = j*2 + i + 1;
            nodes(a) = j_c*(ny + 1) + i_c + 1;
        end
    end
end


end