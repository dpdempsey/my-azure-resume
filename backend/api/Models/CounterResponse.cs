using Microsoft.Azure.Functions.Worker;
using Microsoft.Azure.Functions.Worker.Http;

namespace api.Models

{
    public class CounterResponse
    {
        [CosmosDBOutput(databaseName: "counterdb", containerName: "AzureResume", Connection = "CosmosDBConnection", PartitionKey = "1")]
    public Counter? UpdatedCounter { get; set; }

        [HttpResult]
        public required HttpResponseData HttpResponse { get; set; }
    }
}

