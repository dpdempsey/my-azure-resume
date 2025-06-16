using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using api.Models;
using Microsoft.Azure.Functions.Worker;
using Microsoft.Extensions.Logging;
using Microsoft.Azure.Functions.Worker.Http;
using System.Net;

namespace api.Function;

public class GetResumeCounter
{
    private readonly ILogger<GetResumeCounter> _logger;

    public GetResumeCounter(ILogger<GetResumeCounter> logger)
    {
        _logger = logger;
    }

    [Function("GetResumeCounter")]
    public static async Task<CounterResponse> Run(
        [HttpTrigger(AuthorizationLevel.Function, "get", "post")] HttpRequestData req,
        [CosmosDBInput(
            databaseName: "counterdb",
            containerName: "AzureResume",
            Connection = "CosmosDBConnection",
            Id = "1",
            PartitionKey = "1")] Counter counter,
        FunctionContext executionContext)
    {
        var logger = executionContext.GetLogger("GetResumeCounter");
        logger.LogInformation("Processing resume counter.");

        counter.count += 1;

        var response = req.CreateResponse(HttpStatusCode.OK);
        await response.WriteStringAsync($"New counter value: {counter.count}");

        return new CounterResponse
        {
            UpdatedCounter = counter,
            HttpResponse = response
        };
    }
}