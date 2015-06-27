using Dapper;
using System;
using System.Collections.Generic;
using System.Management.Automation;
using System.Text;
using System.Threading.Tasks;
using System.Data;

// http://www.powershellmagazine.com/2014/03/18/writing-a-powershell-module-in-c-part-1-the-basics/
namespace PSDapper
{
    [Cmdlet("Dapper", "Execute")]
    public class DapperExecute : PSCmdlet
    {
        private IDbTransaction Transaction;

        [Parameter(
            Mandatory = true,
            ValueFromPipelineByPropertyName = false,
            ValueFromPipeline = false,
            Position = 0,
            HelpMessage = "The database connection"
        )]
        [Alias("Connection", "DatabaseConnection")]
        public IDbConnection DbConnection
        {
            get;
            set;
        }

         [Parameter(
            Mandatory = true,
            ValueFromPipelineByPropertyName = false,
            ValueFromPipeline = false,
            Position = 1,
            HelpMessage = "The SQL command to Execute"
        )]
        [Alias("Command", "SQL")]
        public String SQLCommand
        {
            get;
            set;
        }

         [Parameter(
             Mandatory = false,
             ValueFromPipelineByPropertyName = true,
             ValueFromPipeline = true,
             ValueFromRemainingArguments = true,
             Position = 2,
             HelpMessage = "The object containing the parameters for the SQL command"
             //ParameterSetName=""
         )]
         [Alias("CommandParameters")]
         public Object SQLParameters
         {
             get;
             set;
         }

        [Parameter(
            Mandatory = false,
            ValueFromPipelineByPropertyName = false,
            ValueFromPipeline = false,
            Position = 3,
            HelpMessage = "Timeout"
        )]
        [Alias("Timeout")]
        public int CommandTimeout
        {
            get;
            set;
        }

        [Parameter(
            Mandatory = false,
            ValueFromPipelineByPropertyName = false,
            ValueFromPipeline = false,
            Position = 4,
            HelpMessage = "Type"
        )]
        [Alias("Type")]
        public CommandType CommandType
        {
            get;
            set;
        }

        protected override void BeginProcessing()
        {
            DbConnection.Open();
            Transaction = DbConnection.BeginTransaction();
        }

        protected override void ProcessRecord()
        {
            //Object SQLParametersNonPS = new { Pages = 378 };
            //WriteObject(SQLParametersNonPS.GetType());
            //WriteObject(SQLParameters.GetType());
            DbConnection.Execute(SQLCommand, SQLParameters, Transaction, CommandTimeout, CommandType);
        }

        protected override void EndProcessing()
        {
            Transaction.Commit();
            DbConnection.Close();
        }

        protected override void StopProcessing()
        {
            Transaction.Rollback();
            DbConnection.Close();
        }
    }
}
