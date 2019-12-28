Install-Module Polaris

.("..\classes\route.ps1")
.("..\classes\router.ps1")
.("..\classes\express.ps1")

$app = [express]::new()
$port = 8085

$app.Use("/api", ".\routes\MainRouter.ps1")

$app.get("/test/:Name", {
    $response.send($request.Parameters.Name)
});

$app.listen($port, 1, 10, {
     "app running on $port" >> ".\test.txt"
});

