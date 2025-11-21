---
title:  "Lessons Learned from using Streaming APIs"
layout: post
categories: coding
---

I was trying out various tutorials to learn AI, specifically Google's ADK and a course on Gradio at [Deeplearning.ai](deeplearning.ai); both courses featured code in notebooks that sourced from APIs and both seemed like they did streaming. But I wanted a deeper understanding of how this mechanism worked. Cuz I'm old and I've been out of the coding game for quite some time so have little to no experience with streaming. :smile:


Here is the ADK code snippet:

```python
or query in user_queries:
        print(f"\nUser > {query}")
        query_content = types.Content(role="user", parts=[types.Part(text=query)])

        # Stream agent response
        async for event in runner_instance.run_async(
            user_id=USER_ID, session_id=session.id, new_message=query_content
        ):
            if event.is_final_response() and event.content and event.content.parts:
                print(f"Got final!")
                text = event.content.parts[0].text
                if text and text != "None":
                    print(f"Model: > {text}")
```

So in this code snippet, a few observations:
1. the action is happening inside the ``async for`` loop; According to ChatGPT, this loop is returning back events that are streamed asynchronously so there is no blocking happening here.

2. these events are logical events which can be *final*, *partial*, *metadata*.

3. we keep going until we get a ``is_final_response()`` is True

Now here is the snippet from the Gradio course which uses the OpenAI chat completions API:

```python
def gen_ai_stream(input, **kwargs):
    print("Generating with kwargs:", kwargs)
    response = client.chat.completions.create(
      model="openai/gpt-4o",
      messages=[
        {
          "role": "user",
          "content": input
        }
      ],
      stream=True,
      **kwargs
    )
    return response

def respond():
    # This is called by the Gradio framework when a button is clicked
    ....
    stream = gen_ai_stream(prompt,
                            max_tokens=1024,
                            stop=["\nUser:", "<|endoftext|>"],
                            temperature=temperature)
                            #stop_sequences to not generate the user answer
    acc_text = ""
    #Streaming the tokens
    for idx, chunk in enumerate(stream):
            text_token = ""
            if chunk.choices and chunk.choices[0].delta.content:
                text_token = chunk.choices[0].delta.content
           
            # check for completion
            if chunk.choices and chunk.choices[0].finish_reason:
                break

            if idx == 0 and text_token.startswith(" "):
                text_token = text_token[1:]

            if not text_token:
                # skip empty tokens
                continue

            acc_text += text_token
            last_turn = list(chat_history.pop(-1))
            last_turn[-1] += acc_text
            chat_history = chat_history + [last_turn]
            yield "", chat_history
            acc_text = ""
```

Now here we are using a for loop as well to iterate through whatever the chat completions API gave us. So seems similar to what the first code snippet is doing. You can see in the call to chat.completions.create, we are passing ``stream=True``.
But hold on!

According to ChatGPT:
1. the chat completions API is returning synchronous token-like chunks
2. the chat completions API is returning incremenal deltas
3. these chunks or deltas are low-level and are basically tokens unlike the higher-level event data the Google ADK gives us.
4. Since there is a yield inside the for loop, this makes the function into a generator which means this is **synchronous**.
5. we keep going until we get a ``finish_reason``

With Google's ADK, there is no manual accumulation of partial tokens. You simply wait for a final event and extract the text. However with the OpenAI code, we're following an 'incremental accumulation' streaming pattern.

I think one challenge I had is that thinking something is streaming automatically implies running async. But this is false. The OpenAI code is running synchronously in the for loop, but we are using the generator property to yield so that the GUI doesn't hang. It makes it seem asynchronous because 2 things seem to be happening.

According to ChatGPT:
> "The yield allows streaming-like behavior — but not necessarily async behavior. Your OpenAI example is not async, just incrementally synchronous... This looks like async because the UI or caller receives partial results incrementally. But control flow stays in one thread and the caller blocks until next chunk arrives."

And you can actually use yield in async as well!
```python
async def event_stream():
    while True:
        result = await get_next_chunk()
        yield result
```
(which I won't explore for the time being, but yes, there are possibilities!)

Incidentally, with regard to the ADK code, the fact that we don't do anything with intermediate results and just wait for a final response, seems to indicate synchronous behavior. We just loop and discard anything coming in until we get the final response.
But ChatGPT says that even though we only use the final response, there are plenty of reasons why the API is async; primarily that the call may take time and shouldn't block the thread.

> Yes, logically you could handle it synchronously if you only care about the final output —
but the ADK exposes streaming as async to support richer agent event workflows, scalability, and non-blocking operation.












