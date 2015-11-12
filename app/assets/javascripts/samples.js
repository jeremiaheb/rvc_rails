(function() {
  'use strict';
    $(document).ready(function(){
      // Access elements from DOM
      var domains = $('#domains-data').data('domains');
      var $year = $('#year');
      var $region = $('#region');

      var years = domains.map(function(el){return el.year;}).uniq().sort();
      var regions = domains.map(function(el){return el.region;}).uniq().sort();

      // Set initial options
      setOptions($year, years);
      setOptions($region, regions);

    });

    function setOptions(element, values) {
      element.empty();
      values.forEach(function(value){
        var $option = $("<option></option>")
          .attr("value", value)
          .text(value);
        element.append($option);
      });

    }

    Array.prototype.uniq = function(){
      var u = {}, a = [];
      for(var i = 0, l = this.length; i < l; ++i){
        if(u.hasOwnProperty(this[i])) {
          continue;
        }
        a.push(this[i]);
        u[this[i]] = 1;
      }
      return a;
    };

}());
