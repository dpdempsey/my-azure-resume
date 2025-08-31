using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using api.Models;
using Microsoft.Azure.Functions.Worker;
using Microsoft.Extensions.Logging;
using Microsoft.Azure.Functions.Worker.Http;
using System.Net;

namespace api.Function;

public static class GetResumeCounter
{
    [Function("GetResumeCounter")]
    public static async Task<CounterResponse> Run(
        [HttpTrigger(AuthorizationLevel.Anonymous, "get", "post")] HttpRequestData req,
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
      
        if (counter == null)
        {
            logger.LogError("Counter document not found in Cosmos DB.");
            var notFoundResponse = req.CreateResponse(HttpStatusCode.NotFound);
            await notFoundResponse.WriteAsJsonAsync(new { error = "Counter document not found." });
            return new CounterResponse
            {
                UpdatedCounter = null,
                HttpResponse = notFoundResponse
            };
        }
        counter.count += 1;

        var response = req.CreateResponse(HttpStatusCode.OK);
        await response.WriteAsJsonAsync(new { count = counter.count });

        return new CounterResponse
        {
            UpdatedCounter = counter,
            HttpResponse = response
        };
    }
}