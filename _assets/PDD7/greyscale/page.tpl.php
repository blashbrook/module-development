<html>
<head>
  <title><?php print $head_title ?></title>
  <?php print $styles ?>
</head>

<body>
  <div id="container">
    <div id="header">
      <h1><?php print $site_name ?></h1>
      <?php print $header ?>
    </div>

    <?php if ($left): ?>
      <div id="sidebar-left">
        <?php print $left ?>
      </div>
    <?php endif; ?>

    <div id="main">
      <?php print $breadcrumb ?>
      <h2><?php print $title ?></h2>
      <?php print $content ?>
    </div>

    <div id="footer">
      <?php print $footer_message ?>
      <?php print $footer ?>
    </div>
  </div>
  <?php print $base_path ?>
  <?php print $directory ?>
  <?php print $closure ?>
</body>
</html>
