enum RouteType {
    GET
    POST
    DELETE
    PUT
}

class ExpressRoute {
    [string]$Url
    [string]$Name
    [RouteType]$Type
    [boolean]$isRunning
    $InputScript

    ExpressRoute([string]$Url, [string]$Name, [RouteType]$Type, $InputScript){
        $this.Name = $Name
        $this.Url = $Url
        $this.Type = $Type
        $this.InputScript = $InputScript
    }

    run(){
        switch ($this.Type) {
            "GET" { 
                New-PolarisGetRoute -Path "$($this.Url)$($this.Name)" -Scriptblock $this.InputScript
                $this.isRunning = $true
                break;
            }
            "POST" { 
                New-PolarisPostRoute -Path "$($this.Url)$($this.Name)" -Scriptblock $this.InputScript
                $this.isRunning = $true
                break;
            }
            "DELETE" { 
                New-PolarisDeleteRoute -Path "$($this.Url)$($this.Name)" -Scriptblock $this.InputScript
                $this.isRunning = $true
                break;
            }
            "PUT" { 
                New-PolarisPutRoute -Path "$($this.Url)$($this.Name)" -Scriptblock $this.InputScript
                $this.isRunning = $true
                break;
            }
            Default {
                break;
            }
        }
    }
}