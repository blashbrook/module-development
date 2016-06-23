<?php drupal_add_js('misc/collapse.js') ?>
<div class="node<?php if ($sticky) { print " sticky"; } ?>
  <?php if (!$status) { print " node-unpublished"; } ?>">
    <?php if ($picture) {
      print $picture;
    }?>
    <?php if ($page == 0) { ?><h2 class="title"><a href="<?php
      print $node_url?>"><?php print $title?></a></h2><?php }; ?>
    <span class="submitted"><?php print $submitted?></span>
    <span class="taxonomy"><?php print $terms?></span>
    <div class="content">
      <?php print $content?>
      <fieldset class="collapsible collapsed">
        <legend>Punchline</legend>
          <div class="form-item">
            <label><?php if (isset($node->punchline)) print 
              check_markup($node->punchline)?></label>
            <label><?php if (isset($node->guffaw)) print $node->guffaw?></label>
          </div>
        </legend>
      </fieldset>
    </div>
  <?php if ($links) { ?><div class="links">&raquo; <?php print $links?></div>
    <?php }; ?>
</div>
