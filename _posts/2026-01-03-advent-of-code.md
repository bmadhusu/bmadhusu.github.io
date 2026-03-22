---
title:  "Advent of Code Puzzles"
layout: post
categories: coding
---
### Solving puzzles
Solving Advent of Code puzzles is fun! and a great way to learn a new language. I started the 2025 puzzles along with everyone else, when they were released on 1-Dec-2025. It was my first foray into doing them and it felt fun to be part of a collective effort, learning and comparing notes. The puzzles are not easy, especially if you are out of practice! I mean, the first puzzle for each day is not so bad, but each day has 2 puzzles, the second of which gets unlocked if you solve the first puzzle; and the second puzzle is way more challenging than the first.

When AoC (Advent of Code) started, I was in the midst of re-skilling myself with NeoVim and keyboard shortcuts, tmux, etc. I wasn't ready to go into Clojure territory just yet, so I tackled the puzzles in Python which I'm much more fluent in. However, I only lasted 4 days because (just because). 

Now a month later, I'm more comfortable with Tmux and Neovim; I have Clojure and Conjure setup as well as LSPs, parinfer, and all that good stuff. Heck, I even subscribed to Claude Code Max! So now I'm a code warrior, I suppose. Thanks to holiday specials, I got *Programming Clojure, 4th Edition* at a discount so I've been reading that as well.

### Day 5

I started on the puzzles for Day 5 and whoah. I know the puzzles get progressively harder, but my first solution just didn't cut the mustard. I used sets and the problem with that was that the ranges used were gigantic! Take for example: 81344892339775-81647378719492 as just one of the sample inputs. This is *HUGE*. I used ranges to represent these, but then by using sets, I was asking Clojure/Java to 'realize' each individual element in that range, (and do this for a bunch of similar ranges!). Each Java Long takes ~24 bytes, so if I had a billion elements, it would require 24 GB of memory!

So my solution ran out of memory.
Also, if I were to do this in Python, it would have resulted in the same memory error.

I wasn't sure how to go about it without sets so I consulted with my various AI buddies and gave me the idea of using ranges instead, simply denoting the start and ends of each range. Then using math to see if each ingredient was within one of the ranges. Much faster!

One technique is to emply laziness, which I thought I was doing, but had no idea what impact using sets had. I didn't know about laziness in general, so this was a very good exercise for me. In fact, I had just covered the lazy sequence chapter in the book at just about the same time, so it all came together!

Needless, to say this first puzzle threw me for a loop, but I got the answer. That's when I got to Puzzle #2.

Here, you need to basically merge ranges together. I sketched out a solution on paper and thought it could work, but it was not going to be easy. In fact this is where my tendency to commit too early to a solution when solving problems was leading me astray (as opposed to considering a wider array of approaches initially).

I fed my approach to AI and it was very good at coaching me out of it! It gave me edge cases where my algorithm would turn into a mess. It was do-able but it was going to get quite complicated. Instead it suggested a much more reasonable path forward. This path included sorting the ranges from low to high and then walking through them and merging overlapping ones. Each time I wrote some code, I fed it into AI and it gave me more idiomatic ways to write the code. So that was another great way to learn.

So Day 5 is done. I will proceed with the other days in a similar fashion. Hopefully my Clojure becomes more fluent and idiomatic moving forward. However, the problems themselves seem like they'll become more challenging!

I also want to go back to Days 1-4 which I did using Python and do the second puzzles for those days as well.

### UPDATE
I made it to Day 10 and then went on vacation. And when I got back, other things came to the fore: notably AI fever! I realized I needed to learn/avail myself of these new tools, and that hand-coding was going to become akin to working on a custom car in your garage. 

Clojure and thinking functionally is beautiful and elegant and something I want to get back to, but for now, I'm pivoting to exploring AI and its myriad uses...