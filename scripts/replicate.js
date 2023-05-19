import url from "url";
import http from "http";
import util from "util";
import fetch from "cross-fetch";
import Replicate from "replicate";

async function main() {
  const replicate = new Replicate({
    auth: process.env.REPLICATE_API_TOKEN,
    fetch,
  });

  const blip2Version = "4b32258c42e9efd4288bb9910bc532a69727f9acd26aa08e175713a0a857a608";
  const webhook = "https://blip2-replicate.sa.ngrok.io/webhook?assetId=lcdtmob";
  const image =
    "https://images.unsplash.com/photo-1684457718008-d561d76dfbb8?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1278&q=80";

  const prediction = await replicate.predictions.create({
    version: blip2Version,
    webhook,
    webhook_events_filter: ["completed"],
    input: {
      image,
      caption: true,
      temperature: 1,
    },
  });

  console.log(util.inspect(prediction, { depth: null, showHidden: false, colors: true }));

  const server = http.createServer((req, res) => {
    if (req.method === "POST") {
      const parsedUrl = url.parse(req.url, true);
      const assetId = parsedUrl.query.assetId;

      console.log("AssetId is " + assetId);

      let body = "";
      req.on("data", (data) => {
        body += data;
      });
      req.on("end", () => {
        console.log("Received webhook with body:");
        console.log(
          util.inspect(JSON.parse(body), { depth: null, showHidden: false, colors: true })
        );
        res.writeHead(200, { "Content-Type": "text/plain" });
        res.end("Webhook received");
        process.exit(0);
      });
    } else {
      res.writeHead(404, { "Content-Type": "text/plain" });
      res.end("Not found");
    }
  });

  server.listen(3000, () => {
    console.log("Server listening on port 3000");
  });
}

main()
  .then(() => {
    console.log("Done");
  })
  .catch((err) => {
    console.error(err);
  });
