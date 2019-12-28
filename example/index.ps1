using module "..\ExpressPs.psm1"

$app = Get-ExpressPs
$port = 8085

$MiddleWare = {
    if ($request.BodyString -ne $null) {
        $request.Body = $request.BodyString | ConvertFrom-Json
    }
}

$app.Use("/api", $MiddleWare ,".\example\routes\MainRouter.ps1")

$app.listen($port, {
     Write-Debug "app running on $port"
})