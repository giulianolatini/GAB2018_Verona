using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore;
using Microsoft.AspNetCore.Hosting;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Logging;

namespace Test1
{
    public class Program
    {

        public static void Main(string[] args)
        {
            var config = GetServerUrlsFromCommandLine(args);
            var port = config.GetValue<int?>("port")??5000;
            
            WebHost.CreateDefaultBuilder(args)
                .UseKestrel()
                .UseConfiguration(config)
                .UseContentRoot(Directory.GetCurrentDirectory())
                .UseIISIntegration()
                .UseStartup<Startup>()
                .UseApplicationInsights()
                .Build()
                .Run();
        }
        public static IConfigurationRoot GetServerUrlsFromCommandLine(string[] args)
        {
                var config = new ConfigurationBuilder()
                    .AddCommandLine(args)
                    .Build();
                var serverport = config.GetValue<int?>("port") ?? 5000;
                var serverurls = config.GetValue<string>("server.urls") ?? string.Format("http://*:{0}", serverport);


                var configDictionary = new Dictionary<string, string>
                {
                    {"server.urls", serverurls},
                    {"port", serverport.ToString()}
                };
                
                return new ConfigurationBuilder()
                    .AddCommandLine(args)
                    .AddInMemoryCollection(configDictionary)
                    .Build(); 
        }

    }

}
