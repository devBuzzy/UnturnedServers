function tagsComplete(tag_array, tags_box) {
	var elements = tag_array
	$("#tags-box").textcomplete([
	    {
	        match: /(\w*)$/,
	        search: function (term, callback) {
			    callback($.map(elements, function (word) {
			        return word.toLowerCase().indexOf(term.toLowerCase()) === 0 ? word : null;
			    }));
			},
	        index: 1,
	        replace: function (element) {
	            return element + ', ';
	        }
	    }
	]);
}