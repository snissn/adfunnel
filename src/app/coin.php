<style>

.card{
max-width:500px;
margin: 0 auto;
margin-top:8px;
margin-bottom:8px;

}
</style>
<?php 
require("db.php");

$tweets = get_tweets($_GET['id']);
$coin = get_coin_info($_GET['id']);

?>
<html>
  <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <!-- CSS Dependencies -->
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0-beta/css/bootstrap.min.css" integrity="sha384-/Y6pD6FV/Vv2HJnA6t+vslU6fwYXjCFtcEpHbNJ0lyAFsXTsjBbfaDjzALeQsN6M" crossorigin="anonymous">
<link href="https://maxcdn.bootstrapcdn.com/bootswatch/4.0.0/minty/bootstrap.min.css" rel="stylesheet" integrity="sha384-OSebLJ6DTybdnQ7rjdh2FeOkWs4mQkZQwBDa0IdEyyWyCONtTCUyj+VOEqMcpKAo" crossorigin="anonymous">

	</head>

	<body>

<?php require("nav.php");?>

<div class="container">
    <div class="row">


      <div class="col-lg-12">
<div class="bs-component">
                    <h1><a href="<?=$coin['website']?>" target=_blank><img style="margin-right:10px" src="<?=$coin['image']?>" /><?=$coin['title']?></a></h1>



  <?php foreach(array_chunk($tweets,2) as $values){?>
<div class="card-deck">
<?php foreach($values as $tweet){?>

  <div class="card bg-light">
		<div class="card-header"><img src="<?=$tweet['profile_image']?>" style="float:left; margin-right:10px;" /><?=$tweet['display_name']?> <br />@<?=$tweet['username']?></div>
		<div class="card-body">
			<h4 class="card-title"><?=$tweet['text']?></h4>
			<p class="card-text">Retweets: <?=$tweet['retweet_count']?> Favorites: <?=$tweet['favorite_count']?> </p>
		</div>
    <div class="card-footer">
      <small class="text-muted"><?=$tweet['created']?><div style="float:right"><a target=_blank href="https://twitter.com/<?=$tweet['username']?>/status/<?=$tweet['id']?>">View Tweet</a></div></small>

    </div>

	</div>

<?php }?>

    </div> <!-- card-deck -->
<?php }?>

    </div> <!-- row -->
    </div> <!-- container -->

	</body>
</html>
