param (
    [System.Data.IDbConnection] $DatabaseConnection
)

Push-Location $PSScriptRoot;

try {
    Import-Module "E:\PSDapper\bin\Debug\PSDapper.dll";

    if(!$DatabaseConnection) {
        $DatabaseConnection = New-Object System.Data.SqlClient.SqlConnection;
        $DatabaseConnection.ConnectionString = "Data Source=localhost;Initial Catalog=ImportXMLTest;Integrated Security=SSPI;";
    }
    
    $Params = New-Object System.Object;
    $Params | Add-Member -MemberType NoteProperty -name Pages -value 276;

    #$Params =  New-Object System.Object({ Pages = 378 });
    $Params.GetType();

    $XML = [XML] "<Pages>873</Pages>";

    $XML.GetType();

    Dapper-Execute -DbConnection $DatabaseConnection -SQLCommand "INSERT INTO Books (BookCode, Author, Title, NrOfPages) VALUES ('bk997', 'Meeeeee!', 'LALALALAL', @Pages)" -SQLParameters $XML #$Params #@{ "Pages" = 181 }

    #Dapper-Execute -DbConnection $DatabaseConnection -SQLCommand

    #$XML = [XML] (Get-Content $XMLFilePath);
    #$XML.catalog.book | MergeInto-DBTable -Database $DBConnection -Table $TableName;
}
catch {
    throw;
}
finally {
    $DatabaseConnection.Dispose();
    Pop-Location;
}

#Export-ModuleMember -function New-Function0