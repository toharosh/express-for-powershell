class ExpressRouter {
    [string]$Name
    [string]$Path
    [ExpressRouter[]]$Routers
    [ExpressRoute[]]$Routes
    $test

    ExpressRouter([string]$Name, [string]$Path){
        $this.Name = $Name
        $this.Path = $Path
    }

    Use([string]$Name, $Path){
        $this.Routers += [ExpressRouter]::new("$($this.Name)$($Name)", $Path)
        .($Path)
    }

    [ExpressRouter]FindRouter($Path){
        return $this.Routers |?{$Path.Contains($_.Path.Substring($_.Path.IndexOf("\") + 1))}
    }

    post($Name, $InputScript){
        $this.Routes += [ExpressRoute]::new($this.Name, $Name, "POST", $InputScript)
    }

    get($Name, $InputScript){
        $this.Routes += [ExpressRoute]::new($this.Name, $Name, "GET", $InputScript)
    }

    put($Name, $InputScript){
        $this.Routes += [ExpressRoute]::new($this.Name, $Name, "PUT", $InputScript)
    }
    
    delete($Name, $InputScript){
        $this.Routes += [ExpressRoute]::new($this.Name, $Name, "DELETE", $InputScript)
    }

    run(){
        if($this.Routers.Count -gt 0){$this.Routers | %{$_.run()}}
        if($this.Routes.Count -gt 0){$this.Routes | %{$_.run()}}
    }
}