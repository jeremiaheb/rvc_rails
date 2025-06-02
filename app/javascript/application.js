// Entry point for the build script in your package.json
import jQuery from "jquery"
window.jQuery = jQuery
window.$ = jQuery

// On document ready
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

    const availableYears = new Set($yearSelect.
      data("domains").
      filter((el) => { return el.region == regionValue }).
      map((el) => { return el.year })
    );

    $yearSelect.find("option").each((idx, el) => {
      const val = $(el).val();
      if (val === "" || availableYears.has(parseInt(val))) {
        $(el).show();
      } else {
        $(el).hide();
      }
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
