---
title:  "Learning gradio"
layout: post
categories: media
---

Today I was playing with the hugging face API when I was following the gradio course on deep learning.ai ; in that course they use the python request API to make calls out to hugging face's inference API;

For these courses, rather than using the notebook and hitting shift enter on each cell, I'm actually copying and pasting the code onto my local machine and running from here because I'm hoping the knowledge will stick more. It's  been proving fruitful because I feel like I'm actually owning the code more. And often times it's not even that smooth a transition. I have to make modifications, which is forcing me to think and learn.

 so a few things:
 1. I'm embracing the UV system as opposed to PIP. And I really like these in line script dependencies where I can run things in an isolated context. So I start by doing that. And then I can do `uv run xxx` ; the alternative is to use venv and I use `uv add <module>` which modifies the pyproject.toml and then I execute `uv run xxx`
 2. I also needed to obtain API keys from a different providers like Gemini, HuggingFace, etc. and monitor costs incurred; this was educational as well
 3. With the gradio course in particular, I learned that the HuggingFace inference api that uses `https://api-inference.huggingface.co/` is deprecated and now uses: `https://router.huggingface.co/hf-inference/`
 4. Lesson 2 in that gradio course employs the `Salesforce/blip-image-captioning-base` model to do image-to-text captioning. And with that success from lesson one, I thought this would be easy to do. Not so! I kept getting 404 errors and couldn't figure out why. I mean it worked with the models from Lesson one! I believe now that after looking at the model page, there are no inference providers for that model, hence nothing to pick up my request! I can try again with another model that has an inference provider. Or I can just download the model myself and use it (as I did with the other deep learning course); after all, learning gradio is the objective here!