using module "..\ExpressPs.psm1"

$app = Get-ExpressPs
$port = 8085;

$app.Use("/api", ".\example\routes\MainRouter.ps1");

$app.get("/test/:Name", {
    $response.send($request.Parameters.Name)
});

$app.listen($port, {
     Write-Debug "app running on $port"
});