(function() {
  'use strict';
  function ready(){
    // Access elements from DOM
    var domains = $('#domains-data').data('domains');
    var $year = $('#year');
    var $region = $('#region');
    var $hiddenYear = $('#hidden-year');
    var $hiddenRegion = $('#hidden-region');
    var $reset = $('#reset-btn');
    var $download = $('#download-btn');

    // Inital regions and years
    var years = domains.map(function(el){return el.year;}).uniq().sort();
    var regions = domains.map(function(el){return el.region;}).uniq().sort();

    // Inital setup
    setup();

    // Initialize fields
    function setup(){
      setOptions($year, years);
      setOptions($region, regions);
      $year.prop('disabled', true);
      $download.prop('disabled', true);
      $region.prop('disabled', false);
    }

    // On selecting region, disable region, enable year, and enable download
    $region.on('change', function(){
      // get the current value
      var val = this.value;
      // Change the available years based on selection
      var availableYears = domains.filter(function(el){return el.region == val;})
        .map(function(el){return el.year;}).uniq().sort();
      // Set the years
      setOptions($year, availableYears);
      // Set the value of the hidden region
      $hiddenRegion.val(val);
      // Enable years, disable regions
      $year.prop('disabled', false);
      $region.prop('disabled', true);
    });

    $year.on('change', function(){
      // Set the value of the hidden year
      $hiddenYear.val(this.value);
      // Disable years, enable download
      $year.prop('disabled', true);
      $download.prop('disabled', false);
    });

    // Reset form
    $reset.click(setup);
  }

  // Set options for select element
  function setOptions(element, values) {
    element.empty();
    var $option = $('<option value="">&nbsp;</option>');
    element.append($option);
    values.forEach(function(value){
        $option = $("<option></option>")
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

    $(document).ready(ready);
    // Make compatible with turbolinks
    $(document).on('page:load', ready);

}());
