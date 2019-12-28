class ExpressPs {
    [Int]$Port = 1324
    [ExpressRouter]$MainRouter
    [ExpressRouter[]]$Routers
    [Int]$MaxRunspaces = 1
    [Int]$MinRunspaces = 1
    [boolean]$https = $false
    [boolean]$auth = 'Anonymous'
    [boolean]$isRunning
    hidden [int]$NumberOfMiddleWare = (Get-Polaris).RouteMiddleWare.count + 1
    $Polaris

    ExpressPs([boolean]$https, [string]$auth){
        $this.https = $https
        $this.auth = $auth
        $this.express()
    }

    ExpressPs(){
        Stop-Polaris
        Clear-Polaris
       $this.MainRouter = [ExpressRouter]::new('', '')
    }

    Use([string]$Name, $InputScript, [string]$Path){
        $this.Use($Name, $Path)
        $this.Use($InputScript)
    }

    Use([string]$Name, [string]$Path){
        $this.Routers += [ExpressRouter]::new($Name, $Path)
        .($Path)
    }

    Use($InputScript){
        New-PolarisRouteMiddleware -Name $this.NumberOfMiddleWare -Scriptblock $InputScript
        $this.NumberOfMiddleWare++
    }

    [ExpressRouter]Router($Path){
        $router =  $this.Routers | ?{$Path.Contains($_.Path.Substring($_.Path.IndexOf("\") + 1))}
        if(!$router){
            $router =  $this.Routers | %{$_.findRouter($Path)}
        }
        return $router
    }

    post($Name, $InputScript){
        $this.MainRouter.post($Name, $InputScript)
    }

    get($Name, $InputScript){
        $this.MainRouter.get($Name, $InputScript)
    }

    put($Name, $InputScript){
        $this.MainRouter.put($Name, $InputScript)
    }
    
    delete($Name, $InputScript){
        $this.MainRouter.delete($Name, $InputScript)
    }

    listen([Int]$Port, [Int]$MinRunspaces, [Int]$MaxRunspaces, $InputScript){
        $this.MaxRunspaces = $MaxRunspaces
        $this.MinRunspaces = $MinRunspaces
        $this.listen($Port, $InputScript)
    }

    listen([Int]$Port, $InputScript){
        Invoke-Command $InputScript
        $this.Port = $Port
        $this.listen($Port)
    }

    listen([Int]$Port){
        $this.InitRoutes()
        $this.InitListener()
    }

    hidden InitListener(){
        if($this.https){
            $this.Polaris = Start-Polaris -Port $this.Port -MinRunspaces $this.MinRunspaces -MaxRunspaces $this.MaxRunspaces -Auth $this.auth -Https $this.https -UseJsonBodyParserMiddleware
        } else{
            $this.Polaris = Start-Polaris -Port $this.Port -MinRunspaces $this.MinRunspaces -MaxRunspaces $this.MaxRunspaces -UseJsonBodyParserMiddleware
        }
        $this.isRunning = $true
    }

    hidden InitRoutes(){
        $this.Routers | %{$_.run()}
        $this.MainRouter | %{$_.run()}
    }
}