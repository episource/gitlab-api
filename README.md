# Project Title

PowerShell module to interact with Gitlab API without any dependency on a local git installation.

## Getting Started

These instructions will get you a copy of the project up and running on your machine.

### Installing

This Project is available trough the powershell gallery  

Install module via the powershell gallery

```Powershell
Install-module GitLab-API
```

### Usage

To use the module retrieve an (private) access key from your gitlab instance.

Add it to the local configuration 

```Powershell
    Add-GitLabToken -HostName <InstanceHostName> -Token <Access Token>
```

You can now use this module to its fullest

#### projects
retreive all accessible projects:
```Powershell
    Get-GitLabProject
```
Retrieve specific project
```Powershell
    Get-GitLabProject -projectid 20
```
Set project name
```Powershell
    Set-GitLabProject -projectid 20 -Name 'Awesome Project'
```


## Contributing

Please read [CONTRIBUTING.md](/CONTRIBUTING.md) if you want to contribute.

## Versioning

[SemVer](http://semver.org/) is used for versioning. For the versions available, see the [tags on this repository](https://gitlab.com/tdemeester/GitLab-API/tags). 

## Authors

* **Thijs de Meester** - *Initial work* - [tdemeester](https://gitlab.com/tdemeester)

See also the list of [contributors](https://gitlab.com/tdemeester/GitLab-API/graphs/master) who participated in this project.

## License

This project is licensed under the MIT License - see the [LICENSE.md](/LICENSE.md) file for details