---
title:  "Exploring Python Async"
layout: post
categories: coding
---

This whole exploration into Python async driven by LLM coding has been really interesting.
I wanted to understand this better as I couldn't really grok it. My mental model is still treating an *async for loop* as just a regular for loop but there are differences!

## Async routines are coroutines
These functions with async in front are known as coroutines. I know that the term 'coroutines' is used in Go but never really looked into it. So I suppose Python has adopted them. (I know I can look up the story behind all this in an chatbot but just spitballing this for now)

**Update after diving deeper:** Coroutines are actually a general programming concept that predates both Python and Go! They're functions that can pause and resume execution. Python's `async/await` syntax (introduced in Python 3.5) is its implementation of coroutines for asynchronous programming.

Go has goroutines, which are different - they're lightweight threads managed by the Go runtime that use preemptive multitasking rather than cooperative multitasking. In Go, you launch a goroutine with the `go` keyword:
```go
go fetchData(url)  // Runs concurrently, scheduler decides when to switch
```

The key difference: Go's scheduler can interrupt goroutines at any point, while Python's coroutines must explicitly `await` to yield control. Go also uses channels for communication between goroutines:
```go
ch := make(chan string)
go func() {
    result := fetchData(url)
    ch <- result  // Send to channel
}()
data := <-ch  // Receive from channel
```

So while both enable concurrency, the mechanisms are quite different - Go's goroutines are more like lightweight threads, while Python's coroutines are cooperative tasks managed by an event loop.

And I probably should see how Python's async/await relates to Javascript's async/await. Another topic to ask the chatbots about...

**JavaScript async/await:** Actually very similar to Python! JavaScript also uses cooperative multitasking with an event loop. The syntax is nearly identical:
```javascript
// JavaScript
async function fetchData(url) {
    const response = await fetch(url);
    return await response.json();
}

// Python
async def fetch_data(url):
    async with aiohttp.ClientSession() as session:
        async with session.get(url) as response:
            return await response.json()
```

Both languages use the same model: async functions return promises/coroutines, await pauses execution, and an event loop manages everything. JavaScript had async/await first (ES2017), and both were inspired by earlier languages like C#.

Python's event loop is managing these coroutines and whenever there's an await called within these async routines, the event loop picks another coroutine to run.

This seems like a classic case of cooperative multitasking!


## Mental Model

The async for loops used in my streaming blogpost threw me for a loop (ha) and my mental model for understanding them was not grasping it. Like it's a for loop. Just loop! Why is there an async there and why do you need it?

Here's what the chatbot said:

> Without async for, you couldn't properly iterate over results that require async operations to produce.

> In short: async for is necessary when the act of getting the next item itself is an async operation that needs to be awaited.

So in the Google ADK example:
```python
 # Stream agent response
        async for event in runner_instance.run_async(
            user_id=USER_ID, session_id=session.id, new_message=query_content
        ):
            # do stuff
```

the async for is needed because the loop is dependent on an asynchronous operation itself. The `run_async()` method is an async generator that's making network calls to get each event - it's literally awaiting the next chunk of streaming data from the API before yielding it. You can't use a regular for loop because each iteration requires an async operation (waiting for network data).

I've been informed that if you forget the async and use a vanilla for loop, the interpreter will complain that the object is not iterable, meaning your for loop is not iterating over the right thing. So should be easily correctable. You'll get something like: `TypeError: 'async_generator' object is not iterable` - which is Python's way of saying "this needs async for, not for!"

## Example

I got this example as part of my interaction:

```python
async def async_range(count):
    for i in range(count):
        await asyncio.sleep(0.5)
        yield i

async def iterate_example():
    async for number in async_range(5):
        print(number)
```

I entered this code into the interpreter but nothing happened. Then I realized: "oh, these are def-ed". I need to actually call the function. So I invoked `iterate_example()` but I got back: `<coroutine object iterate_example at 0x101113240>`

So now I'm scratching my head... how do I run this?
Of course AI tells me:

>Ah yes! You need to actually run the coroutine. When you just call iterate_example(), it creates a coroutine object but doesn't execute it.
You need to use asyncio.run() as in `asyncio.run(iterate_example())`

along with a further explanation:

### Why this happens
async def functions don't run immediately when called - they return a coroutine object that needs to be executed by an event loop. You have three main ways to run them:

asyncio.run() - Use this at the top level (starts a new event loop)

await - Use this inside another async function
Manually with event loops (More advanced usage)

So the pattern is:

Top-level: asyncio.run(my_async_function())
Inside async functions: await my_async_function()

That's why you saw the coroutine object instead of the output - Python was showing you the unevaluated coroutine!