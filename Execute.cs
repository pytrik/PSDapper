using Dapper;
using System;
using System.Collections.Generic;
using System.Management.Automation;
using System.Text;
using System.Threading.Tasks;
using System.Data;
using System.Dynamic;
using System.Collections;

namespace PSDapper
{
    [Cmdlet(VerbsLifecycle.Invoke, "DapperExecute")]
    public class Execute : PSDapper
    {
        protected override void Run(string sql, object param = null, IDbTransaction transaction = null, int? commandTimeout = null, CommandType? commandType = null)
        {
            DbConnection.Execute(sql, param, transaction, commandTimeout, commandType);
        }
    }
}
