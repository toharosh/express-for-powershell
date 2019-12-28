$router = $app.Router($MyInvocation.MyCommand.Source.ToString())

$router.get("/helloworld", {
    $response.json({helloworld="hello world"})
})

$router.Use("/v1", ".\example\routes\GlobalRoutes.ps1")
$router.Use("/hello", ".\example\routes\TestRoutes.ps1")