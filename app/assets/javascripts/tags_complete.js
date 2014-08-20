function tagsComplete(tag_array, tags_box) {
	var elements = tag_array
	$("#tags-box").textcomplete([
	    {
	        match: /(\w*)$/,
	        search: function (term, callback) {
	            callback($.map(elements, function (element) {
	                return element.indexOf(term) === 0 ? element : null;
	            }));
	        },
	        index: 1,
	        replace: function (element) {
	            return element + ', ';
	        }
	    }
	]);
}