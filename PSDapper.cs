using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Dynamic;
using System.Management.Automation;
using System.Text;
using System.Threading.Tasks;
using Dapper;

// http://www.powershellmagazine.com/2014/03/18/writing-a-powershell-module-in-c-part-1-the-basics/
namespace PSDapper
{
    //[Cmdlet(VerbsLifecycle.Invoke, "DapperExecute")]
    public class PSDapper : PSCmdlet
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
         )]
         [Alias("CommandParameters")]
         public dynamic SQLParameters
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

        protected virtual void Run(string sql, object param = null, IDbTransaction transaction = null, int? commandTimeout = null, CommandType? commandType = null)
        {
            //DbConnection.Execute(sql, param, transaction, commandTimeout, commandType);
        }

        protected override void BeginProcessing()
        {
            DbConnection.Open();
            Transaction = DbConnection.BeginTransaction();
        }

        protected override void ProcessRecord()
        {
            var dynamicParams = SQLParameters as DynamicParameters;
            if (dynamicParams == null)
            {
                WriteObject(SQLParameters.GetType());
                WriteObject(SQLParameters);
                var hashmap = (Hashtable)SQLParameters;
                //var conv = new PSObject();
                //var testobj = ConvertTo(SQLParameters, SQLParameters.GetType())
                if (hashmap == null)
                {
                    var psobject = SQLParameters as PSObject;
                    if (psobject == null)
                    {
                        throw new ArgumentException("Could not interpret SQLParameters");
                    }
                    else
                    {
                        dynamicParams = new DynamicParameters();
                        foreach (var prop in psobject.Properties)
                        {
                            dynamicParams.Add(prop.Name, prop.Value);
                        }
                    }
                }
                else
                {
                    dynamicParams = new DynamicParameters();
                    foreach (var key in hashmap)
                    {
                        dynamicParams.Add(key.ToString(), hashmap[key]);
                    }
                }
            }
            Run(SQLCommand, dynamicParams, Transaction, CommandTimeout, CommandType);
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
