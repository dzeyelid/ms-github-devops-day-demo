import { AzureFunction, Context, HttpRequest } from "@azure/functions"

const httpTrigger: AzureFunction = async function (context: Context, req: HttpRequest): Promise<void> {
  context.log('HTTP trigger function processed a request.');

  const name = (req.query.name || (req.body && req.body.name));
  const message = name ? `Hello, ${name}!` : 'Hoooray!'

  const headers = {
    'content-type': 'application/json',
  }

  context.res = {
    // status: 200, /* Defaults to 200 */
    headers,
    body: {
      message
    }
  };

};

export default httpTrigger;