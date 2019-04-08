
$.getJSON("/index.json", function(json){
    index = elasticlunr(function () {
        this.addField('title');
        this.addField('content');
        this.addField('description');
        this.setRef('ref');
    });
    $.each(json, function (key, val) {
      // I filter out a some items here if they are not needed
      if(val.content.length !== 0 && val.description.length !== 0){
        index.addDoc(val);
      }
    })
 });

 var results = index.search(value, {
  fields: {
      title: {boost: 3},
      description: {boost: 2},
      content: {boost: 1}
  }
});