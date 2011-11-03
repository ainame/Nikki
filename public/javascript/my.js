function search_index(array, value){
    var ret_val = -1;
    $.each(array, function(idx, val){
	if( val == value ){
	    ret_val = idx;
            return false;
	}
    });
    return ret_val;
}

function convert_hidden_params(array){
    var part = $("<div>");
    $.each(array, function(idx,val){
        part.append(
            "<input id='photo" + idx + "' name='photo"
		+ idx +"' type='hidden'value='"+ val +"'>"
        );
    });
    
    return part;
}
