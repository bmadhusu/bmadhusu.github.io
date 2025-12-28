---
title:  "AI Agent and Skill Setup (Cursor)"
layout: post
categories: coding
---
### Set up of Skills in Cursor
This post details the steps to get the skills capability running in Cursor which I have a year-long subscription to and want to maximize usage of before having to pay for Claude or OpenAI.


So I followed the steps here:
1. Since Cursor doesn't seem to have skills natively just yet BUT has adopted the skills specification here: [Overview - Agent Skills](https://agentskills.io/home); why I say not natively as of yet is because you have to enable nightly builds in Cursor settings to get this to work, which I haven't done because I'm not that *cutting edge*. 
2. BUT there is a way to get skills to work in Cursor by using this beauty: [GitHub - numman-ali/openskills: Universal skills loader for AI coding agents - npm i -g openskills](https://github.com/numman-ali/openskills) ;
	- I ran:
```
npm i -g openskills
openskills install anthropics/skills
```
Then go to a project folder and then run `openskills sync`. This last command will amend your AGENTS.md file with knowledge of skills. The AGENTS.md file at this point is pretty universal among AI clients and agents and is used to direct your working agents. NOTE that you can also run the openskills command with universal or global options, but I am risk-averse so I didn't run with these options (which you can!); 
3. So installing these skills was really awesome because now I have the ability to use PDF, Excel, Word and a bunch of other skills that I didn't have access to before! And I created a few things for fun! I have ideas galore to do things for work and other personal projects.
4. Now for the main event: [GitHub - obra/superpowers: Claude Code superpowers: core skills library](https://github.com/obra/superpowers)
	- I've been wanting to try this for some time as it makes use of skills to enhance the software creation process
	- Thanks to this post for marrying openskills with superpowers: [Give Cursor Superpowers - Guides - Cursor - Community Forum](https://forum.cursor.com/t/give-cursor-superpowers/144578)
	- These commands should do the trick (after cd'ing to the project folder):
		- `openskills install obra/superpowers`
		- `openskills sync`
	- Your AGENTS.md file will now have superpowers installed and Cursor should follow it. 

### Go Time
So now I was ready to go! I gave Cursor a description of my idea and the brainstorming skill kicked in and asked me a series of questions.
I love this aspect of LLMs: they do a great job of asking insightful questions and taking feedback and iterating on ideas and making terrific suggestions; This feature is something that I don't use as often as I should.

It then created a design document and committed it to git. Then it offered me the option to start building or create an implementation plan. I went with the latter and so it created one.

Then it asked me;
>Two execution options:
>1. Subagent-Driven (this session) - I dispatch a fresh subagent per task, review between tasks, fast iteration. Good for working through it now.
>2. Parallel Session (separate) - Open a new Cursor session, use the executing-plans skill to batch execute with checkpoints. Good if you want to continue later.

I went with Option 1 as it seemed that the latest update to Superpowers made it easy to do.

BUT...
it basically ran through all 23 steps of the implementation plan without stopping and finally gave me a working prototype. There was no 'review between tasks' as advertised.

Furthermore it didn't exercise one of the superpowers: TDD. I was hoping to see this in action. I asked it why.

>You're absolutely right to call this out. This is a significant gap in the implementation.
>Looking at the project skills, there's a test-driven-development skill that explicitly states:
>
> "Use when implementing any feature or bugfix, before writing implementation code"
> 
And the subagent-driven-development skill I invoked says:
> "Subagents should use: superpowers:test-driven-development - Subagents follow TDD for each task"
I failed to follow this. The implementation went straight to writing feature code without writing failing tests first. This was a process failure on my part.

WTF!
1. There were other things that were ignored: e.g. code reviews (both requesting and receiving them), verification before completion, finishing a dev branch, etc. basically most of them!
2. Also, the subagent piece didn't seem to do anything. It just executed all the tasks in one chat window, sequentially.

It sounds like the implementation plan should have had these  steps baked in there. So the agent must have just blindly followed the plan without referring to the superpowers. If I had made sure the implementation plan had "Use TDD" in there along with the others, it might have executed more in line with what the superpowers dictated.
