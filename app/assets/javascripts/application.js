//= require jquery/dist/jquery
//= require jquery-ujs/src/rails
//= require_self

$(function() {
  const $regionSelect = $("#region-select");
  const $regionHidden = $("#region-hidden");
  const $yearSelect = $("#year-select");
  const $downloadButton = $("#download-button");

  $("#region-select").on("input", (e) => {
    const regionValue = $regionSelect.val();
    if (regionValue === "") {
      return;
    }

    // Forms do not submit values for disabled elements. Sync this value to a
    // hidden field before disabling the select.
    $regionHidden.val(regionValue);

    const availableYears = Array.from($yearSelect.
      data("domains").
      filter((el) => { return el.region == regionValue }).
      map((el) => { return el.year })
    );
    availableYears.sort();

    // Unfortunately show() and hide() do not work for <option> in Safari and
    // IE. Remove all the options and re-create them for available years.
    $yearSelect.find("option[value!='']").remove(); // keep include_blank item
    availableYears.forEach((year) => {
      $("<option>").val(year).text(year).appendTo($yearSelect);
    });
    $yearSelect.val("");

    $yearSelect.prop("disabled", false);
    $regionSelect.prop("disabled", true);
  });

  $("#year-select").on("input", (e) => {
    const yearValue = $yearSelect.val();
    // Enable download button if non-blank year was selected
    $downloadButton.prop("disabled", yearValue === "");
  });

  $("#reset-button").on("click", (e) => {
    e.preventDefault();

    $regionSelect.val("").prop("disabled", false);
    $regionHidden.val("");
    $yearSelect.val("").prop("disabled", true);
    $downloadButton.prop("disabled", true);
  });
});
