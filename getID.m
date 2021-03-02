function ID = getID( has_constr )

ID = -1*ones( size(has_constr) );

curr_id = 1;
for jj = 1:size(ID,2)
    for ii = 1:size(ID,1)
        if ~has_constr( ii, jj )
            ID(ii,jj) = curr_id;
            curr_id = curr_id + 1;
        end
    end
end