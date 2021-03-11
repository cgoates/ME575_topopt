function inspectNodes( Nodes )

f = figure; 
plot( Nodes(1,:), Nodes(2,:), '*' );

% Hijack the Data Cursor update callback so we can inject our own info
dcm = datacursormode( f );
set( dcm, 'UpdateFcn', @onDataCursor );

% Function which returns the text to be displayed on the data cursor
function txt = onDataCursor( ~, evt )
    % Get containing figure
    f = ancestor( evt.Target, 'figure' );
    % Get the index within the original data
    idx = getfield( getCursorInfo( datacursormode( f ) ), 'DataIndex' );
    % Each element of the cell array is a new line on the cursor
    txt = { sprintf( 'X: %g', Nodes(1,idx) ), ...
            sprintf( 'Y: %g', Nodes(2,idx) ), ...
            sprintf( 'Node Index: %g', idx ) };          
end

end
