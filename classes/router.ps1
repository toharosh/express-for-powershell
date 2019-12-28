class router {
    [string]$Name
    [string]$Path
    [router[]]$Routers
    [route[]]$Routes
    $test

    router([string]$Name, [string]$Path){
        $this.Name = $Name
        $this.Path = $Path
    }

    Use([string]$Name, $Path){
        $this.Routers += [router]::new("$($this.Name)$($Name)", $Path)
        .($Path)
    }

    [router]FindRouter($Path){
        return $this.Routers |?{$Path.Contains($_.Path.Substring($_.Path.IndexOf("\") + 1))}
    }

    post($Name, $InputScript){
        $this.Routes += [route]::new($this.Name, $Name, "POST", $InputScript)
    }

    get($Name, $InputScript){
        $this.Routes += [route]::new($this.Name, $Name, "GET", $InputScript)
    }

    put($Name, $InputScript){
        $this.Routes += [route]::new($this.Name, $Name, "PUT", $InputScript)
    }
    
    delete($Name, $InputScript){
        $this.Routes += [route]::new($this.Name, $Name, "DELETE", $InputScript)
    }

    run(){
        if($this.Routers.Count -gt 0){$this.Routers | %{$_.run()}}
        if($this.Routes.Count -gt 0){$this.Routes | %{$_.run()}}
    }
}