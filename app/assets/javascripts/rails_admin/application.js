if (typeof($j) === "undefined" && typeof(jQuery) !== "undefined") {
  var $j = jQuery.noConflict();
}

//Hide Region properties if region is for_seo
var toggleProps = function(hide) {
  var props = $j('.region_property_ids').parents('fieldset');
  if(hide === true) {
    props.hide();
  } else if(hide === false) {
    props.show();
  }
  return hide;
}

$j(document).ready(function($){
  
  // On the list page, the checkbox in th table's header toggles all the checkboxes underneath it.
  $("table.table input.checkbox.toggle").click(function() {
    var checked_status = $(this).is(":checked");
    $("td.action.select input.checkbox[name='bulk_ids[]']").each(function() {
      $(this).attr('checked', checked_status);
      
      if (checked_status) {
        $(this).parent().addClass("checked");
      } else {
        $(this).parent().removeClass("checked");
      }
      
    });
  });
  
  $("table.table tr.link").click(function(e) {
    // trs and tds are things that we want to link to the edit page
    // if the click's target is a button for instance, we don't want to move the user.
    if ($(e.target).is('tr') || $(e.target).is('td')) {
      window.location.href = $(this).attr("data-link");
    };
  });

  var hide_model = function(singular_name) {
    $j("li.more a").each(function() {
      if($j(this).text() == singular_name+'s') {
        $(this).parents('li').hide();
      }
    });

    $j("tr td span").each(function() {
      if($j(this).text() == singular_name) {
        $(this).parents('tr').hide();
      }
    });
  };

  var hide_options = function(prefixes) {
    if ($j(".content h2:contains('page')").length > 0) {
      setTimeout(function() {
        for (i = 0; i < prefixes.length; i++) {
          $j(".ra-multiselect-left select option:contains('- "+prefixes[i]+"')").remove();
        }
      }, 500);
    }
  }

  // Always hide PageBlocks
  hide_model('Page Block');

  if ($j("li.more a:contains('Amenities')").length > 0) {
    // Hide unnecessary blocks from Res admin
    hide_model('Gca/Block');
    hide_model('Urban/Block');
    hide_options(['urban', 'gca']);
  } else if ($j("li.more a:contains('Gca/Promos')").length > 0) {
    // from Gca admin
    hide_model('Block');
    hide_model('Urban/Block');
    hide_options(['urban', 'res']);
  } else if ($j("li.more a:contains('Urban/Home Slides')").length > 0) {
    // from Urban admin
    hide_model('Block');
    hide_model('Gca/Block');
    hide_options(['res', 'gca']);
  }
  var for_seo = $('#region_for_seo');
  toggleProps(for_seo.is(':checked'));
  for_seo.change(function(e) {
    toggleProps($(this).is(':checked'));
  });
});
