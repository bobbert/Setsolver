// application.js: Setsolver-specific JavaScript functions and classes.
// This file is automatically included by javascript_include_tag :defaults

  // toggle_chk( int ): toggles checked status of card at index
  // number passed in as argument
  function toggle_chk( indx ) {
    cell_el  = $('cell' + indx);
    field_el = $('card' + indx);

    selectCard( cell_el, field_el, !(cell_el.hasClassName('selected')) );
     doAjaxIfSetSelected();
  }

  // function selectCard( el, isSelected ): handles selection or unselection of a card element
  function selectCard( cell_el, form_el, isSelected ) {
    cell_el.removeClassName((isSelected ? 'unselected' : 'selected'));
    cell_el.addClassName((isSelected ? 'selected' : 'unselected'));
    form_el.value = ((isSelected ? 'SELECTED' : null))
    }

  // num_checked_cards(): returns the number of checked cards
  function num_checked_cards() {
    return $$('td.selected').length;
  }
  // doAjaxIfSetSelected(): sends Ajax request if three cards were selected
  function doAjaxIfSetSelected() {
    if ((num_checked_cards() == 3) && ($$('form').length == 1)) {
      // creating new Ajax request, and setting XML response to replace old table if
      // successful
      var frm = $$('form')[0];
      frm.request({
	onComplete: function(xhr) {
	  $('setgame').innerHTML = xhr.responseText;
	}
      });
    }
  }

