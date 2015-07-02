param (
    [System.Data.IDbConnection] $DatabaseConnection
)

function ConvertFrom-XmlNodeAttributesToPSObject {
    param (
        [Parameter(
            Position=0, 
            Mandatory=$true, 
            ValueFromPipeline=$true
        )]
        [System.Xml.XmlNode] $XmlNode
    )
    process {
        $obj = New-Object PSObject;
        foreach($attr in $XmlNode.Attributes) {
            $obj | Add-Member -MemberType NoteProperty -Name $attr.Name -Value $attr.Value;
        }
        $obj;
    }
}

function ConvertFrom-XmlNodeAttributesToDictionary {
    param (
        [Parameter(
            Position=0, 
            Mandatory=$true, 
            ValueFromPipeline=$true
        )]
        [System.Xml.XmlNode] $XmlNode
    )

    process {
        $obj = New-Object "System.Collections.Generic.Dictionary[System.String,System.Object]";
        foreach($attr in $XmlNode.Attributes){
            $obj.Add($attr.Name, $attr.Value);
        }
        $obj;
    }
}

function ConvertFrom-XmlNodeAttributesToHashmap {
    param (
        [Parameter(
            Position=0, 
            Mandatory=$true, 
            ValueFromPipeline=$true
        )]
        [System.Xml.XmlNode] $XmlNode
    )

    process {
        $obj = New-Object System.Collections.Hashtable;
        foreach($attr in $XmlNode.Attributes){
            $n=$obj.Add($attr.Name, $attr.Value);
        }
        $obj;
    }
}

Push-Location $PSScriptRoot;

try {
    Import-Module "D:\Repos Pytrik\PSDapper\bin\Debug\PSDapper.dll";

    if(!$DatabaseConnection) {
        $DatabaseConnection = New-Object System.Data.SqlClient.SqlConnection;
        $DatabaseConnection.ConnectionString = "Data Source=localhost\sql2012;Initial Catalog=ImportXMLTest;Integrated Security=SSPI;";
    }

    $XMLFilePath = Resolve-Path "D:\Repos Pytrik\PSDapper\Voor testen\ExampleXML2.xml";
    [System.Xml.XmlDocument] $XML = New-Object System.Xml.XmlDocument;
    $XML.Load($XMLFilePath);

    #$test = ($XML.catalog.book | %{ $obj = @{}; $_.Attributes | %{ $obj.Add($_.Name, $_.Value) }; $obj; });
    #$test[0].GetType();

    $XML.catalog.book | ConvertFrom-XmlNodeAttributesToHashmap |
    #$obj[0].GetType();
    #$XML.catalog.book | ConvertFrom-XmlNodeAttributesToPSObject |
        Invoke-DapperExecute -DbConnection $DatabaseConnection -SQLCommand "INSERT INTO Books (BookCode, Author, Title, Genre, Price, PublishDate, NrOfPages) VALUES (@id, @author, @title, @genre, @price, @publish_date, @pages)"
    #$XML.catalog.book | %{ $obj = @{}; $_.Attributes | %{ $obj.Add($_.Name, $_.Value) }; $obj; } |
        #Invoke-DapperExecute -DbConnection $DatabaseConnection -SQLCommand "INSERT INTO Books (BookCode, Author, Title, Genre, Price, PublishDate, NrOfPages) VALUES (@id, @author, @title, @genre, @price, @publish_date, @pages)"
    #Invoke-DapperExecute -DbConnection $DatabaseConnection -SQLCommand "INSERT INTO Books (BookCode, NrOfPages) VALUES ('testcode', @pages)" -SQLParameters $Params
}
catch {
    throw;
}
finally {
    $DatabaseConnection.Dispose();
    Pop-Location;
}

#Export-ModuleMember -function New-Function0