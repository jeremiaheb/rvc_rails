(function() {
  'use strict';
    $(document).ready(function(){
      // Access elements from DOM
      var domains = $('#domains-data').data('domains');
      var $year = $('#year');
      var $region = $('#region');
      var $reset = $('#reset-btn');

      // Inital regions and years
      var years = domains.map(function(el){return el.year;}).uniq().sort();
      var regions = domains.map(function(el){return el.region;}).uniq().sort();

      // Set initial options
      setOptions($year, years);
      setOptions($region, regions);

      // On select, change available years/regions
      $year.on('change', function(){
        // Get the current value
        var val = this.value;
        // Change the available regions based on selection
        var availableRegions = domains.filter(function(el){return el.year == val;})
          .map(function(el){return el.region;}).uniq().sort();
        // Set the regions
        setOptions($region, availableRegions);
      });

      $region.on('change', function(){
        // get the current value
        var val = this.value;
        // Change the available years based on selection
        var availableYears = domains.filter(function(el){return el.region == val;})
          .map(function(el){return el.year;}).uniq().sort();
        // Set the years
        setOptions($year, availableYears);
      });

      $reset.click(function(){
        setOptions($year, years);
        setOptions($region, regions);
      });


    });
    // Set options for select element
    function setOptions(element, values) {
      element.empty();
      values.forEach(function(value){
        var $option = $("<option></option>")
          .attr("value", value)
          .text(value);
        element.append($option);
      });
    }
    // Get unique values for array
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
