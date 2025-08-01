import { CoreMessage, streamText } from "ai";
import { openai } from "@ai-sdk/openai";
import { groq } from "@ai-sdk/groq";

// Define the structure of a document returned from the Vectorize API
interface VectorizeDocument {
  text: string;
  filename: string;
  source_display_name: string;
  [key: string]: any; // Allow for additional properties
}

// Define the structure of the context returned from retrieveData
interface RetrievalContext {
  documents?: VectorizeDocument[];
  [key: string]: any; // Allow for additional properties
}

export async function POST(req: Request) {
  try {
    const { messages }: { messages: CoreMessage[] } = await req.json();
    const model = process.env.MODEL;
    const llmProvider = process.env.LLM_PROVIDER?.toLowerCase(); // Convert to lowercase for case-insensitive comparison

    if (!model) {
      return new Response(
        JSON.stringify({
          error:
            "MODEL is not set in the environment variables. Please add it to your environment settings (e.g. .env.develoment) file.",
        }),
        { status: 500, headers: { "Content-Type": "application/json" } },
      );
    }

    if (!llmProvider || (llmProvider !== "openai" && llmProvider !== "groq")) {
      return new Response(
        JSON.stringify({
          error:
            "LLM_PROVIDER is not set or has an invalid value. Please set it to 'openai' or 'groq' in your environment settings.",
        }),
        { status: 500, headers: { "Content-Type": "application/json" } },
      );
    }

    // Check for provider-specific API keys
    const requiredApiKey =
      llmProvider === "openai" ? process.env.OPENAI_API_KEY : process.env.GROQ_API_KEY;

    const apiKeyName = llmProvider === "openai" ? "OPENAI_API_KEY" : "GROQ_API_KEY";

    if (!requiredApiKey) {
      return new Response(
        JSON.stringify({
          error: `${apiKeyName} is not set in the environment variables. Please add it to your environment settings (e.g. .env.develoment) file.`,
        }),
        { status: 500, headers: { "Content-Type": "application/json" } },
      );
    }

    let context: RetrievalContext | null = null;

    if (messages.length > 0) {
      try {
        const previousMessages = messages.slice(0, -1);
        context = await retrieveData(
          String(messages[messages.length - 1].content),
          previousMessages,
        );
      } catch (retrieveError: any) {
        return new Response(
          JSON.stringify({
            error: retrieveError.message || "Failed to retrieve context data",
          }),
          { status: 500, headers: { "Content-Type": "application/json" } },
        );
      }
    } else {
      console.log("No messages available, skipping retrieveData.");
    }

    // Override the last message to include the context and instructions
    if (messages.length > 0 && context) {
      const documents = context.documents || [];
      // Format documents for the prompt
      const formattedDocuments = documents
        .map((doc, index) => {
          // Create source identifier with link using example URL pattern
          const sourceId = `source=${index + 1}&link=https://example.com/${encodeURIComponent(doc.source_display_name || doc.filename)}`;

          // Return formatted chunk with source
          return `[${sourceId}]\n${doc.text}`;
        })
        .join("\n\n");

      messages[messages.length - 1].content = `
You are tasked with answering a question using provided chunks of information. Your goal is to provide an accurate answer while citing your sources using a specific markdown format.

Here is the question you need to answer:
<question>
${messages[messages.length - 1].content}
</question>

Below are chunks of information that you can use to answer the question. Each chunk is preceded by a 
source identifier in the format [source=X&link=Y], where X is the source number and Y is the URL of the source:

<chunks>
${formattedDocuments}
</chunks>

Your task is to answer the question using the information provided in these chunks. 
When you use information from a specific chunk in your answer, you must cite it using a markdown link format. 
The citation should appear at the end of the sentence where the information is used.

If you cannot answer the question using the provided chunks, say "Sorry I don't know".

The citation format should be as follows:
[Chunk source](URL)

For example, if you're using information from the chunk labeled [source=3&link=https://example.com/page], your citation would look like this:
[3](https://example.com/page) and would open a new tab to the source URL when clicked.
`;
    }

    console.log(`Sending messages to ${llmProvider.toUpperCase()} LLM (${model})`, messages);

    // Select the appropriate model based on the provider
    const llmModel = llmProvider === "openai" ? openai(model) : (groq(model) as any); // Cast as any for groq to handle type issues

    const result = await streamText({
      model: llmModel,
      system:
        "You are a helpful assistant. You always generate your responses as correctly structured, valid markdown.",
      messages,
    });

    return result.toDataStreamResponse();
  } catch (error: any) {
    console.error("Error in chat API:", error);
    return new Response(
      JSON.stringify({
        error: error.message || "An unexpected error occurred",
      }),
      { status: 500, headers: { "Content-Type": "application/json" } },
    );
  }
}

const retrieveData = async (
  question: string,
  messages: CoreMessage[],
): Promise<RetrievalContext> => {
  const token = process.env.VECTORIZE_TOKEN;
  const pipelineRetrievalUrl = process.env.VECTORIZE_RETRIEVAL_URL;

  if (!token) {
    throw new Error(
      "VECTORIZE_TOKEN is not set in the environment variables. Please add it to your environment settings (e.g. .env.develoment) file.",
    );
  }

  if (!pipelineRetrievalUrl) {
    throw new Error(
      "VECTORIZE_RETRIEVAL_URL is not set. Please define the URL in the environment settings (e.g. in the file .env.development) before calling retrieveData.",
    );
  }

  const payload: any = {
    question,
    numResults: 5,
    rerank: true,
  };

  if (messages && messages.length > 0) {
    payload.context = {
      messages: messages.map((message) => ({ role: message.role, content: message.content })),
    };
  }

  try {
    const response = await fetch(pipelineRetrievalUrl, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        Authorization: token,
      },
      body: JSON.stringify(payload),
    });

    if (!response.ok) {
      const errorText = await response.text();
      throw new Error(
        `Failed to fetch data: ${response.status} ${response.statusText}. ${errorText}`,
      );
    }

    const data = await response.json();
    return data as RetrievalContext;
  } catch (error: any) {
    console.error("Error retrieving data:", error);
    throw new Error(`Failed to retrieve data: ${error.message}`);
  }
};
