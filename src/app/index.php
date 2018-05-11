<?php 
require("db.php");

$trending_rows = get_trending();

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
<h1>Trending Cryptocurrencies over the last 24 hours on Twitter</h1>
<div class="bs-component">
      <table class="table table-hover">
                <thead>
                  <tr class="table-success">
                    <th scope="col">#</th>
                    <th scope="col">Icon</th>
                    <th scope="col">Name</th>
                    <th scope="col">Total Likes</th>
                    <th scope="col">Number of Posts</th>
                    <th scope="col">Ticker</th>
                    <th scope="col">Coinmarketcap</th>
                  </tr>
                </thead>
                <tbody>
<?php foreach($trending_rows as $index=>$row){?>
                  <tr class="table-light">
                    <th scope="row"><?=$index+1?></th>
										<td><a href="/coin.php?id=<?=$row['id']?>"> <img src="<?=$row['image']?>" /> </a></td>
										<td><a href="/coin.php?id=<?=$row['id']?>"><?=$row['title']?></a></td>
                    <td><?=$row['sum']?></td>
                    <td><?=$row['count']?></td>
                    <td><a target=_blank href="https://twitter.com/search?q=$<?=$row['ticker']?>"?>$<?=$row['ticker']?></td>
                    <td><a target=_blank href="https://coinmarketcap.com/currencies/<?=$row['title']?>/">link</a></td>
                  </tr>
<?php }?>
                </tbody>
              </table>
      </div>
      </div>
    </div> <!-- row -->
    </div> <!-- container -->

	</body>
</html>
