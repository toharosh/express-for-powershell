$router1 = $app.Router($MyInvocation.MyCommand.Source.ToString())

$router1.get("/:Name", {
    $response.send($request.paramter.Name)
})