// $Id$

// Only run if we are in a supported browser.
if (Drupal.jsEnabled) {
  // Run the following code when the DOM has been fully loaded.
  $(document).ready(function () {
    // Attach some code to the click event for the
    // link with class "plusone-link".
    $('a.plusone-link').click(function () {
      // When clicked, first define an anonymous function
      // to the variable voteSaved.
      var voteSaved = function (data) {
        // Update the number of votes.
        $('div.score').html(data.total_votes);
        // Update the "Vote" string to "You voted".
        $('div.vote').html(data.voted);
      }
      // Make the AJAX call; if successful the
      // anonymous function in voteSaved is run.
      $.ajax({ 
        type: 'POST',       // Use the POST method.
        url: this.href,
        dataType: 'json', 
        success: voteSaved, 
        data: 'js=1'        // Pass a key/value pair.
      });
      // Prevent the browser from handling the click.
      return false;
    });
  });
}

// Below is the rewritten code using Drupal.behaviors.

/*
Drupal.behaviors.plusone = function (context) {
  $('a.plusone-link:not(.plusone-processed)', context)
  .click(function () { 
    var voteSaved = function (data) {
      $('div.score').html(data.total_votes); 
      $('div.vote').html(data.voted); 
    }
    $.ajax({ 
      type: 'POST',
      url: this.href, 
      dataType: 'json', 
      success: voteSaved, 
      data: 'js=1' 
    });
    return false; 
  })
  .addClass('plusone-processed');
}

*/