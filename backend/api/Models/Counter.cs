using Newtonsoft.Json;

namespace api.Models
{
    public class Counter
    {
        [JsonProperty(PropertyName="id")]
        public required string id { get; set; }

        [JsonProperty(PropertyName="count")]
        public int count { get; set; }
    }
}